// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
// import 'package:flutter_usb_printer/flutter_usb_printer.dart';
// import 'package:invo_mobile/helpers/misc.dart';
// import 'package:invo_mobile/models/Number.dart';
// import 'package:invo_mobile/models/order/TransactionCombo.dart';
// import 'package:invo_mobile/models/order/TransactionModifier.dart';
// import 'package:invo_mobile/models/order/order_header.dart';
// import 'package:invo_mobile/models/order/order_transaction.dart';
// import 'package:invo_mobile/models/preference.dart';
// import 'package:invo_mobile/models/reports/CashierReportModel.dart';
// import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
// import 'package:invo_mobile/models/terminal.dart';
// import 'package:invo_mobile/repositories/connection_repository.dart';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:invo_mobile/service_locator.dart';
// import 'package:invo_mobile/services/Print/Category/generator/ticket.dart';
// import 'package:invo_mobile/services/Print/PrintFormat.dart';
// import 'package:invo_mobile/widgets/translation/app_localizations.dart';
// import 'dart:ui' as ui;
// import 'Category/OrderPrint.dart';
// import 'PrintFormat.dart';
// import '../../service_locator.dart';

// import 'package:image/image.dart' as im;

// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:async/async.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class UsbPrinter {
  // late OrderPrint orderPrint = OrderPrint();
  // late String lang = "en";
  // late AppLocalizations appLocalizations = AppLocalizations(const Locale("en"));
  // late String printingType;
  // late bool connected = false;
  // late String kitchenPrintingType;
  // late List<Map<String, dynamic>> devices = List<Map<String, dynamic>>.empty(growable: true);
  // FlutterUsbPrinter flutterUsbPrinter = FlutterUsbPrinter();
  // int printerSize = 3;

  // UsbPrinter() {
  //   Terminal? terminal = locator.get<ConnectionRepository>().terminal;
  //   printingType = terminal!.printingType;
  //   kitchenPrintingType = terminal.kitchenPrintingType;
  //   flutterUsbPrinter = FlutterUsbPrinter();
  //   devices = List<Map<String, dynamic>>.empty(growable: true);
  //   loadLanguage();
  // }

  // _connect() async {
  //   Terminal? terminal = locator.get<ConnectionRepository>().terminal;
  //   printingType = terminal!.printingType;
  //   if (terminal.usbPrinter == "") return false;
  //   Map<String, dynamic>? device = jsonDecode(terminal.usbPrinter);
  //   if (device == null) {
  //     return false;
  //   }
  //   return await flutterUsbPrinter.connect(int.parse(device["vendorId"]), int.parse(device["productId"]));
  // }

  // loadLanguage() async {
  //   lang = locator.get<ConnectionRepository>().terminal!.getLangauge()!;
  //   this.appLocalizations = await AppLocalizations.load(Locale(lang));
  // }

  // printWithFormat(List<PrintFormat> list) async {
  //   GenerateTicket ticket = GenerateTicket();
  //   List<int> bytes = await ticket.getTicketBytes(list);
  //   var data = Uint8List.fromList(bytes);
  //   await flutterUsbPrinter.write(data);
  // }

  // drawWithFormat(List<PrintFormat> list) async {
  //   GenerateTicket ticket = GenerateTicket();
  //   List<int> bytes = await ticket.getImageTicket(list);
  //   var data = Uint8List.fromList(bytes);
  //   await flutterUsbPrinter.write(data);
  // }

  // Future<bool> printCashierReport(CashierReportModel report, {bool drawer = false, String? drawer_code, bool isCash = false}) async {
  //   try {
  //     await _connect();
  //     GenerateTicket ticket = GenerateTicket();
  //     bool isNote = true;
  //     List<int> bytes = await ticket.getCashierReport(report, isNote);
  //     var data = Uint8List.fromList(bytes);
  //     await flutterUsbPrinter.write(data);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // printClosingReport(DailyClosingModel report, Preference preference, DateTime date, {bool drawer = false, String? drawer_code}) async {
  //   try {
  //     await _connect();
  //     GenerateTicket ticket = GenerateTicket();
  //     bool isNote = true;
  //     List<int> bytes = await ticket.getClosingReport(report, preference, date);
  //     var data = Uint8List.fromList(bytes);
  //     await flutterUsbPrinter.write(data);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<bool> printOrder(List<PrintFormat> printFormat) async {
  //   await _connect();
  //   Preference? preference = locator.get<ConnectionRepository>().preference;
  //   if (printingType == "Drawing") {
  //     drawWithFormat(printFormat);
  //   } else {
  //     printWithFormat(printFormat);
  //   }
  //   return true;
  // }
}
