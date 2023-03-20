import 'dart:async';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_state.dart';
import 'package:invo_mobile/blocs/home_page/home_page_bloc.dart';
import 'package:invo_mobile/models/Service.dart' as model;
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:invo_mobile/models/order/service_reference.dart';
import 'package:invo_mobile/models/order/dineIn_table_reference.dart';
import 'package:invo_mobile/models/order/employee_reference.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
import 'package:invo_mobile/services/InvoCloud/webSocket_IO.dart';

import '../../service_locator.dart';

class PendingPageBloc extends BlocBase {
  // ignore: close_sinks
  final _eventController = StreamController<PendingPageEvent>.broadcast();
  Sink<PendingPageEvent> get eventSink => _eventController.sink;
  bool _isThereIsOrderSelected = false;

  // ignore: unused_field
  NavigatorBloc? _navigationBloc;
  //HomePageBloc _homePageBloc;
  List<MiniOrder> pendingOrders = [];
  OrderHeader? order;
  int? orderPendingId;
  WebSocketIO? webSocketIO;

  Property<PopupPanelState> popup = new Property<PopupPanelState>();
  Property<List<MiniOrder>> pendingOrder = Property<List<MiniOrder>>();
  Property<OrderPendingViewState> orderState = Property<OrderPendingViewState>();

  ConnectionRepository? connectionRepository;

  PendingPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    orderState.sinkValue(OrderIsHidden());
    _eventController.stream.listen(_mapEventToState);
    webSocketIO = locator.get<WebSocketIO>();

    // webSocketIO.load();
    //_homePageBloc = new HomePageBloc(navigationBloc);
  }

  void _mapEventToState(PendingPageEvent event) async {
    if (event is LoadPendingOrders) {
      loadPendingOrders();
    } else if (event is ClickOnOrderSummary) {
      loadOrder(event);
    } else if (event is GoBack) {
      _navigationBloc!.navigatorSink.add(NavigateToHomePage());
    } else if (event is AcceptPendingOrder) {
      acceptPendingOrder(event);
    } else if (event is RejectPendingOrder) {
      rejectPendingOrder(event);
    } else if (event is PrintPendingOrder) {}
  }

  void rejectPendingOrder(RejectPendingOrder event) async {
    if (orderPendingId! > 0) {
      locator.get<ConnectionRepository>().orderService!.rejectPendingOrder(order!.GUID, orderPendingId!);
      loadPendingOrders();
      resetOrderSelection();
      setOrders();
      orderState.sinkValue(OrderIsHidden());
    }
  }

  void acceptPendingOrder(AcceptPendingOrder event) async {
    order!.calculateItemTotal();
    if (order!.status != 3) order!.status = 1;

    OrderHeader? _order = await locator.get<ConnectionRepository>().saveOrder(order!);
    if (_order!.id > 0) {
      //print
      Terminal? terminal = locator.get<ConnectionRepository>().terminal;

      PrintService printService = new PrintService(terminal!);

      if (terminal.bluetoothPrinter != "") {
        printService.printOrder(_order);
      }

      if (terminal.kitchenPrinter != null && terminal.kitchenPrinter != "") {
        printService.kitchenPrinter(_order);
        locator.get<ConnectionRepository>().orderService!.updatePrintedItem(_order);
      }
    }

    //remove order from pending
    locator.get<ConnectionRepository>().orderService!.removePendingOrder(orderPendingId!);
    //=========================================

    //send accept response to the cloud
    locator.get<ConnectionRepository>().orderService!.acceptPendingOrder(_order.GUID, _order.id, _order.ticket_number!);

    //reload orders
    loadPendingOrders();
    resetOrderSelection();
    setOrders();
    orderState.sinkValue(OrderIsHidden());
  }

  void loadOrder(ClickOnOrderSummary event) async {
    if (order != null && order!.id == event.order!.id && orderState is OrderIsLoaded) return;

    resetOrderSelection();
    event.order!.isSelected = true;
    setOrders();
    orderState.sinkValue(OrderIsLoading());

    if (event.orientation == Orientation.portrait) {
      locator<DialogService>().showLoadingDialog();
    }

    order = await locator.get<ConnectionRepository>().fetchFullPendingOrder(event.order!.id);
    orderPendingId = event.order!.id;

    if (order!.employee_id != null && order!.employee_id != 0) {
      order!.employee =
          EmployeeReference.fromEmployee(locator.get<ConnectionRepository>().employees!.firstWhere((element) => element.id == order!.employee_id));
    }

    if (order!.service_id != null && order!.service_id != 0) {
      order!.service =
          ServiceReference.fromService(locator.get<ConnectionRepository>().services!.firstWhere((element) => element.id == order!.service_id));
    }

    if (order!.dinein_table_id != null && order!.dinein_table_id != 0) {
      order!.dinein_table = DineInTableReference.fromTable(locator.get<ConnectionRepository>().dineInService!.getTable(order!.dinein_table_id!));
    }

    for (var item in order!.transaction) {
      item.menu_item = locator.get<ConnectionRepository>().menuItems!.firstWhere((f) => f.id == item.menu_item_id);
      item.date_time = order!.date_time;
      item.seat_number = 0;
      item.default_price = item.menu_item!.default_price;
      item.cost = item.menu_item!.default_price;
    }
    order!.calculateItemTotal();

    int cashier_id = (locator.get<Global>().authCashier != null ? locator.get<Global>().authCashier!.id : 0);
    int employee_id = (locator.get<Global>().authEmployee == null ? 0 : locator.get<Global>().authEmployee!.id);
    //check payment
    PaymentMethod payment;
    if (order!.payments != null) {
      for (var item in order!.payments) {
        payment = await getPaymentMethod(item.onlineService);
        order!.addOnlinePayment(payment, cashier_id, employee_id);
      }
    }
    //=================================================

    orderState.sinkValue(OrderIsLoaded(order: order));

    if (event.orientation == Orientation.portrait) {
      locator<DialogService>().showPopupPendingTicketDialog(order!);
      resetOrderSelection();
      setOrders();
    }
  }

  Future<PaymentMethod> getPaymentMethod(String type) async {
    switch (type) {
      case "Benefit Pay":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1100, "Online Benefit Pay");
        break;
      case "BenefitPay":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1100, "Online Benefit Pay");
        break;
      case "MaxWallet":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1101, "Online MaxWallet");
        break;
      case "KNET":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1102, "KNET");
        break;
      case "MPGS":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1103, "MPGS");
        break;
      case "Gatee":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1104, "Gatee");
        break;
      case "Thawani":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1105, "Thawani");
        break;
      case "Benefit":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1106, "Online Benefit");
        break;
      case "MyFatoorah":
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1104, "MyFatoorah");
        break;
      default:
        return await locator.get<ConnectionRepository>().paymentMethodService!.insertIfNotPaymentExists(1100, "Online Benefit Pay");
        break;
    }
  }

  void loadPendingOrders() async {
    pendingOrders = await locator.get<ConnectionRepository>().fetchPendingOrders();
    pendingOrder.sinkValue(pendingOrders);
    pendingOrders = await locator.get<ConnectionRepository>().fetchPendingOrders();
    pendingOrder.sinkValue(pendingOrders);
  }

  void resetOrderSelection() {
    if (pendingOrders != null)
      for (var item in pendingOrders) {
        item.isSelected = false;
      }
  }

  void setOrders() {
    pendingOrder.sinkValue(pendingOrders);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
