// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_event.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_state.dart';
import 'package:invo_mobile/blocs/settle_page/settle_page_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/Service.dart' as model;
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:oktoast/oktoast.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:collection/collection.dart';

import '../../service_locator.dart';

class RecallPageBloc extends BlocBase {
  bool _isThereIsOrderSelected = false;
  bool isDelivery = false;
  bool setteldOrders = true;
  //events ( for all streams )
  final _eventController = StreamController<RecallPageEvent>.broadcast();
  Sink<RecallPageEvent> get eventSink => _eventController.sink;

  NavigatorBloc? _navigationBloc;
  List<MiniOrder>? allOrders = List<MiniOrder>.empty(growable: true);
  List<MiniOrder>? paidOrders = List<MiniOrder>.empty(growable: true);

  OrderHeader? order;
  List<model.Service> services = List<model.Service>.empty(growable: true);
  Property<model.Service> selectedService = Property<model.Service>();

  Property<OrderViewState> orderState = Property<OrderViewState>();
  Property<List<MiniOrder>> openOrder = Property<List<MiniOrder>>();
  Property<List<MiniOrder>> deliveredOrder = Property<List<MiniOrder>>();
  Property<List<MiniOrder>> paidOrder = Property<List<MiniOrder>>();

  Property<PopupPanelState> popup = new Property<PopupPanelState>();
  SettlePageBloc? settlePageBloc;
  Privilege priv = new Privilege();

  ConnectionRepository? connectionRepository;
  int get noOfTabs {
    if (selectedService.value!.id == 4) {
      if (!priv.checkPrivilege1(Privilages.Setteld_Orders)) {
        return 2;
      } else {
        return 3;
      }
    }

    if (selectedService.value!.id == 1) {
      if (selectedService.value!.showTableSelection) {
        return 1;
      } else {
        return 2;
      }
    }

    if (!priv.checkPrivilege1(Privilages.Setteld_Orders)) {
      return 1;
    }
    return 2;
  }

  bool get isKeyPadVisible {
    return (this.selectedService.value!.id == 2 || this.selectedService.value!.id == 4);
  }

  Timer? ordersTimer;
  Timer? orderTimeTimer;
  RecallPageBloc(NavigatorBloc navigationBloc, {model.Service? service}) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();

    this.services = connectionRepository!.services!.take(4).toList();
    this.selectedService.sinkValue(service!);
    this.order = null;

    _eventController.stream.listen(_mapEventToState);
    if (this.selectedService.value!.id == 1 && this.selectedService.value!.showTableSelection) {
      loadPaidOrders(DateTime.now());
    } else {
      loadOrders(null);
    }
    if (selectedService.value!.id != 0) {
      ordersTimer = new Timer.periodic(const Duration(seconds: 15), loadOrders);
      orderTimeTimer = new Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_navigationBloc!.currentPage != "RecallPage") return;
        if (allOrders != null)
          for (var item in allOrders!) {
            item.updated!.sinkValue(true);
          }
      });
    }
    if (selectedService.value!.id == 0) {
      orderTimeTimer = new Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_navigationBloc!.currentPage != "RecallPage") return;
        if (allOrders != null)
          for (var item in allOrders!) {
            item.updated!.sinkValue(true);
          }
      });
    }

    if (!priv.checkPrivilege1(Privilages.Setteld_Orders)) {
      setteldOrders = false;
    }

    print("noOfTabs: ${noOfTabs}");
  }

  bool get isSearchVisible => selectedService.value!.id == 0;
  void loadOrders(Timer? timer) async {
    if (_navigationBloc!.currentPage != "RecallPage") return;
    int selectedOrderId = (order != null) ? order!.id : 0;

    //fetchFillteredOrders(serche,from,to,status , service)
    if (selectedService.value!.id == 0) {
      // DateTime startDate, DateTime endDate, String searchText, int service, int status
      allOrders = (await locator.get<ConnectionRepository>().orderService!.fetchAllOrders(DateTime.now(), DateTime.now(), "", selectedService.value!.id, 0))!;
      //print(allOrders.length);
    } else {
      allOrders = await locator.get<ConnectionRepository>().fetchServiceOrder(selectedService.value!.id);
    }

    if (allOrders != null) {
      MiniOrder? temp = allOrders!.isNotEmpty
          ? selectedOrderId != 0
              ? allOrders!.firstWhereOrNull((f) => f.id == selectedOrderId)
              : null
          : null;
      if (temp != null) temp.isSelected = true;
    }

    setOrders();
  }

  void setOrders() {
    if (allOrders != null) {
      openOrder.sinkValue(allOrders!.where((f) => f.arrival_time == null).toList());
      deliveredOrder.sinkValue(allOrders!.where((f) => f.arrival_time != null).toList());
    }
    paidOrder.sinkValue(paidOrders ?? List<MiniOrder>.empty(growable: true));
  }

  void changeService(model.Service service) {
    selectedService.sinkValue(service);
    orderState.sinkValue(OrderIsHidden(isKeyPadVisible: isKeyPadVisible));
    loadOrders(null);
  }

  void _mapEventToState(RecallPageEvent event) async {
    if (event is LoadPaidOrders) {
      loadPaidOrders(event.date);
    } else if (event is ClickNewOrder) {
      newOrder(event);
    } else if (event is LoadCustomer) {
      _loadCustomer(event.phone);
    } else if (event is TakeOrderFirst) {
      takeOrderFirst();
    } else if (event is EditOrder) {
      editOrder();
    } else if (event is PrintOrder) {
      printOrder();
    } else if (event is PayOrder) {
      payOrder(orientation: event.orientation);
    } else if (event is VoidOrder) {
      voidOrder(event);
    } else if (event is SearchOrder) {
      allOrders = (await locator.get<ConnectionRepository>().orderService!.fetchAllOrders(event.model.start_date!, event.model.end_date!, event.model.searchText, event.model.service, event.model.status))!;
      setOrders();
    } else if (event is FollowUpOrder) {
      followUpOrder();
    } else if (event is ClickOnOrderSummary) {
      loadOrder(event);
    } else if (event is ChangeService) {
      changeService(event.service!);
    } else if (event is DiscountOrder) {
      discountOrder(event);
    } else if (event is DiscountClicked) {
      discountClicked(event);
    } else if (event is SurchargeOrder) {
      surchargeOrder(event);
    } else if (event is SurchargeClicked) {
      surchargeClicked(event);
    } else if (event is GoBack) {
      _navigationBloc!.navigatorSink.add(NavigateToHomePage());
    }
  }

  void loadOrder(ClickOnOrderSummary event) async {
    if (event.orientation == Orientation.landscape) if (order != null && order!.id == event.order!.id && orderState is OrderIsLoaded) return;

    resetOrderSelection();
    event.order!.isSelected = true;
    setOrders();

    orderState.sinkValue(OrderIsLoading());
    if (event.orientation == Orientation.portrait) {
      locator<DialogService>().showLoadingDialog();
    }

    order = await locator.get<ConnectionRepository>().fetchFullOrder(event.order!.id);

    print("order loaded:" + order!.id.toString());
    //check if discount has assigned items and put it in the discount reference
    // ignore: curly_braces_in_flow_control_structures
    if (order!.discount != null) if (order!.discount!.id > 0 && order!.discount != null) {
      order!.discount!.items = await locator.get<ConnectionRepository>().discounts!.firstWhere((f) => f.id == order!.discount!.id, orElse: () => Discount(items: [], name: '')).items;
    }

    order!.calculateItemTotal();

    Future.delayed(Duration(milliseconds: 300), () {
      orderState.sinkValue(OrderIsLoaded(order: order!));
      if (event.orientation == Orientation.portrait) {
        locator<DialogService>().showPopupTicketDialog(order!);
        resetOrderSelection();
        setOrders();
      }
    });
  }

  void newOrder(ClickNewOrder event) async {
    Privilege priv = Privilege();
    if (!priv.checkPrivilege(Privilages.new_order)) return;

    if (selectedService.value!.id == 2 || selectedService.value!.id == 4) {
      if (event.orientation == Orientation.portrait) {
        String? resault;
        if (selectedService.value!.id == 2) {
          resault = await locator<DialogService>().showRecallTelephoneDialog(DialogRequest(actions: [
            DialogButton(
              content: "WalK In Customer",
              onTab: () {
                takeOrderFirst();
              },
              closeOnTab: true,
            )
          ]));
        } else if (selectedService.value!.id == 4) {
          resault = await locator<DialogService>().showRecallTelephoneDialog(DialogRequest(actions: [
            DialogButton(
              content: "Take Order First",
              onTab: () {
                takeOrderFirst();
              },
              closeOnTab: true,
            )
          ]));
        }

        if (resault != "") {
          _loadCustomer(resault!);
        }
      } else {
        order = null;
        resetSelection();
      }
    } else {
      _navigationBloc!.navigatorSink.add(NavigateToOrderPage(service: selectedService.value));
    }
  }

  resetSelection() {
    orderState.sinkValue(OrderIsHidden(isKeyPadVisible: isKeyPadVisible));
    resetOrderSelection();
    setOrders();
  }

  void takeOrderFirst() {
    _navigationBloc!.navigatorSink.add(NavigateToOrderPage(service: selectedService.value));
  }

  void editOrder() async {
    Employee? authEmployee = locator.get<Global>().authEmployee;
    if (authEmployee == null) return;

    if (order!.employee_id != authEmployee.id) {
      //check if employee allow to edit other employee order
      Privilege priv = Privilege();
      if (!priv.checkPrivilege(Privilages.edit_order)) return;
    }

    bool resault = await _navigationBloc!.navigateToOrderPage(NavigateToOrderPage(service: selectedService.value, order: this.order));

    resetSelection();
    order = null;
  }

  void printOrder() async {
    try {
      Privilege priv = Privilege();
      if (!priv.checkPrivilege(Privilages.print_order)) return;

      locator.get<DialogService>().showLoadingProgressDialog();

      Terminal? terminal = locator.get<ConnectionRepository>().terminal;
      // if (terminal!.printerType == "USB Printer") {
      //   PrintService printService = PrintService(terminal);
      //   await printService.printOrder(order!);
      // } else
      if (terminal!.bluetoothPrinter == "" || terminal.bluetoothPrinter == "null") {
        await locator.get<ConnectionRepository>().printOrder(order!);
      } else {
        PrintService printService = PrintService(terminal);
        await printService.printOrder(order!);
      }
      locator.get<DialogService>().closeDialog(); //close loading dialog
    } catch (e) {
      print(e.toString());
    }
  }

  void payOrder({OrderHeader? tempOrder, Orientation? orientation}) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    if (tempOrder != null) order = tempOrder;
    if (order == null) return;
    if (order?.status == 3 || order?.status == 4) return; //if paid or void ticket
    Privilege priv = Privilege();
    if (!priv.checkPrivilege(Privilages.settle_order)) return;
    if (locator.get<Global>().authCashier == null) {
      locator<DialogService>().showDialog(appLocalizations.translate("Cashier In First"), appLocalizations.translate("Cashier In First to access pay function"));
      return;
    }
    for (var item in this.order!.payments) {
      if (item.status == -1) {
        locator<DialogService>().showDialog(appLocalizations.translate("There is an online payment"), appLocalizations.translate("Check the domain cashier"));
        return;
      }
    }

    settlePageBloc = SettlePageBloc(this.order!);
    settlePageBloc!.finish.stream.listen((complete) async {
      bool response = await connectionRepository!.orderService!.payOrder(order!, complete); //save
      if (response) {
        if (locator.get<ConnectionRepository>().preference!.printTicketWhenSettle) {
          //print
          Terminal? terminal = locator.get<ConnectionRepository>().terminal;
          PrintService printService = PrintService(terminal!);

          await printService.printOrder(order!, drawer: false);
        }
        loadPaidOrders(DateTime.now());
        loadOrders(null);

        orderState.sinkValue(OrderIsHidden(isKeyPadVisible: isKeyPadVisible));
        if (orientation == Orientation.portrait) {
          locator<DialogService>().closeDialog();
        }
        if (Number.getDouble(order!.amountChange) >= 0 && Number.getDouble(order!.amountBalance) <= 0) {
          locator<DialogService>().showBalanceDialog(Number.formatCurrency(order!.amountChange), orderHeader: order);
        } else {
          // popup.sinkValue(null);
        }
      }
    });

    popup.sinkValue(RecallPayPanel());
  }

  void voidOrder(VoidOrder event) async {
    String? lang = locator.get<ConnectionRepository>().terminal?.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));

    if (order!.id == 0) return;

    Privilege priv = Privilege();
    if (!priv.checkPrivilege(Privilages.void_order)) return;

    bool resault = await locator.get<DialogService>().showDialog(appLocalizations.translate("Void Order"), appLocalizations.translate("Are you sure you want to void the order"), okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));

    String reason = "";
    bool waste = false;

    if (resault) {
      //check reason
      if (locator.get<ConnectionRepository>().preference!.voidedItemNeedExplantion) {
        reason = await locator.get<DialogService>().noteDialog(appLocalizations.translate("Void Reason"));
        if (reason == "") {
          await locator.get<DialogService>().showDialog("", appLocalizations.translate("Voided Need Explantion"));
          return;
        }
      }

      //check waste
      waste = await locator.get<DialogService>().showDialog(appLocalizations.translate("Waste Order"), appLocalizations.translate("Is It Waste?"), okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));

      //save
      locator.get<DialogService>().showLoadingProgressDialog();
      bool? response = await locator.get<ConnectionRepository>().voidOrder(order!, locator.get<Global>().authEmployee!.id, reason, waste);
      locator.get<DialogService>().closeDialog();

      if (response!) {
        showToast(appLocalizations.translate("Order#") + order!.id.toString() + ' Has Been Voided', duration: Duration(seconds: 5), backgroundColor: Colors.green, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));

        //remove order
        MiniOrder? temp = allOrders!.firstWhereOrNull((f) => f.id == order!.id);
        if (temp != null) {
          allOrders!.remove(temp);
          setOrders();
        }
        if (event.orientation == Orientation.portrait) locator.get<DialogService>().closeDialog();

        orderState.sinkValue(OrderIsHidden(isKeyPadVisible: isKeyPadVisible));
      }
    }
  }

  void followUpOrder() async {
    Privilege priv = new Privilege();
    locator.get<DialogService>().showLoadingProgressDialog();
    if (!priv.checkPrivilege(Privilages.followUp_order)) return;

    await locator.get<ConnectionRepository>().followUp(order!);
    locator.get<DialogService>().closeDialog();
  }

  void resetOrderSelection() {
    if (allOrders != null)
      for (var item in allOrders!) {
        item.isSelected = false;
      }

    if (paidOrders != null)
      for (var item in paidOrders!) {
        item.isSelected = false;
      }
  }

  void _loadCustomer(String phone) {
    if (phone == "" || phone == null) return;
    _navigationBloc!.navigatorSink.add(NavigateToCustomerPage(this.selectedService.value, phone: phone));
  }

  void discountOrder(DiscountOrder event) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    Privilege priv = new Privilege();
    if (!priv.checkPrivilege(Privilages.discount_order)) return;

    if (order!.discount_amount > 0) {
      bool resault = await locator.get<DialogService>().showDialog("Delete Discount", "Are you sure you want to remove discount", okButton: "Yes", cancelButton: "No");
      if (resault) {
        locator.get<DialogService>().showLoadingProgressDialog();
        bool? response = await locator.get<ConnectionRepository>().discountOrder(order!, null, locator.get<Global>().authEmployee!.id);
        locator.get<DialogService>().closeDialog();
        if (response!) {
          order!.deleteDiscount();
        } else
          locator.get<DialogService>().showDialog("", appLocalizations.translate("Failed To Save"));
      }

      return;
    }
    popup.sinkValue(RecallDiscountPanel(locator.get<ConnectionRepository>().discounts!));
  }

  void discountClicked(DiscountClicked event) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    locator.get<DialogService>().showLoadingProgressDialog();
    bool? response = await locator.get<ConnectionRepository>().discountOrder(order!, event.discount, locator.get<Global>().authEmployee!.id);
    locator.get<DialogService>().closeDialog();
    if (response!)
      order!.addDiscount(event.discount);
    else {
      locator.get<DialogService>().showDialog("", appLocalizations.translate("Failed To Save"));
    }
  }

  void surchargeOrder(SurchargeOrder event) async {
    Privilege priv = new Privilege();
    if (!priv.checkPrivilege(Privilages.surcharge_order)) return;

    // if (order.surcharge_amount > 0) {
    //   bool resault = await locator.get<DialogService>().showDialog(
    //       "Delete Surcharge", "Are you sure you want to remove surcharge",
    //       okButton: "Yes", cancelButton: "No");
    //   if (resault) {
    //     locator.get<DialogService>().showLoadingProgressDialog();
    //     bool response = await locator
    //         .get<ConnectionRepository>()
    //         .surchargeOrder(order, null);

    //     locator.get<DialogService>().closeDialog();
    //     if (response) {
    //       order.deleteSurcharge();
    //     } else {
    //       locator.get<DialogService>().showDialog("", "Failed To Save");
    //     }
    //   }
    //   return;
    // }

    popup.sinkValue(RecallSurchargePanel(locator.get<ConnectionRepository>().surcharges!));
  }

  void surchargeClicked(SurchargeClicked event) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    locator.get<DialogService>().showLoadingProgressDialog();
    bool? response = await locator.get<ConnectionRepository>().surchargeOrder(order!, event.surcharge);
    locator.get<DialogService>().closeDialog();
    if (response!)
      order!.addSurcharge(event.surcharge);
    else
      locator.get<DialogService>().showDialog("", appLocalizations.translate("Failed To Save"));
  }

  void dispose() {
    _eventController.close();
    orderState.dispose();
    deliveredOrder.dispose();
    openOrder.dispose();
    paidOrder.dispose();
    if (selectedService.value!.id != 0) {
      ordersTimer!.cancel();
      orderTimeTimer!.cancel();
    }
    if (allOrders != null)
      // ignore: curly_braces_in_flow_control_structures
      for (var item in allOrders!) {
        item.dispose();
      }

    allOrders = null;

    if (paidOrders != null)
      for (var item in paidOrders!) {
        item.dispose();
      }
    paidOrders = null;

    if (order != null) order!.dispose();
    order = null;
  }

  void loadPaidOrders(DateTime date) async {
    paidOrder.sinkValue(List<MiniOrder>.empty(growable: true));
    paidOrders = await locator.get<ConnectionRepository>().fetchServicePaidOrders(selectedService.value!.id, date);
    paidOrder.sinkValue(paidOrders ?? List<MiniOrder>.empty(growable: true));
  }
}
