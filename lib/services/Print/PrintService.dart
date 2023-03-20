import 'package:flutter/material.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/services/Print/IPPrinter.dart';
import 'package:invo_mobile/services/Print/PrintFormat.dart';
import 'package:invo_mobile/services/Print/X990Printer.dart';
import 'package:invo_mobile/services/Print/blue_printer.dart';
import 'package:invo_mobile/services/Print/usbPrinter.dart';

import '../../service_locator.dart';
import 'Category/OrderPrint.dart';
import 'dart:async';

class PrintService {
  Terminal terminal;
  PrintService(this.terminal);

  printOrder(OrderHeader order, {bool drawer = false}) async {
    try {
      OrderPrint orderPrint = OrderPrint();
      List<PrintFormat> printFormat = await orderPrint.printOrderReceipt(order);
      if (terminal.printerType == "IP Printer") {
        IPPrinter ipPrinter = IPPrinter();
        if (terminal.bluetoothPrinter.contains(":")) {
          List<String> x = terminal.bluetoothPrinter.split(":"); // 10.1.1.90:9100
          ipPrinter.printOrder(printFormat, x[0], int.parse(x[1]), drawer: drawer, drawer_code: terminal.cashDrawarCode);
        }
      } else if (terminal.printerType == "Blutooth Printer") {
        if (await locator.get<BluePrinter>().connect()) {
          locator.get<BluePrinter>().printOrder(printFormat);
        }
      } else if (terminal.printerType == "X 990 Printer") {
        X990Printer x990printer = X990Printer();
        x990printer.printOrder(printFormat);
      }
      // else if (terminal.printerType == "USB Printer") {
      //   UsbPrinter usbPrinter = UsbPrinter();
      //   usbPrinter.printOrder(printFormat);
      // }
    } catch (e) {
      print("error");
    }
  }

  Future<void> openDrawer() async {
    if (terminal.printerType == "IP Printer") {
      IPPrinter ipPrinter = IPPrinter();
      if (terminal.bluetoothPrinter.contains(":")) {
        List<String> x = terminal.bluetoothPrinter.split(":");
        ipPrinter.openDrawer(x[0], int.parse(x[1]), terminal.cashDrawarCode);
      }
    } else if (terminal.printerType == "Blutooth Printer") {
      if (await locator.get<BluePrinter>().connect()) {
        await locator.get<BluePrinter>().openDrawer(terminal.cashDrawarCode);
      }
    }
  }

  void printOrders(List<OrderHeader> orders) async {
    OrderPrint orderPrint = OrderPrint();
    List<PrintFormat> printFormat;
    if (terminal.printerType == "IP Printer") {
      IPPrinter ipPrinter = IPPrinter();
      List<String> x = terminal.bluetoothPrinter.split(":");

      for (var order in orders) {
        printFormat = await orderPrint.printOrderReceipt(order);
        ipPrinter.printOrder(printFormat, x[0], int.parse(x[1]));
      }
    } else if (terminal.printerType == "Blutooth Printer") {
      if (await locator.get<BluePrinter>().connect()) {
        for (var order in orders) {
          printFormat = await orderPrint.printOrderReceipt(order);
          locator.get<BluePrinter>().printOrder(printFormat);
        }
      }
    } else if (terminal.printerType == "USB Printer") {}
  }

  void printDailyClosingReport(DailyClosingModel report, Preference preference, DateTime date) async {
    if (terminal.printerType == "IP Printer") {
      IPPrinter ipPrinter = IPPrinter();
      List<String> x = terminal.bluetoothPrinter.split(":");
      if (terminal.bluetoothPrinter.contains(":")) {
        ipPrinter.printClosingReport(report, x[0], int.parse(x[1]), preference, date);
      }
    } else if (terminal.printerType == "Blutooth Printer") {
      if (await locator.get<BluePrinter>().connect()) {
        await locator.get<BluePrinter>().printClosingReport(report, date);
      }
    }
    // else if (terminal.printerType == "USB Printer") {
    //   UsbPrinter usbPrinter = UsbPrinter();
    //   usbPrinter.printClosingReport(report, preference, date);
    // }
  }

  void printCashierReport(CashierReportModel report, {bool isCashIn = false}) async {
    if (terminal.printerType == "IP Printer") {
      IPPrinter ipPrinter = IPPrinter();
      List<String> x = terminal.bluetoothPrinter.split(":");
      if (terminal.bluetoothPrinter.contains(":")) {
        ipPrinter.printCashierReport(report, x[0], int.parse(x[1]), isCashIn: isCashIn);
      }
    } else if (terminal.printerType == "Blutooth Printer") {
      if (await locator.get<BluePrinter>().connect()) {
        await locator.get<BluePrinter>().printCashierReport(report, isCash: isCashIn);
      }
    }
    // else if (terminal.printerType == "USB Printer") {
    //   UsbPrinter usbPrinter = UsbPrinter();
    //   usbPrinter.printCashierReport(report, isCash: isCashIn);
    // }
  }

  void kitchenPrinter(OrderHeader order) async {
    IPPrinter ipPrinter = IPPrinter();
    List<String> x = terminal.kitchenPrinter!.split(":");
    OrderPrint orderPrint = OrderPrint();
    List<PrintFormat> printFormat = await orderPrint.printOrderReceipt(order, kitchen: true);
    ipPrinter.kitchenPrinter(printFormat, x[0], int.parse(x[1]));
  }
}
