import 'dart:async';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/table_status.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import '../blockBase.dart';
import 'dinein_page_events.dart';
import 'package:collection/collection.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/blocs/blockBase.dart';

import '../../service_locator.dart';

class DineInPageBloc implements BlocBase {
  NavigatorBloc? _navigationBloc;
  List<DineInGroup>? dineInGroups;
  final _eventController = StreamController<DineInPageEvent>.broadcast();
  Sink<DineInPageEvent> get eventSink => _eventController.sink;

  Timer? tableOrderTimer;
  Timer? tableTimer;

  bool selectTable = false;
  bool setteldOrders = true;
  DineInPageBloc(NavigatorBloc navigationBloc, bool _selectTable) {
    _navigationBloc = navigationBloc;
    selectTable = _selectTable;
    dineInGroups = locator.get<ConnectionRepository>().dineInGroups;
    loadTableOrders(null);
    tableOrderTimer = new Timer.periodic(const Duration(seconds: 15), loadTableOrders);

    tableTimer = new Timer.periodic(const Duration(seconds: 1), updateTime);
    Privilege priv = new Privilege();
    if (!priv.checkPrivilege1(Privilages.Setteld_Orders)) {
      setteldOrders = false;
    }
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(DineInPageEvent event) async {
    Service? service = locator.get<ConnectionRepository>().services!.firstWhereOrNull((f) => f.id == 1);

    if (event is TableClick) {
      if (selectTable) {
        _navigationBloc!.popBack(event.table);
        return;
      }
      Privilege priv = Privilege();

      locator.get<DialogService>().showLoadingProgressDialog();
      List<OrderHeader>? _orders = await locator.get<ConnectionRepository>().loadOrders(event.table.id);

      if (_orders != null) {
        print(_orders.length.toString());
        for (var order in _orders!) {
          //check if discount has assigned items and put it in the discount reference
          if (order.discount != null) if (order.discount!.id > 0) {
            order.discount!.items = await locator.get<ConnectionRepository>().discounts!.firstWhereOrNull((f) => f.id == order.discount!.id)!.items;
          }
        }
      } else {
        print("no orders loaded");
      }

      locator.get<DialogService>().closeDialog();

      if (_orders == null || _orders.length == 0) {
        if (!priv.checkPrivilege(Privilages.new_order)) return;

        if (service != null) {
          bool? resault = await _navigationBloc!.navigateToOrderPage(NavigateToOrderPage(service: service, table: event.table));

          if (resault != null) {
            loadTableOrders(null);
          }
        }
      } else {
        Employee? authEmployee = locator.get<Global>().authEmployee;
        if (!priv.checkPrivilege1(Privilages.edit_order) && _orders.first.employee_id != authEmployee!.id) {
          return;
        }
        bool? resault = await _navigationBloc!.navigateToOrderPage(NavigateToOrderPage(service: service, table: event.table, orders: _orders));

        if (resault != null) {
          loadTableOrders(null);
        }
      }
    } else if (event is GoToRecallPage) {
      _navigationBloc!.navigatorSink.add(NavigateToRecallPage(service: service));
    } else if (event is DineInPageGoBack) {
      _navigationBloc!.navigatorSink.add(PopUp());
    }
  }

  List<TableStatus>? status;
  loadTableOrders(Timer? timer) async {
    if (_navigationBloc!.currentPage != "DineInPage") return;

    status = await locator.get<ConnectionRepository>().fetchTablesStatus();
    if (status != null) {
      TableStatus? temp;
      for (var group in dineInGroups!) {
        for (var table in group.tables!.toList()) {
          temp = status!.firstWhereOrNull((f) => f.table_id == table.id);
          if (temp != null) {
            table.tableStatus = temp;
            table.tableStatusSink.add(temp);
          } else {
            table.tableStatus = null;
            // table.tableStatusSink.add(null);
          }
        }
      }
    }
  }

  void updateTime(Timer timer) {
    for (var group in dineInGroups!) {
      for (var table in group.tables!.toList()) {
        table.duration!.sinkValue(true);
      }
    }
  }

  @override
  void dispose() {
    _eventController.close();
    tableOrderTimer!.cancel();
    tableTimer!.cancel();
    // for (var group in dineInGroups) {
    //   for (var table in group.tables) {
    //     table.dispose();
    //   }
    // }
    // TODO: implement dispose
  }
}
