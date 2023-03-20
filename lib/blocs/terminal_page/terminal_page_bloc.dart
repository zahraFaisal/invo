import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:android_plugin/android_plugin_method_channel.dart';
import 'package:collection/collection.dart';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_usb_printer/flutter_usb_printer.dart';
// import 'package:get_ip/get_ip.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/terminal_page/terminal_page_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/Print/usbPrinter.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../helpers/network_analyzer.dart';
import '../blockBase.dart';

class TerminalPageBloc extends BlocBase {
  final NavigatorBloc? _navigationBloc;
  final _eventController = StreamController<TerminalPageEvent>.broadcast();
  Sink<TerminalPageEvent> get eventSink => _eventController.sink;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Property<List<BluetoothDevice>> devices = Property<List<BluetoothDevice>>();
  Property<List<String>> ipPrinters = Property<List<String>>();
  Property<List<String>> x990Printers = Property<List<String>>();
  Property<List<Map<String, dynamic>>> usbPrinters = Property<List<Map<String, dynamic>>>();

  Property<List<DropdownMenuItem<String>>> templates = Property<List<DropdownMenuItem<String>>>();

  Property<String> printerType = Property<String>();
  Property<String> printingType = Property<String>();
  Property<String> selectedTemp = Property<String>();

  Property<String> kitchenPrintingType = Property<String>();

  Property<String> printerSize = Property<String>();
  // FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();

  Property<String> kitchenPrinterIP = Property<String>();
  Property<String> selectedIp = Property<String>();
  Property<String> selectedX990 = Property<String>();
  Property<String> cashDrawer = Property<String>();
  bool isINVOConnection = false;
  BluetoothDevice? selectedDevice;
  Map<String, dynamic>? selectedUsb;

  Terminal? terminal;
  Property<String> crediMaxTermianlId = Property<String>();

  @override
  void dispose() {
    _eventController.close();
    printerType.dispose();
    printingType.dispose();
    selectedTemp.dispose();
    kitchenPrintingType.dispose();
    printerSize.dispose();
    selectedIp.dispose();
    cashDrawer.dispose();
    devices.dispose();
    ipPrinters.dispose();
    kitchenPrinterIP.dispose();
    x990Printers.dispose();
    selectedX990.dispose();
    usbPrinters.dispose();
    templates.dispose();
    crediMaxTermianlId.dispose();
  }

  loadTemplates() async {
    await _getTemplatesname();
    if (terminal!.selectedTemp != "") {
      if (templates.value != null) {
        if (templates.value!.where((f) => f.value == terminal!.selectedTemp).isNotEmpty) {
          selectedTemp.sinkValue(terminal!.selectedTemp);
        } else {
          selectedTemp.sinkValue("");
        }
      }
    }
  }

  TerminalPageBloc(this._navigationBloc) {
    checkConnection();
    terminal = locator.get<ConnectionRepository>().terminal!.clone();

    loadTemplates();
    if (terminal!.printerSize != "" && (terminal!.printerSize == "80" || terminal!.printerSize == "58")) {
      printerSize.sinkValue(terminal!.printerSize);
    } else {
      printerSize.sinkValue("80");
    }

    if (terminal!.printerType != "" && (terminal!.printerType == "IP Printer" || terminal!.printerType == "Blutooth Printer" || terminal!.printerType == "USB Printer" || terminal!.printerType == "X 990 Printer")) {
      printerType.sinkValue(terminal!.printerType);
    } else {
      printerType.sinkValue("Blutooth Printer");
    }

    if (terminal!.printingType != "" && (terminal!.printingType == "Raw" || terminal!.printingType == "Drawing" || terminal!.printingType == "Template")) {
      printingType.sinkValue(terminal!.printingType);
    } else {
      printingType.sinkValue("Raw");
    }

    if (terminal!.kitchenPrintingType != "" && (terminal!.kitchenPrintingType == "Raw" || terminal!.kitchenPrintingType == "Drawing")) {
      kitchenPrintingType.sinkValue(terminal!.kitchenPrintingType);
    } else {
      kitchenPrintingType.sinkValue("Raw");
    }

    if (terminal!.cashDrawarCode == "") {
      terminal!.setCashDrawerCode("27,112,0,25,250");
    }

    loadCrediMaxTermianlId();

    // getPrintersUSB();

    // if (terminal!.usbPrinter != "0" && terminal!.usbPrinter != "") {
    //   selectedUsb = jsonDecode(terminal!.usbPrinter);
    // }

    kitchenPrinterIP.setValue(terminal!.kitchenPrinter);

    cashDrawer.sinkValue(terminal!.cashDrawarCode);

    debugPrint(printerType.value);
    if (printerType.value == "IP Printer") {
      getPrinterIPS(savedIP: terminal!.bluetoothPrinter);
    }

    if (printerType.value == "X 990 Printer") {
      terminal!.setBluetoothPrinter("X 990 Printer");
      getPrinterX990(savedPrinter: terminal!.bluetoothPrinter);
    }

    _eventController.stream.listen(_mapEventToState);
    initPlatformState();
  }

  loadCrediMaxTermianlId() async {
    //get credimax termianl id
    final prefs = await SharedPreferences.getInstance();
    String temp = prefs.getString("crediMaxTerminalId") ?? "";
    crediMaxTermianlId.sinkValue(temp);
  }

  _getTemplatesname() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/receiptTemplate';
    final myDir = new Directory(pdfDirectory);
    if ((await myDir.exists())) {
      // TODO:
      print("exist");
    } else {
      // TODO:
      print("not exist");
      myDir.create();
    }

    var _folders = myDir.listSync(recursive: true, followLinks: false);

    List<DropdownMenuItem<String>> items = [];

    items.add(DropdownMenuItem(
      child: Text(""),
      value: "",
    ));
    for (var item in _folders) {
      var temp = item.path.split("/");

      items.add(DropdownMenuItem(
        child: Text(temp[temp.length - 1]),
        value: temp[temp.length - 1],
      ));
    }
    templates.sinkValue(items);
  }

  void _mapEventToState(TerminalPageEvent event) async {
    // String lang = locator.get<ConnectionRepository>().terminal.getLangauge();
    // AppLocalizations appLocalizations =
    //     await AppLocalizations.load(Locale(lang));
    await _getTemplatesname();
    if (event is TerminalPageGoBack) {
      _navigationBloc!.navigatorSink.add(PopUp());
    } else if (event is SaveTerminal) {
      terminal!.setPrinterSize(printerSize.value!);
      terminal!.setPrinterType(printerType.value!);
      terminal!.setPrintingType(printingType.value!);
      terminal!.setKitchenPrintingType(kitchenPrintingType.value!);
      terminal!.setTemplate(selectedTemp.value);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("crediMaxTerminalId", crediMaxTermianlId.value ?? "");

      if (terminal!.langauge != null)
        AppLocalizations.load(Locale(
          terminal!.langauge!,
        ));

      if (printerType.value == "IP Printer") {
        if (selectedIp.value != "") {
          terminal!.setBluetoothPrinter(selectedIp.value!);
        } else {
          terminal!.setBluetoothPrinter("");
        }
      }

      if (printerType.value == "X 990 Printer") {
        if (selectedX990.value != "") {
          terminal!.setBluetoothPrinter(selectedX990.value!);
        } else {
          //terminal!.setBluetoothPrinter("");
        }
      }

      // if (printerType.value == "USB Printer") terminal!.setUsbPrinter(jsonEncode(selectedUsb!));

      if (cashDrawer.value != null) terminal!.setCashDrawerCode(cashDrawer.value!);

      if (kitchenPrinterIP.value != null) {
        terminal!.kitchenPrinter = kitchenPrinterIP.value;
      }
      locator.get<DialogService>().showLoadingProgressDialog();

      Terminal? temp = await locator.get<ConnectionRepository>().saveTerminal(terminal!);
      locator.get<DialogService>().closeDialog(); //close loading dialog
      if (temp == null) {
        showToast("Saved Failed", duration: Duration(seconds: 5), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));
      } else {
        showToast("Saved Successfully", duration: Duration(seconds: 5), backgroundColor: Colors.green, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));
        _navigationBloc!.navigatorSink.add(PopUp());
      }
    } else if (event is GoToDownloadTemplatePage) {
      _navigationBloc!.navigateToDownloadTemplatePage();
    }
  }

  bool get isKitchenPrinterAvailable {
    return locator.get<ConnectionRepository>().repoName != "Database Connection";
  }

  checkConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isINVOConnection = prefs.getString("connectionType") == "INVO";
  }

  void setDevice(BluetoothDevice value) {
    selectedDevice = value;
    if (value == null) {
      terminal!.setBluetoothPrinter("");
    } else {
      terminal!.setBluetoothPrinter(value.name!);
    }
    devices.sinkValue(devices.value ?? List<BluetoothDevice>.empty(growable: true));
  }

  // void setUsb(Map<String, dynamic> value) {
  //   selectedUsb = value;
  //   if (value == null) {
  //     terminal!.setUsbPrinter("");
  //   } else {
  //     terminal!.setUsbPrinter(value['productName']);
  //   }
  //   usbPrinters.sinkValue(usbPrinters.value ?? List<Map<String, dynamic>>.empty(growable: true));
  // }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> _devices;
    try {
      _devices = await bluetooth.getBondedDevices();
      selectedDevice = _devices.firstWhereOrNull((f) => f.name == terminal!.bluetoothPrinter);
      devices.sinkValue(_devices);
    } on Exception {
      // TODO - Error
    }
  }

  List<String> ips = List<String>.empty(growable: true);
  List<String> x990s = List<String>.empty(growable: true);
  Future<void> setPrinterType(String value) async {
    printerType.sinkValue(value);
    debugPrint("Printer type" + value);
    if (value == "IP Printer") {
      await getPrinterIPS();
    } else if (value == "X 990 Printer") {
      await getPrinterX990();
    }
    // else if (value == "USB Printer") {
    //   await getPrintersUSB();
    // }
  }

  void setPrintingType(String value) {
    printingType.sinkValue(value);
  }

  void setkitchenPrintingType(String value) {
    kitchenPrintingType.sinkValue(value);
  }

  // getPrintersUSB() async {
  //   List<Map<String, dynamic>> results = [];
  //   results = await FlutterUsbPrinter.getUSBDeviceList();
  //   usbPrinters.value = [];
  //   for (var i = 0; i < results.length; i++) {
  //     Map<String, dynamic> value = results[i];
  //     usbPrinters.value!.add(value);
  //   }

  //   usbPrinters.sinkValue(usbPrinters.value ?? List<Map<String, dynamic>>.empty(growable: true));
  // }

  getPrinterX990({String savedPrinter = "X 990 Printer"}) async {
    if (x990s.length > 0) {
      x990Printers.sinkValue(x990s);
      return;
    }

    List<String> temp = List<String>.empty(growable: true);
    if (savedPrinter != null) {
      if (savedPrinter != "") {
        temp.add(savedPrinter);
      }
      selectedX990.sinkValue(savedPrinter);
    }

    x990Printers.sinkValue(temp);

    MethodChannelAndroidPlugin methodChannelCrediMaxEcr = MethodChannelAndroidPlugin();

    try {
      methodChannelCrediMaxEcr.messageStream.listen((event) {
        debugPrint("event: $event");
      });
      String? res = await methodChannelCrediMaxEcr.connectService();

      if (res != null) {
        debugPrint(res);
        showToast(res, duration: Duration(seconds: 5), backgroundColor: Colors.green, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getPrinterIPS({String savedIP = ""}) async {
    if (ips.length > 0) {
      ipPrinters.sinkValue(ips);
      return;
    }

    List<String> temp = List<String>.empty(growable: true);
    if (savedIP != null) {
      if (savedIP != "") {
        temp.add(savedIP);
      }
      selectedIp.sinkValue(savedIP);
    }
    ipPrinters.sinkValue(temp);

    // var ipAddress_ = IpAddress(type: RequestType.json);

    // String ipAddress = (await ipAddress_.getIpAddress()).toString();
    // if (kDebugMode) {
    //   ipAddress = '10.2.2.1';
    // }

    const port = 9100;
    final info = NetworkInfo();
    final String? ip = await info.getWifiIP();
    final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
    final stream = NetworkAnalyzer.discover2(
      subnet,
      port,
    );

    int found = 0;

    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        ips.add('${addr.ip}:$port');
      }
    }).onDone(() {
      if (ips.isNotEmpty) {
        if (savedIP != "") {
          if (!ips.contains(savedIP)) ips.add(savedIP);
        }
        ipPrinters.sinkValue(ips);
      }
    });
  }
}
