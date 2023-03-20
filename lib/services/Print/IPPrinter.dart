// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:typed_data';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/order/TransactionCombo.dart';
import 'package:invo_mobile/models/order/TransactionModifier.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/Print/PrintFormat.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'dart:ui' as ui;
import 'Category/OrderPrint.dart';
import 'Category/generator/ticket.dart';
import 'PrintFormat.dart';
import '../../service_locator.dart';

import 'package:image/image.dart' as im;

class IPPrinter {
  late OrderPrint orderPrint = OrderPrint();
  late Generator ticket;
  late String lang = "en";
  late AppLocalizations appLocalizations = AppLocalizations(const Locale("en"));
  late String printingType;
  late String kitchenPrintingType;
  IPPrinter() {
    Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    printingType = terminal!.printingType;
    kitchenPrintingType = terminal.kitchenPrintingType;
    loadLanguage();
  }

  loadLanguage() async {
    lang = locator.get<ConnectionRepository>().terminal!.getLangauge()!;
    this.appLocalizations = await AppLocalizations.load(Locale(lang));
  }

  drawWithFormat(List<PrintFormat> list, String ip, int port, {bool drawer = false, String? drawer_code, bool kitchen = false}) async {
    try {
      NetworkPrinter printerManager = NetworkPrinter(PaperSize.mm80, await CapabilityProfile.load());
      await printerManager.connect(ip, port: port);
      GenerateTicket ticket = GenerateTicket();
      List<int> bytes = await ticket.getImageTicket(list);
      var data = Uint8List.fromList(bytes);
      printerManager.textEncoded(data);
      printerManager.disconnect();
      printerManager.reset();
    } catch (e) {
      print(e.toString());
    }
  }

  printWithFormat(List<PrintFormat> list, String ip, int port, {bool drawer = false, String? drawer_code, bool kitchen = false}) async {
    try {
      NetworkPrinter printerManager = NetworkPrinter(PaperSize.mm80, await CapabilityProfile.load());
      await printerManager.connect(ip, port: port);
      GenerateTicket ticket = GenerateTicket();
      List<int> bytes = await ticket.getTicketBytes(list);
      var data = Uint8List.fromList(bytes);
      printerManager.textEncoded(data);
      printerManager.disconnect();
      printerManager.reset();
    } catch (e) {
      print(e.toString());
    }
  }

  printOrder(List<PrintFormat> printFormat, String ip, int port, {bool drawer = false, String? drawer_code}) async {
    final profile = await CapabilityProfile.load();
    if (printingType == "Drawing") {
      if (drawer == true)
        drawWithFormat(printFormat, ip, port, drawer: drawer, drawer_code: drawer_code);
      else
        drawWithFormat(printFormat, ip, port);
    } else {
      if (drawer == true)
        printWithFormat(printFormat, ip, port, drawer: drawer, drawer_code: drawer_code);
      else
        printWithFormat(printFormat, ip, port);
    }
  }

  printCashierReport(CashierReportModel report, String ip, int port, {bool drawer = false, String? drawer_code, bool isCashIn = false}) async {
    try {
      NetworkPrinter printerManager = NetworkPrinter(PaperSize.mm80, await CapabilityProfile.load());
      await printerManager.connect(ip, port: port);
      GenerateTicket ticket = GenerateTicket();
      bool isNote = true;
      List<int> bytes = await ticket.getCashierReport(report, isNote, cashIn: isCashIn);
      var data = Uint8List.fromList(bytes);
      printerManager.textEncoded(data);
      printerManager.disconnect();
      printerManager.reset();
    } catch (e) {
      print(e.toString());
    }
  }

  printClosingReport(DailyClosingModel report, String ip, int port, Preference preference, DateTime date,
      {bool drawer = false, String? drawer_code}) async {
    try {
      NetworkPrinter printerManager = NetworkPrinter(PaperSize.mm80, await CapabilityProfile.load());
      await printerManager.connect(ip, port: port);
      GenerateTicket ticket = GenerateTicket();
      bool isNote = false;
      List<int> bytes = await ticket.getClosingReport(report, preference, date);
      var data = Uint8List.fromList(bytes);
      printerManager.textEncoded(data);
      printerManager.disconnect();
      printerManager.reset();
    } catch (e) {
      print(e.toString());
    }
  }

  void kitchenPrinter(List<PrintFormat> printFormat, String ip, int port) async {
    final profile = await CapabilityProfile.load();
    if (printingType == "Drawing") {
      drawWithFormat(printFormat, ip, port, kitchen: true);
    } else {
      printWithFormat(printFormat, ip, port, kitchen: true);
    }
  }

  void openDrawer(String ip, int port, String cashDrawarCode) async {
    // await printerManager.connect(ip, port: port);

    // if (cashDrawarCode == null || cashDrawarCode == "") {
    //   cashDrawarCode = "27,112,0,25,250";
    // }
    // final profile = await CapabilityProfile.load();

    // if (cashDrawarCode == "27,112,0,25,250")
    //   printerManager.drawer();
    // else {
    //   printerManager.text(drawerCode(cashDrawarCode));
    // }
    // // final PosPrintResult res = await printerManager.printTicket(_ticket);
  }

  String drawerCode(String cashDrawarCode) {
    List<String> codes = cashDrawarCode.split(',');
    String temp = "";
    for (var item in codes) {
      temp += utf8.decode(List<int>.empty(growable: true)..add(int.parse(item)));
    }
    return temp;
  }
}
