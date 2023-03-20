import 'dart:async';
import 'dart:io';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/InvoCloud/webSocket_IO.dart';
import 'package:invo_mobile/services/Print/blue_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/services/WebSocket/webSocket_client.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/cashier.dart';

import 'package:invo_mobile/blocs/blockBase.dart';

import '../blockBase.dart';
import 'main_event.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import '../../service_locator.dart';
import 'dart:typed_data';

class MainBloc extends BlocBase {
  Timer? timeTimer;
  Property<bool> isINVOConnection = Property<bool>();
  var logo;
  WebSocketIO? webSocketIO;
  bool hasNewPending = false;

  NavigatorBloc? _navigationBloc;

  Property<DateTime> currentDate = Property<DateTime>();
  Property<String> employeeName = Property<String>();
  Property<bool> userSettings = Property<bool>();
  WebStockClient webStockClient = WebStockClient();
  Property<Cashier> authCashier = Property<Cashier>();

  final _pendingOrderQtyController = StreamController<int>.broadcast();
  Sink<int> get pendingOrderQtySink => _pendingOrderQtyController.sink;
  Stream<int> get pendingOrderQtyStream => _pendingOrderQtyController.stream;

  final _eventController = StreamController<MainPageEvent>.broadcast();
  Sink<MainPageEvent> get eventSink => _eventController.sink;
  Timer? serviceOrderTimer;

  Property<int> queueNumber = Property<int>();
  Property<bool> connection = Property<bool>();
  Property<Uint8List> logo_ = Property<Uint8List>();

  ConnectionRepository? locatorConnction;

  bool get isSettingAvailable {
    return locatorConnction!.repoName == "Database Connection";
  }

  MainBloc(this._navigationBloc) {
    locatorConnction = locator.get<ConnectionRepository>();
    locator.registerSingleton<WebSocketIO>(WebSocketIO());
    webSocketIO = locator.get<WebSocketIO>();
    checkConnection();
    currentDate.sinkValue(DateTime.now());
    queueNumber.sinkValue(0);
    employeeName.sinkValue("");
    connection.sinkValue(true);
    pendingOrderQtySink.add(0);
    loadTimer();

    timeTimer = Timer.periodic(const Duration(seconds: 1), timeTick);

    locator.get<Global>().onEmployeeChange = (s) async {
      Employee? employee = locator.get<Global>().authEmployee;

      if (employee == null) {
        employeeName.sinkValue("");
      } else {
        employeeName.sinkValue(employee.name);
      }

      //check cashier
      if (locatorConnction!.preference!.onlyOneCashierPerTerminal) {
        if (locator.get<Global>().authCashier == null) {
          locator.get<Global>().setCashier(await locatorConnction!.cashierService!.getTerminalCashier(locatorConnction!.terminal!.id));
          authCashier.sinkValue(await locatorConnction!.cashierService!.getTerminalCashier(locatorConnction!.terminal!.id));
        }
      } else {
        if (employee != null) {
          locator.get<Global>().setCashier(await locatorConnction!.cashierService!.getCashierReference(employee.id));
          authCashier.sinkValue(await locatorConnction!.cashierService!.getCashierReference(employee.id));
        }
      }

      employeeName.sinkValue(employeeName.value ?? "");
    };

    locatorConnction!.queueNumber = (queuelenth) {
      queueNumber.sinkValue(queuelenth);
    };

    locatorConnction!.connection = (connected) {
      connection.sinkValue(connected);
    };

    _eventController.stream.listen(_mapEventToState);

    locator.registerSingleton<BluePrinter>(BluePrinter());
    locator.get<BluePrinter>().connect();

    Preference? preference = locator.get<ConnectionRepository>().preference;
    logo = (preference!.restaurantLogo != null && preference.restaurantLogo != "") ? base64.decode(preference.restaurantLogo!) : null;

    logo_.sinkValue(logo ?? Uint8List.fromList(''.codeUnits));
  }

  setCashier() async {
    authCashier.sinkValue(await locatorConnction!.cashierService!.getCashierReference(1));
  }

  getLogo() {
    Preference? preference = locator.get<ConnectionRepository>().preference;
    logo = (preference!.restaurantLogo != null && preference.restaurantLogo != "") ? base64.decode(preference.restaurantLogo!) : null;

    logo_.sinkValue(logo ?? Uint8List.fromList(''.codeUnits));
  }

  checkConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if ((prefs.getString("connectionType") == "INVO")) {
      isINVOConnection.sinkValue(true);
      loadWebSocket();
    } else {
      isINVOConnection.sinkValue(false);
      loadWebSocketIO();
    }

    // getLogo();
  }

  updateConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getString("connectionType") == "INVO")) {
      isINVOConnection.sinkValue(true);
    } else {
      isINVOConnection.sinkValue(false);
    }
    getLogo();
  }

  loadWebSocket() async {
    await webStockClient.loadMain();
  }

  loadTimer() {
    serviceOrderTimer = Timer.periodic(const Duration(seconds: 10), loadServiceOrders);
  }

  loadServiceOrders(Timer timer) async {
    List<MiniOrder> pendingOrders = await locator.get<ConnectionRepository>().fetchPendingOrders() ?? [];

    pendingOrderQtySink.add(0);

    if (pendingOrders.isNotEmpty) {
      hasNewPending = true;
      pendingOrderQtySink.add(pendingOrders.length);
    } else {
      hasNewPending = false;
    }
  }

  loadWebSocketIO() async {
    webSocketIO!.load();
  }

  void _mapEventToState(MainPageEvent event) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    if (event is LogIn) {
      Privilege priv = Privilege();
      if (await priv.checkLogin(Privilages.new_order)) {
        userSettings.sinkValue(true);
      }
    } else if (event is LogOut) {
      Privilege priv = Privilege();
      priv.logOut();
    } else if (event is PowerOff) {
      Privilege priv = Privilege();
      if (await priv.forceLogin(Privilages.Exit_Security)) {
        if (isINVOConnection.value != null) {
          if (isINVOConnection.value == false) {
            bool resault = await locator.get<DialogService>().showDialog(appLocalizations.translate("Database Backup"), appLocalizations.translate("Do You Want to Backup your Database?"), okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));
            if (resault) {
              ConnectionRepository connection = locator.get<ConnectionRepository>();

              if (await connection.dailyBackupDB()) exit(0);
            } else {
              exit(0);
            }
          } else {
            exit(0);
          }
        } else {
          exit(0);
        }
      }
    } else if (event is GoToTerminalSettings) {
      Privilege priv = Privilege();
      if (!(await priv.checkLogin(Privilages.BackOffice))) return;
      if (await _navigationBloc!.navigateToTerminalPage()) {
        locator.get<BluePrinter>().connect();
      }
      // _navigationBloc.navigatorSink.add(NavigateToTerminalPage());
    } else if (event is GoToDailySalesReport) {
      Privilege priv = Privilege();
      if (!(await priv.checkLogin(Privilages.BackOffice))) return;
      if (await _navigationBloc!.navigateToDailySalesReport()) {
        locator.get<BluePrinter>().connect();
      }
    } else if (event is GoToCashierReport) {
      Privilege priv = Privilege();
      if (!(await priv.checkLogin(Privilages.BackOffice))) return;
      if (await _navigationBloc!.navigateToCashierReport()) {
        locator.get<BluePrinter>().connect();
      }
    } else if (event is ChangeConnection) {
      Privilege priv = Privilege();
      if (!(await priv.checkLogin(Privilages.Add_Database))) return;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("connectionType", "");
      prefs.setString("Invo_IP", "");
      //prefs.setString("connectionType", "INVO");

      _navigationBloc!.navigatorSink.add(NavigateToInvoConnectionPage());
      // _navigationBloc!.navigatorSink.add(NavigateToInvoConnectionPage());
    } else if (event is GoToMainSettings) {
      Privilege privilage = Privilege();
      if (!await privilage.checkLogin(Privilages.BackOffice)) return;

      _navigationBloc!.navigateToMainSettingsPage();
    } else if (event is GoToCashierPage) {
      Privilege privilage = Privilege();
      if (!await privilage.checkLogin(Privilages.settle_order)) return;

      await _navigationBloc!.navigateToCashierPage();
    }
  }

  void timeTick(Timer timer) {
    if (DateTime.now().minute != currentDate.value!.minute) currentDate.sinkValue(DateTime.now());
  }

  @override
  void dispose() {
    userSettings.dispose();
    _eventController.close();
    timeTimer!.cancel();
    currentDate.dispose();
  }
}
