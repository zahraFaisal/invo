// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/order/TransactionCombo.dart';
import 'package:invo_mobile/models/order/TransactionModifier.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'dart:io';
import "package:collection/collection.dart";
import 'package:invo_mobile/services/Print/Category/OrderPrint.dart';
import 'package:invo_mobile/services/Print/PrintFormat.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'Category/OrderPrint.dart';
import 'PrintFormat.dart';
import '../../service_locator.dart';
import 'package:image/image.dart' as im;

class BluePrinter {
  late OrderPrint orderPrint = OrderPrint();
  late List<BluetoothDevice> devices = List<BluetoothDevice>.empty(growable: true);
  late BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  late String printingType;
  late File file;
  late GlobalKey key;
  late Preference? preference = locator.get<ConnectionRepository>().preference;
  late String lang = "en";
  late AppLocalizations appLocalizations = AppLocalizations(const Locale("en"));
  BluePrinter() {
    loadDevices();
    loadLanguage();
  }

  loadLanguage() async {
    this.lang = locator.get<ConnectionRepository>().terminal!.getLangauge()!;
    this.appLocalizations = await AppLocalizations.load(Locale(lang));
  }

  loadDevices() async {
    try {
      devices = await bluetooth.getBondedDevices();
      // Preference preference = locator.get<ConnectionRepository>().preference;
      // file = await writeImage(preference.imageByte.toList());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> connect() async {
    Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    printingType = terminal!.printingType;
    if (terminal.bluetoothPrinter == "") return false;
    if (terminal.printerSize == "80") {
      printerSize = 3;
    } else {
      printerSize = 2;
    }

    BluetoothDevice? device = devices.isEmpty ? null : devices.firstWhereOrNull((f) => f.name == terminal.bluetoothPrinter);
    if (device == null) {
      return false;
    }

    bool? isConnected = await bluetooth.isConnected;
    if (!isConnected!) {
      try {
        await bluetooth.connect(device);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return true;
    }
  }

  int printerSize = 2; // in inch

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/logo.jpg');
  }

  Future<File> writeImage(List<int> image) async {
    final file = await _localFile;
    // Write the file.
    return file.writeAsBytes(image);
  }

  String esc = utf8.decode(List<int>.empty(growable: true)..add(27));
  String q = utf8.decode(List<int>.empty(growable: true)..add(33));
  String a = utf8.decode(List<int>.empty(growable: true)..add(97));
  String p = utf8.decode(List<int>.empty(growable: true)..add(112));

  static const _esc = '\x1B';
  String cCashDrawerPin2 = '${_esc}p030';

  String get doubleHeight {
    return esc + q + utf8.decode(List<int>.empty(growable: true)..add(16));
  }

  String get cancelDoubleHeight {
    return esc + q + utf8.decode(List<int>.empty(growable: true)..add(0));
  }

  String get alignCenter {
    return esc + a + utf8.decode(List<int>.empty(growable: true)..add(1));
  }

  String get alignLeft {
    return esc + a + utf8.decode(List<int>.empty(growable: true)..add(0));
  }

  Future<bool> printCashierReport(CashierReportModel report, {bool drawer = false, String? drawer_code, bool isCash = false}) async {
    bool isNote = true;
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected!) {
      cashierReport(report, isNote, isCashIn: isCash);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> printClosingReport(DailyClosingModel report, DateTime date, {bool drawer = false, String? drawer_code}) async {
    bool isNote = false;
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected!) {
      restaurantInfo();
      bluetooth.printCustom(printLine("-"), 1, 0);
      bluetooth.printCustom("Daily Sales", 2, 1);
      bluetooth.printCustom(date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString(), 1, 1);
      bluetooth.printCustom(printLine("-"), 1, 0);
      bluetooth.printCustom(sideText("Total Order:", report.total_order.toString()), 1, 0);
      bluetooth.printCustom(sideTextCustomSize("Total Tranactions:", report.total_transaction.toString(), leftWidth: 25), 1, 0);

      bluetooth.printCustom(printLine("-"), 1, 0);
      bluetooth.printCustom(sideText("Total Sale:", Number.formatCurrency(report.total_sale)), 1, 0);
      if (report.total_charge_per_hour > 0) {
        bluetooth.printCustom(sideTextCustomSize("Total Charge Per Hour:", Number.getNumber(report.total_charge_per_hour), leftWidth: 25), 1, 0);
      }

      if (report.total_minimum_charge > 0) {
        bluetooth.printCustom(sideTextCustomSize("Total Minimum Charge:", Number.getNumber(report.total_minimum_charge), leftWidth: 25), 1, 0);
      }

      if (report.total_discount_amount > 0) {
        bluetooth.printCustom(sideText("Total Discount:", Number.getNumber(report.total_discount_amount)), 1, 0);
      }

      if (report.total_surcharge_amount > 0) {
        bluetooth.printCustom(sideText("Total Surcharge:", Number.getNumber(report.total_surcharge_amount)), 1, 0);
      }

      if (report.total_delivery_charge > 0) {
        bluetooth.printCustom(sideTextCustomSize("Total Delivery Charge:", Number.getNumber(report.total_delivery_charge), leftWidth: 25), 1, 0);
      }

      if (report.total_tax > 0) {
        bluetooth.printCustom(
            sideText(preference!.tax1_name != null ? preference!.tax1_name.toString() + ":" : "Tax 1:", Number.getNumber(report.total_tax)), 1, 0);
      }

      if (report.total_tax2 > 0) {
        bluetooth.printCustom(
            sideText(preference!.tax2_name != null ? preference!.tax2_name.toString() + ":" : "Tax 2:", Number.getNumber(report.total_tax2)), 1, 0);
      }

      if (report.total_tax3 > 0) {
        bluetooth.printCustom(
            sideText(preference!.tax3_name != null ? preference!.tax3_name.toString() + ":" : "Tax 3:", Number.getNumber(report.total_tax3)), 1, 0);
      }

      if (report.total_rounding > 0) {
        bluetooth.printCustom(sideText("Total Rounding:", Number.getNumber(report.total_rounding)), 1, 0);
      }

      if (report.total_payOut > 0) {
        bluetooth.printCustom(sideText("Pay Out:", Number.getNumber(report.total_payOut)), 1, 0);
      }

      bluetooth.printCustom(sideText("Net Income:", Number.formatCurrency((report.total - report.total_payOut))), 1, 0);

      bluetooth.printCustom(printLine("-"), 1, 0);

      if (report.totalGuests > 0) {
        bluetooth.printCustom(sideText("Total Guests:", report.totalGuests.toString()), 1, 0);
      }

      if (report.total_void > 0) {
        bluetooth.printCustom(sideText("Total Void:", Number.getNumber(report.total_void).toString()), 1, 0);
      }

      if (report.total_void > 0 || report.totalGuests > 0) {
        bluetooth.printCustom(printLine("-"), 1, 0);
      }

      if (report.serviceReports.isNotEmpty) {
        bluetooth.printCustom("Sales By Service", 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        for (var item in report.serviceReports) {
          bluetooth.printCustom(sideText(item.service_name.toString(), Number.getNumber(item.total!)), 1, 0);
        }
        bluetooth.printCustom(sideText("Total:", Number.formatCurrency(report.total_service_sales)), 1, 0);

        bluetooth.printCustom(printLine("-"), 1, 0);
      }
      if (report.tenderReports.isNotEmpty) {
        bluetooth.printCustom("Income By Tender", 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        for (var item in report.tenderReports) {
          bluetooth.printCustom(sideText(item.payment_method.toString(), Number.getNumber(item.total!)), 1, 0);
        }
        bluetooth.printCustom(sideText("Total:", Number.formatCurrency(report.total_tender_sales)), 1, 0);
        bluetooth.printCustom(printLine("-"), 1, 0);
      }
      if (report.categoryReports.isNotEmpty) {
        bluetooth.printCustom("Sales By Category", 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        for (var item in report.categoryReports) {
          bluetooth.printCustom(sideText(item.category_name.toString(), Number.getNumber(item.total!)), 1, 0);
        }
        bluetooth.printCustom(sideText("Total:", Number.formatCurrency(report.total_category_sales)), 1, 0);
        bluetooth.printCustom(printLine("-"), 1, 0);
      }
      bluetooth.printNewLine();
      for (var item in report.cashierReports) {
        cashierReport(item, isNote);
      }
      if (report.openOrders.isNotEmpty) {
        bluetooth.printCustom("Open Orders", 1, 1);

        bluetooth.printCustom(printLine("-"), 1, 0);
        bluetooth.printCustom(sideText("Date", ""), 1, 0);
        bluetooth.printCustom(threeColumn("Order", "Type", "Total"), 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        var temp = groupBy(report.openOrders,
            (OpenOrder obj) => (obj.date_time!.day.toString() + "/" + obj.date_time!.month.toString() + "/" + obj.date_time!.year.toString()));

        temp.forEach((key, value) {
          bluetooth.printCustom(key, 1, 0);
          value.forEach((element) {
            bluetooth.printCustom(threeColumn(element.id.toString(), element.serivce_name.toString(), Number.getNumber(element.grand_price)), 1, 1);
          });
        });
        bluetooth.printCustom(printLine("-"), 1, 0);
      }
      if (report.openCashiers.isNotEmpty) {
        bluetooth.printCustom("Open Cashiers", 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        bluetooth.printCustom(threeColumn("Cashier#", "Name", "Terminal"), 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        for (var item in report.openCashiers) {
          bluetooth.printCustom(threeColumn(item.id.toString(), item.name.toString(), item.computer_id.toString()), 1, 1);
        }
        bluetooth.printCustom(printLine("-"), 1, 0);
      }

      bluetooth.printNewLine();
      bluetooth.printNewLine();

      return true;
    } else {
      return false;
    }
  }

  void cashierReport(CashierReportModel report, bool isNote, {bool isCashIn = false}) async {
    Preference? preference = locator.get<ConnectionRepository>().preference;
    if (isNote) {
      bluetooth.printCustom("***This is not a final report*** \n For the final report please check the daily closing report", 1, 1);
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      restaurantInfo();

      bluetooth.printCustom(printLine("-"), 1, 0);
    }
    bluetooth.printCustom("Cashier Report", 2, 1);
    bluetooth.printCustom("Cashier: " + report.name.toString(), 1, 1);
    bluetooth.printCustom("Starting", 1, 1);
    bluetooth.printCustom(
        sideText(
            (report.cashier_in != null)
                ? "Date:" +
                    report.cashier_days(report.cashier_in) +
                    "/" +
                    report.cashier_month(report.cashier_in) +
                    "/" +
                    report.cashier_year(report.cashier_in)
                : "Date:",
            (report.cashier_in != null) ? "Time: " + report.cashier_hour(report.cashier_in) + ":" + report.cashier_min(report.cashier_in) : "Time:"),
        1,
        0);

    if (report.cashier_out != null) {
      bluetooth.printCustom("Closing", 1, 1);
      bluetooth.printCustom(
          sideText(
              (report.cashier_out != null)
                  ? "Date:" +
                      report.cashier_days(report.cashier_out) +
                      "/" +
                      report.cashier_month(report.cashier_out) +
                      "/" +
                      report.cashier_year(report.cashier_out)
                  : "Date:",
              (report.cashier_out != null)
                  ? "Time: " + report.cashier_hour(report.cashier_out) + ":" + report.cashier_min(report.cashier_out)
                  : "Time:"),
          1,
          0);
    }
    bluetooth.printCustom(printLine("-"), 1, 0);
    if (report.total_Transactions != null || report.total_income != 0) {
      bluetooth.printCustom(sideTextCustomSize("Total Tranactions:", report.total_Transactions.toString(), leftWidth: 25), 1, 0);
      bluetooth.printCustom(sideText("Opening Amount:", Number.getNumber(report.start_amount)), 1, 0);
      bluetooth.printCustom(sideText("Total Payments:", Number.formatCurrency(report.total_Sale)), 1, 0);
      bluetooth.printCustom(sideText("Total Income:", Number.formatCurrency(report.total_income)), 1, 0);

      bluetooth.printNewLine();
    }

    if (report.details.isNotEmpty) {
      bluetooth.printCustom("Sales By Tender", 1, 1);
      bluetooth.printCustom(threeColumn("Tenders", "Total", "Equivalant"), 1, 1);
      bluetooth.printCustom(printLine("-"), 1, 0);
      for (var item in report.details) {
        bluetooth.printCustom(
            threeColumn(item.payment_method.toString(), Number.getNumber(item.amount_paid), Number.getNumber(item.actual_amount_paid)), 1, 1);
      }
      bluetooth.printCustom(printLine("-"), 1, 0);

      bluetooth.printCustom(threeColumn("", "Net Sale:", Number.formatCurrency(report.netSale)), 1, 1);
      bluetooth.printNewLine();
    }

    if (report.categoryReports.isNotEmpty) {
      bluetooth.printCustom("Income By Category", 1, 1);
      for (var item in report.categoryReports) {
        bluetooth.printCustom(sideText(item.category_name!, Number.getNumber(item.total!)), 1, 1);
      }

      bluetooth.printCustom(sideText("Category Total:", Number.formatCurrency(report.categoryTotal)), 1, 1);
      bluetooth.printCustom(printLine("-"), 1, 0);
      if (report.ordersDetails!.total_delivery_charge! > 0)
        bluetooth.printCustom(sideText("Delivery Charge:", Number.formatCurrency(report.ordersDetails!.total_delivery_charge!)), 1, 1);
      bluetooth.printCustom(sideText("Total:", Number.formatCurrency(report.categoryTotal + report.ordersDetails!.total_delivery_charge)), 1, 1);

      bluetooth.printNewLine();
    }

    if (report.combine.isNotEmpty) {
      bluetooth.printCustom("Short/Over Report", 1, 1);
      bluetooth.printCustom(printLine("-"), 1, 0);
      for (var item in report.combine) {
        byShortOver(item, report);
      }
      bluetooth.printCustom(printLine("-"), 1, 0);
    }
    if (isCashIn) {
      if (report.local_currency.isNotEmpty) {
        bluetooth.printCustom("Local Currency", 1, 1);
        bluetooth.printCustom(threeColumn("", "Qty", "Total"), 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        for (var item in report.local_currency) {
          bluetooth.printCustom(threeColumn(Number.getNumber(item.type!), item.qty.toString(), Number.getNumber(item.amount)), 1, 1);
        }
        bluetooth.printCustom(printLine("-"), 1, 0);

        bluetooth.printCustom(sideTextCustomSize("Extra Cash", Number.formatCurrency(report.extra_cash == null ? 0 : report.extra_cash)), 1, 1);

        bluetooth.printCustom(printLine("-"), 1, 0);

        bluetooth.printCustom(sideTextCustomSize("Total", Number.formatCurrency(report.localCurrencyTotal)), 1, 1);

        bluetooth.printNewLine();
      }

      if (report.other_tenders.isNotEmpty) {
        bluetooth.printCustom("Other Tenders", 1, 1);
        bluetooth.printCustom(threeColumn("Name", "Total", "Equivalant"), 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        for (var item in report.other_tenders) {
          bluetooth.printCustom(
              threeColumn(
                  item.payment_method!.name.toString().length >= 8
                      ? item.payment_method!.name.toString().substring(0, 8)
                      : item.payment_method!.name.toString(),
                  Number.getNumber(item.amount!),
                  Number.getNumber(item.amount!)),
              1,
              1);
        }
        bluetooth.printCustom(printLine("-"), 1, 0);

        bluetooth.printCustom(sideTextCustomSize("Total", Number.formatCurrency(report.otherTenderTotal)), 1, 1);

        bluetooth.printCustom(printLine("-"), 1, 0);

        bluetooth.printNewLine();
      }
      //forgien currency
      if (report.forignCurrency.isNotEmpty) {
        bluetooth.printCustom("Forign Currency", 1, 1);
        bluetooth.printCustom(threeColumn("Currency", "Total", "Equivalant"), 1, 1);
        bluetooth.printCustom(printLine("-"), 1, 0);
        for (var item in report.forignCurrency) {
          bluetooth.printCustom(
              customthreeColumn(
                  item.payment_method!.name.toString().length >= 8
                      ? item.payment_method!.name.toString().substring(0, 8)
                      : item.payment_method!.name.toString(),
                  Number.getNumber(item.amount!),
                  Number.getNumber(item.equivalant)),
              1,
              1);
        }
        bluetooth.printCustom(printLine("-"), 1, 0);

        bluetooth.printCustom(sideTextCustomSize("Total", Number.getNumber(report.forignCurrencyTotal)), 1, 1);
      }
      bluetooth.printCustom(printLine("-"), 1, 0);
      bluetooth.printCustom(sideTextCustomSize("Total", Number.formatCurrency(report.count)), 1, 1);

      bluetooth.printNewLine();
    }
    bluetooth.printNewLine();
    bluetooth.printNewLine();
  }

  void byShortOver(item, report) {
    if (item.payment_method != "Account") {
      if (item.payment_method_id == 1) {
        bluetooth.printCustom(item.payment_method.toString(), 1, 1);
        bluetooth.printCustom(sideText("Expected:", Number.formatCurrency(item.start_amount + item.amount_paid - report.payOut_total)), 1, 1);

        bluetooth.printCustom(sideText("Count:", Number.getNumber(item.end_amount)), 1, 1);

        bluetooth.printCustom(
            sideText("Short Over:", Number.getNumber(item.end_amount - (item.start_amount + item.amount_paid - report.payOut_total))), 1, 1);
      } else {
        bluetooth.printCustom(item.payment_method.toString(), 1, 1);
        bluetooth.printCustom(sideText("Expected:", Number.formatCurrency(item.start_amount + item.amount_paid)), 1, 1);

        bluetooth.printCustom(sideText("Count:", Number.getNumber(item.end_amount)), 1, 1);

        bluetooth.printCustom(sideText("Short Over:", Number.getNumber(item.end_amount - (item.start_amount + item.amount_paid))), 1, 1);
      }
    }
  }

  drawWithFormat(List<PrintFormat> list, {bool drawer = false, String? drawer_code}) async {
    int imgWidth = 470;
    double secondPosition = 180;
    double singleMinWidth = 400;
    double menuModifierMinWidth = 300;
    double doubleMinWidth = 200;

    if (printerSize == 3) {
      imgWidth = 600;
      secondPosition = 250;
      singleMinWidth = 600;
      menuModifierMinWidth = 500;
      doubleMinWidth = 250;
    }
    Preference? preference = locator.get<ConnectionRepository>().preference;
    double position = 0.0;
    TextPainter textPainter;
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
    );

    TextStyle totalStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(200, 200)));
    canvas.drawColor(Colors.white, BlendMode.src);
    list.forEach((printFormat) async {
      if (printFormat.type == PrintFormatType.center) {
        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[0], style: textStyle), textAlign: TextAlign.center, textDirection: TextDirection.ltr)
              ..layout(minWidth: singleMinWidth);
        textPainter.paint(canvas, Offset(0, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.twoColumns) {
        if (this.lang == 'ar') printFormat.data = printFormat.data.reversed.toList();
        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[0], style: textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
              ..layout(minWidth: doubleMinWidth);
        textPainter.paint(canvas, Offset(0, position));

        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[1], style: textStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
              ..layout(minWidth: doubleMinWidth);
        textPainter.paint(canvas, Offset(secondPosition, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.menuItem) {
        if (this.lang == "en") {
          //qty
          textPainter =
              TextPainter(text: TextSpan(text: printFormat.data[0], style: textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
                ..layout(minWidth: printerSize == 3 ? 100 : 50);
          textPainter.paint(canvas, Offset(0, position));

          //name
          textPainter =
              TextPainter(text: TextSpan(text: printFormat.data[1], style: textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
                ..layout(minWidth: printerSize == 3 ? 300 : 250);
          textPainter.paint(canvas, Offset(40, position));

          //price
          textPainter =
              TextPainter(text: TextSpan(text: printFormat.data[2], style: textStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
                ..layout(minWidth: printerSize == 3 ? 200 : 100);
          textPainter.paint(canvas, Offset(280, position));
        } else {
          //price
          textPainter =
              TextPainter(text: TextSpan(text: printFormat.data[2], style: textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
                ..layout(minWidth: printerSize == 3 ? 200 : 100);
          textPainter.paint(canvas, Offset(0, position));

          //name
          textPainter =
              TextPainter(text: TextSpan(text: printFormat.data[1], style: textStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
                ..layout(minWidth: printerSize == 3 ? 300 : 250);
          textPainter.paint(canvas, Offset(70, position));

          //qty
          textPainter =
              TextPainter(text: TextSpan(text: printFormat.data[0], style: textStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
                ..layout(minWidth: printerSize == 3 ? 100 : 50);
          textPainter.paint(canvas, Offset(320, position));
        }

        position = position + 30;
      } else if (printFormat.type == PrintFormatType.discount) {
        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[0], style: textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
              ..layout(maxWidth: singleMinWidth);
        textPainter.paint(canvas, Offset(150, position));
        position = position + 30.0;
      } else if (printFormat.type == PrintFormatType.doubleHeight) {
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.single) {
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: textStyle),
            textAlign: this.lang == 'ar' ? TextAlign.right : TextAlign.left,
            textDirection: TextDirection.ltr)
          ..layout(minWidth: singleMinWidth, maxWidth: singleMinWidth);
        textPainter.paint(canvas, Offset(0, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.voided) {
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: textStyle),
            textAlign: this.lang == 'ar' ? TextAlign.right : TextAlign.left,
            textDirection: TextDirection.ltr)
          ..layout(minWidth: singleMinWidth);
        textPainter.paint(canvas, Offset(0, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.line) {
        if (printFormat.data.isNotEmpty) {
          textPainter = TextPainter(
              text: TextSpan(text: orderPrint.printLine("-"), style: textStyle), textAlign: TextAlign.center, textDirection: TextDirection.ltr)
            ..layout(maxWidth: 470);
          textPainter.paint(canvas, Offset(0, position));
          position = position + 30;
        } else {
          position = position + 10;
        }
      } else if (printFormat.type == PrintFormatType.twoColumnsTextCustomSize) {
        if (this.lang == 'ar') printFormat.data = printFormat.data.reversed.toList();
        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[0], style: textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
              ..layout(minWidth: doubleMinWidth);
        textPainter.paint(canvas, Offset(0, position));

        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[1], style: textStyle), textAlign: TextAlign.right, textDirection: TextDirection.ltr)
              ..layout(minWidth: doubleMinWidth);
        textPainter.paint(canvas, Offset(secondPosition, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.menuModifier) {
        textPainter = TextPainter(
            text: TextSpan(
                text: orderPrint.menuModifierDrawing(
                    printFormat.data[1] == null || printFormat.data[1] == 'null' ? 0.0 : double.parse(printFormat.data[1]),
                    double.parse(printFormat.data[2]).toInt(),
                    printFormat.data[0]),
                style: textStyle),
            textAlign: this.lang == 'ar' ? TextAlign.right : TextAlign.left,
            textDirection: this.lang == 'ar' ? TextDirection.rtl : TextDirection.ltr)
          ..layout(minWidth: menuModifierMinWidth);
        textPainter.paint(canvas, Offset(this.lang == 'ar' ? 0 : 50, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.total) {
        if (this.lang == 'ar') printFormat.data = printFormat.data.reversed.toList();
        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[0], style: totalStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
              ..layout(minWidth: doubleMinWidth);
        textPainter.paint(canvas, Offset(0, position));

        textPainter =
            TextPainter(text: TextSpan(text: printFormat.data[1], style: totalStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
              ..layout(minWidth: doubleMinWidth);
        textPainter.paint(canvas, Offset(secondPosition, position));
        position = position + 50;
      }
    });

    if (drawer != null && drawer) {
      textPainter =
          TextPainter(text: TextSpan(text: drawerCode(drawer_code!), style: totalStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
            ..layout(minWidth: singleMinWidth);
      textPainter.paint(canvas, Offset(0, position));
    }

    position = position + 60;
    textPainter = TextPainter(text: TextSpan(text: "", style: totalStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
      ..layout(minWidth: 200);
    textPainter.paint(canvas, Offset(0, position));

    var picture = recorder.endRecording();
    var img = await picture.toImage(470, position.ceil());
    var pngBytes = await img.toByteData(format: ImageByteFormat.png);
    im.Image? receiptImg = im.decodeImage(pngBytes!.buffer.asUint8List());
    var img_count = position / 200;
    List<List<int>> imgList = [];
    for (var i = 0; i < img_count.round(); i++) {
      var cropedReceiptImg = im.copyCrop(receiptImg!, 0, (i * 200), imgWidth, 200);
      var bytes = im.encodePng(cropedReceiptImg);
      imgList.add(bytes);
    }
    for (var element in imgList) {
      bluetooth.printImageBytes(element as Uint8List);
    }
  }

  printWithFormat(List<PrintFormat> list, {bool drawer = false, String? drawer_code}) {
    list.forEach((printFormat) {
      if (printFormat.type == PrintFormatType.center) {
        bluetooth.printCustom(printFormat.data[0], 1, 1);
      } else if (printFormat.type == PrintFormatType.twoColumns) {
        bluetooth.printCustom(sideText(printFormat.data[0], printFormat.data[1]), 1, 0);
      } else if (printFormat.type == PrintFormatType.menuItem) {
        bluetooth.printCustom(menuItem(printFormat.data[0], printFormat.data[1], printFormat.data[2]), 1, 0);
      } else if (printFormat.type == PrintFormatType.discount) {
        bluetooth.printCustom(discountText(printFormat.data[0]), 1, 0);
      } else if (printFormat.type == PrintFormatType.doubleHeight) {
        bluetooth.write(doubleHeight);
      } else if (printFormat.type == PrintFormatType.single) {
        bluetooth.printCustom(printFormat.data[0], 1, 0);
      } else if (printFormat.type == PrintFormatType.line) {
        if (printFormat.data.isNotEmpty) {
          bluetooth.printCustom(printLine("-"), 1, 0);
        } else {
          bluetooth.printNewLine();
        }
      } else if (printFormat.type == PrintFormatType.twoColumnsTextCustomSize) {
        bluetooth.printCustom(sideTextCustomSize(printFormat.data[0], printFormat.data[1], leftWidth: 26), 1, 0);
      } else if (printFormat.type == PrintFormatType.menuModifier) {
        print(printFormat.data[1]);
        bluetooth.printCustom(
            "".padRight(5) +
                orderPrint.menuModifierDrawing(printFormat.data[1] == null || printFormat.data[1] == 'null' ? 0.0 : double.parse(printFormat.data[1]),
                    double.parse(printFormat.data[2]).toInt(), printFormat.data[0]),
            1,
            0);
      } else if (printFormat.type == PrintFormatType.voided) {
        bluetooth.printCustom(voidedMenuItem(printFormat.data[0]), 1, 0);
      } else if (printFormat.type == PrintFormatType.total) {
        bluetooth.write(sideText(printFormat.data[0], printFormat.data[1]));
      }
    });

    if (drawer != null && drawer) {
      bluetooth.write(drawerCode(drawer_code!));
    }
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printNewLine();
  }

  Future<bool> printOrder(List<PrintFormat> printFormat, {bool drawer = false, String? drawer_code}) async {
    Preference? preference = locator.get<ConnectionRepository>().preference;
    //49 for 80mm
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected!) {
      if (printingType == "Drawing") {
        drawWithFormat(printFormat, drawer: drawer, drawer_code: drawer_code);
      } else {
        printWithFormat(printFormat, drawer: drawer, drawer_code: drawer_code);
      }
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> printOrder(OrderHeader order,
  //     {bool drawer = false, String drawer_code}) async {
  //   Preference preference = locator.get<ConnectionRepository>().preference;
  //   //49 for 80mm
  //   bool isConnected = await bluetooth.isConnected;
  //   if (isConnected) {
  //     restaurantInfo();
  //     printOrderHeader(order);
  //     bluetooth.printNewLine();
  //     bluetooth.printCustom(printLine("-"), 1, 0);
  //     printRecieptItems(order);

  //     printOrderFooter(order);
  //     bluetooth.printNewLine();
  //     bluetooth.printNewLine();
  //     await bluetooth.printNewLine();
  //     if (drawer != null && drawer) {
  //       bluetooth.write(drawerCode(drawer_code));
  //     }

  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  restaurantInfo() {
    Preference? preference = locator.get<ConnectionRepository>().preference;
    if (preference!.taxInvoiceTitle != null && preference.taxInvoiceTitle!) {
      bluetooth.printCustom("Tax Invoice", 2, 1);
      bluetooth.printCustom(printLine("-"), 1, 0);
    }

    if (preference.printRestaurantName != null && preference.printRestaurantName!) {
      bluetooth.write(doubleHeight);
      bluetooth.printCustom(preference.restaurantName!, 1, 1);
      bluetooth.write(cancelDoubleHeight);
    }

    if (preference.address1 != null && preference.address1 != "") {
      bluetooth.printCustom(preference.address1, 1, 1);
    }

    if (preference.address2 != null && preference.address2 != "") {
      bluetooth.printCustom(preference.address2, 1, 1);
    }

    if (preference.phone != null && preference.phone != "") {
      bluetooth.printCustom(preference.phone, 1, 1);
    }

    if (preference.fax != null && preference.fax != "") {
      bluetooth.printCustom(preference.fax, 1, 1);
    }

    if (preference.url != null && preference.url != "") {
      bluetooth.printCustom(preference.url, 1, 1);
    }
  }

  printOrderHeader(OrderHeader order) {
    Preference? preference = locator.get<ConnectionRepository>().preference;

    if (preference!.hideOrderNoInPrinting != null && preference.hideOrderNoInPrinting!) {
      bluetooth.printCustom(
          sideText(
              "Reference No." + order.ticket_number.toString(),
              (order.service! != null)
                  ? (order.service!.alternative! != null || order.service!.alternative! != ""
                      ? order.service!.alternative!
                      : order.service!.serviceName!)
                  : ""),
          1,
          0);
    } else {
      bluetooth.printCustom(
          sideText(
              "Order." + order.id.toString(),
              (order.service! != null)
                  ? (order.service!.alternative! != null && order.service!.alternative! != ""
                      ? order.service!.alternative!
                      : order.service!.serviceName!)
                  : ""),
          1,
          0);
    }

    bluetooth.printCustom(
        sideText("Server " + order.employee!.name, "Terminal " + (order.terminal_id == null ? "" : order.terminal_id.toString())), 1, 0);

    bluetooth.printCustom(sideText(Misc.toShortDate(order.date_time!), Misc.toShortTime(order.date_time!)), 1, 0);

    if (order.customer != null && order.customer!.name != "" && order.customer!.name != null || (order.Label != null && order.Label != "")) {
      bluetooth.printCustom(
          sideText((order.customer != null && order.customer!.name != "" && order.customer!.name != null) ? order.customer!.name : "",
              (order.Label! != null && order.Label! != "") ? order.Label! : ""),
          1,
          0);
    }

    if (order.customer_contact != null && order.customer_contact != "") {
      bluetooth.printCustom(order.customer_contact!, 1, 0);
    }

    if (order.customer_address != null && order.customer_address != "") {
      bluetooth.printCustom(order.customer_address!, 1, 0);
    }

    if ((order.dinein_table != null)) {
      bluetooth.printCustom("Table" + " " + order.dinein_table!.name, 2, 1);
    }
  }

  printOrderFooter(OrderHeader order) {
    if (order.isItemTotalVisible) {
      bluetooth.printCustom(printLine("-"), 1, 0);
    }

    if (order.total_charge_per_hour! > 0) {
      bluetooth.printCustom("Total Hours (" + (order.total_charge_per_hour! / order.charge_per_hour).toString() + "h)", 0, 0);
    }

    if (order.isItemTotalVisible) {
      bluetooth.printCustom(sideText("Item Total", Number.formatCurrency(order.item_total)), 1, 0);
    }

    if (order.total_charge_per_hour! > 0) {
      bluetooth.printCustom(sideText("Charge Per Hour", Number.formatCurrency(order.total_charge_per_hour!)), 1, 0);
    }

    if (order.min_charge > 0) {
      bluetooth.printCustom(sideText("Minimum Charge", Number.formatCurrency(order.minimum_charge)), 1, 0);
    }

    if (order.discount_amount > 0) {
      bluetooth.printCustom(sideText("Discount", Number.formatCurrency(order.discount_actual_amount)), 1, 0);
    }

    if (order.surcharge_amount > 0) {
      bluetooth.printCustom(sideText("Surcharge", Number.formatCurrency(order.surcharge_actual_amount)), 1, 0);
    }

    if (order.delivery_charge > 0) {
      bluetooth.printCustom(sideText("Delivery Charge", Number.formatCurrency(order.delivery_charge)), 1, 0);
    }
    if (order.isItemTotalVisible ||
        order.delivery_charge > 0 ||
        order.surcharge_amount > 0 ||
        order.discount_amount > 0 ||
        order.min_charge > 0 ||
        order.total_charge_per_hour! > 0) {
      bluetooth.printCustom(printLine("-"), 1, 0);
    }

    if (order.total_tax3 > 0) {
      bluetooth.printCustom(sideText(preference!.tax3Alias! + " Collected", Number.formatCurrency(order.total_tax3)), 1, 0);
    }

    if (order.isSubTotalVisible) {
      bluetooth.printCustom(sideText("Sub Total", Number.formatCurrency(order.sub_total_price)), 1, 0);
    }

    if (order.total_tax > 0) {
      bluetooth.printCustom(sideText(preference!.tax1Alias!, Number.formatCurrency(order.total_tax)), 1, 0);
    }

    if (order.total_tax2 > 0) {
      bluetooth.printCustom(sideText(preference!.tax2Alias!, Number.formatCurrency(order.total_tax2)), 1, 0);
    }

    if (order.Rounding != 0) {
      bluetooth.printCustom(sideText("Rounding", Number.formatCurrency(order.Rounding)), 1, 0);
    }
    if (order.total_tax3 > 0 || order.isSubTotalVisible || order.total_tax > 0 || order.total_tax2 > 0 || order.Rounding != 0)
      bluetooth.printCustom(printLine("-"), 1, 0);
    bluetooth.printNewLine();

    bluetooth.write(doubleHeight);
    bluetooth.write(sideText("Total", Number.formatCurrency(order.grand_price)));
    bluetooth.write(cancelDoubleHeight);

    bluetooth.printNewLine();

    if (order.payments != null) {
      for (var payment in order.payments.where((t) => t.status == 0)) {
        if (payment.method != null) {
          bluetooth.printCustom(sideText(payment.method!.name.toString(), Number.getNumber(payment.actualAmountTendered)), 1, 0);
        } else {
          bluetooth.printCustom(sideText("Account", Number.getNumber(payment.actualAmountTendered)), 1, 0);
        }
      }
      if (order.payments.isNotEmpty && order.amountBalance > 0) {
        bluetooth.printCustom(sideText("Balance", Number.getNumber(order.amountBalance)), 1, 0);
      }
      if (order.amountChange > 0) {
        bluetooth.printCustom(sideText("Change", Number.getNumber(order.amountChange)), 1, 0);
      }
    }

    double exclusiveNonTaxableItem = order.sub_total_price - order.exclusiveTax;

    double inclusiveNonTaxableItem = order.sub_total_price - order.exclusiveTax;

    if (order.exclusiveTax > 0 || order.inclusiveTax > 0) {
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      if (order.exclusiveTax > 0) {
        bluetooth.printCustom(sideTextCustomSize("Exclusive-Taxed ", Number.getNumber(order.exclusiveTax), leftWidth: 26), 1, 0);
        bluetooth.printCustom("Items:", 1, 0);
        bluetooth.printCustom(sideTextCustomSize("None Exclusive-Taxed ", Number.getNumber(exclusiveNonTaxableItem), leftWidth: 26), 1, 0);
        bluetooth.printCustom("Items:", 1, 0);
        bluetooth.printNewLine();
      }
      if (order.inclusiveTax > 0) {
        bluetooth.printCustom(sideTextCustomSize("Inclusive-Taxed ", Number.getNumber(order.inclusiveTax), leftWidth: 26), 1, 0);
        bluetooth.printCustom("Items:", 1, 0);
        bluetooth.printCustom(sideTextCustomSize("None Inclusive-Taxed", Number.getNumber(inclusiveNonTaxableItem), leftWidth: 26), 1, 0);
        bluetooth.printCustom("Items:", 1, 0);
        bluetooth.printNewLine();
      }
    }

    if (order.status == 4) {
      //void
      bluetooth.printCustom("**Voided**", 1, 1);
    } else if (order.status == 3) {
      //paid
      bluetooth.printCustom("**PAID**", 1, 1);
    }
    bluetooth.printNewLine();
    bluetooth.printCustom("Reference No." + order.ticket_number.toString(), 1, 1);

    if (order.no_of_guests > 0 && order.service_id != null && order.service_id == 1)
      bluetooth.printCustom("Number Of guests " + order.no_of_guests.toString(), 1, 1);
  }

  Future<void> printRecieptItems(OrderHeader order) async {
    Preference? preference = locator.get<ConnectionRepository>().preference;
    String weightUnit = "";
    String _taxLabel = "";
    for (var item in order.transaction) {
      weightUnit = "";
      if (item.menu_item!.order_By_Weight != null && item.menu_item!.order_By_Weight!) {
        weightUnit = item.menu_item!.weight_unit!;
      }

      _taxLabel = "";
      if ((item.apply_tax1 != null && item.apply_tax1 && item.tax1_amount != null && item.tax1_amount > 0) ||
          (item.apply_tax2 != null && item.apply_tax2 && item.tax2_amount != null && item.tax2_amount > 0) ||
          (item.apply_tax3 != null && item.apply_tax3 && item.tax3_amount != null && item.tax3_amount > 0)) {
        _taxLabel += " (T)";
      }

      if (item.status == 1) {
        if (preference!.printRecipetNameAsSeconderyName != null &&
            preference.printRecipetNameAsSeconderyName! &&
            item.menu_item!.receipt_text != "" &&
            item.menu_item!.receipt_text != null &&
            item.menu_item!.receipt_text != item.menu_item!.name) {
          bluetooth.printCustom(
              menuItem(item.qtyString + weightUnit, item.menu_item!.name! + " " + _taxLabel, Number.getNumber(item.grand_price)), 1, 0);
        } else {
          bluetooth.printCustom(
              menuItem(item.qtyString + weightUnit, item.menu_item!.receiptName! + " " + _taxLabel, Number.getNumber(item.grand_price)), 1, 0);
        }

        if ((item.discount != null)) {
          bluetooth.printCustom(discountText(item.discount!.name.toString() + "  (-" + Number.getNumber(item.discount_actual_price) + ")"), 1, 0);
        }
      } else if (item.status == 2) {
        if (!preference!.hideVoidedItem) {
          bluetooth.printCustom(voidedMenuItem(item.menu_item!.receiptName! + "(Voided)"), 1, 0);
        }
        continue;
      }

      if (item.modifiers != null)
        for (var modifer in item.modifiers!) {
          bluetooth.printCustom(menuModifier(modifer), 1, 0);
        }

      if (item.sub_menu_item != null)
        for (var item in item.sub_menu_item!) {
          bluetooth.printCustom(subMenuItem(item), 1, 0);

          if (item.modifiers != null)
            for (var modifer in item.modifiers!) {
              bluetooth.printCustom(menuModifier(modifer), 1, 0);
            }
        }
    }
  }

  printLine(String char) {
    String temp = "";
    if (printerSize == 3) {
      for (var i = 0; i < 48; i++) {
        temp += char;
      }
    } else {
      for (var i = 0; i < 32; i++) {
        temp += char;
      }
    }
    return temp;
  }

  drawLine(String char) {
    String temp = "";
    if (printerSize == 3) {
      for (var i = 0; i < 48; i++) {
        temp += char;
      }
    } else {
      for (var i = 0; i < 60; i++) {
        temp += char;
      }
    }
    return temp;
  }

  String menuItem(String qty, String name, String price) {
    String text = "";
    if (printerSize == 3) {
      if (name.length > 34) {
        name = name.substring(0, 33);
      }
      text += qty.padRight(4);
      text += name.padRight(34);
      text += price.padLeft(10);
    } else if (printerSize == 2) {
      if (name.length > 20) {
        name = name.substring(0, 19);
      }
      text += qty.padRight(4);
      text += name.padRight(20);
      text += price.padLeft(8);
    }

    return text;
  }

  String voidedMenuItem(String text) {
    if (printerSize == 3) {
      if (text.length > 43) {
        text = text.substring(0, 43);
      }
      return text.padLeft(4);
    } else if (printerSize == 2) {
      if (text.length > 27) {
        text = text.substring(0, 27);
      }
      return text.padLeft(4);
    }
    return text;
  }

  String menuModifier(TransactionModifier modifer) {
    Preference? preference = locator.get<ConnectionRepository>().preference;

    String text = "";
    String _modPrice = "";
    String _modQty = "";
    if (modifer.price == null || modifer.price == 0) {
      _modPrice = "";
    } else {
      _modPrice = " (Ex " + Number.getNumber(modifer.price) + ")";
    }

    if (preference!.printModPriceOnTicket != null && !preference.printModPriceOnTicket!) {
      _modPrice = "";
    }

    if (modifer.qty > 1) {
      _modQty = modifer.qty.toString() + "X";
    }

    if (printerSize == 3) {
      text += "".padRight(6);
      text += (_modQty + modifer.recieptName! + _modPrice).padRight(24);
    } else if (printerSize == 2) {
      text += "".padRight(6);
      text += (_modQty + modifer.recieptName! + _modPrice).padRight(24);
    }

    return text;
  }

  String subMenuItem(TransactionCombo item) {
    String text = "";
    String _qty = "";
    if (item.qty > 1) {
      _qty = item.qty.toString();
    }

    if (printerSize == 3) {
      text += "".padRight(6);
      text += (_qty + " " + item.menu_item!.receiptName!).padRight(24);
    } else if (printerSize == 2) {
      text += "".padRight(6);
      text += (_qty + " " + item.menu_item!.receiptName!).padRight(24);
    }
    return text;
  }

  String discountText(String text) {
    String text = "";
    if (printerSize == 3) {
      text += "".padRight(6);
      text += text.padRight(24);
    } else if (printerSize == 2) {
      text += "".padRight(8);
      text += text.padRight(22);
    }

    return text;
  }

  String sideText(String left, String right, {bool doubleWidth = false}) {
    String text = "";
    if (printerSize == 3) {
      text += left.padRight((doubleWidth) ? 12 : 24);
      text += right.padLeft((doubleWidth) ? 12 : 24);
    } else if (printerSize == 2) {
      text += left.padRight((doubleWidth) ? 8 : 16);
      text += right.padLeft((doubleWidth) ? 8 : 16);
    }
    return text;
  }

  String sideTextCustomSize(String left, String right, {int leftWidth = 0, int rightWidth = 0}) {
    if (leftWidth == 0) {
      if (printerSize == 3) {
        leftWidth = 24;
      } else if (printerSize == 2) {
        leftWidth = 16;
      }
    }

    if (rightWidth == 0) {
      if (printerSize == 3) {
        rightWidth = 48 - leftWidth;
      } else if (printerSize == 2) {
        rightWidth = 32 - leftWidth;
      }
    }

    String text = "";
    text += left.padRight(leftWidth);
    text += right.padLeft(rightWidth);
    return text;
  }

  String threeColumn(String text1, String text2, text3, {bool doubleWidth = false}) {
    String text = "";
    if (printerSize == 3) {
      //48
      text += text1.padRight((doubleWidth) ? 8 : 16);
      text += text2.padRight((doubleWidth) ? 8 : 16);
      text += text3.padLeft((doubleWidth) ? 8 : 16);
    } else if (printerSize == 2) {
      // 32
      text += text1.padRight((doubleWidth) ? 6 : 11);
      text += text2.padRight((doubleWidth) ? 6 : 11);
      text += text3.padLeft((doubleWidth) ? 5 : 10);
    }
    return text;
  }

  String customthreeColumn(String text1, String text2, text3, {bool doubleWidth = false}) {
    String text = "";
    if (printerSize == 3) {
      //48
      text += text1.padRight((doubleWidth) ? 5 : 13);
      text += text2.padRight((doubleWidth) ? 9 : 17);
      text += text3.padleft((doubleWidth) ? 8 : 16);
    } else if (printerSize == 2) {
      // 32
      text += text1.padRight((doubleWidth) ? 4 : 9);
      text += text2.padRight((doubleWidth) ? 7 : 12);
      text += text3.padLeft((doubleWidth) ? 6 : 10);
    }
    return text;
  }

  String fourColumn(String text1, String text2, text3, String text4, {bool doubleWidth = false}) {
    String text = "";
    if (printerSize == 3) {
      //48
      text += text1.padRight((doubleWidth) ? 6 : 12);
      text += text2.padRight((doubleWidth) ? 6 : 12);
      text += text3.padLeft((doubleWidth) ? 6 : 12);
      text += text4.padLeft((doubleWidth) ? 6 : 12);
    } else if (printerSize == 2) {
      // 32
      text += text1.padRight((doubleWidth) ? 4 : 8);
      text += text2.padRight((doubleWidth) ? 4 : 8);
      text += text3.padLeft((doubleWidth) ? 4 : 8);
      text += text4.padLeft((doubleWidth) ? 4 : 8);
    }
    return text;
  }

  String drawerCode(String cashDrawarCode) {
    String temp = "";
    try {
      List<String> codes = cashDrawarCode.split(',');

      for (var item in codes) {
        temp += utf8.decode(List<int>.empty(growable: true)..add(int.parse(item)));
      }
      return temp;
    } catch (e) {
      return temp;
      // print(e);
    }
  }

  openDrawer(String cashDrawarCode) async {
    if (cashDrawarCode == null || cashDrawarCode == "") {
      cashDrawarCode = "27,112,0,25,200";
    }

    bool? isConnected = await bluetooth.isConnected;
    if (isConnected!) {
      bluetooth.write(drawerCode(cashDrawarCode));
    }
  }
}
