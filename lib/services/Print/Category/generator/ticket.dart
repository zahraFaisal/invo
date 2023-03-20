import 'dart:convert';
import 'dart:ui';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:esc_pos_utils_plus/gbk_codec/gbk_codec.dart';
import 'package:esc_pos_utils_plus/gbk_codec/src/body_element.dart';
import 'package:esc_pos_utils_plus/gbk_codec/src/converter_gbk.dart';
import 'package:esc_pos_utils_plus/gbk_codec/src/converter_gbk_byte.dart';
import 'package:esc_pos_utils_plus/gbk_codec/src/create_map.dart';
import 'package:esc_pos_utils_plus/gbk_codec/src/gbk_maps.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/services/Print/Category/OrderPrint.dart';
import 'package:invo_mobile/services/Print/PrintFormat.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as im;

import '../../../../models/preference.dart';
import '../../../../service_locator.dart';
import '../../../../widgets/translation/app_localizations.dart';

class GenerateTicket {
  late OrderPrint orderPrint = OrderPrint();
  late String lang = "en";
  late AppLocalizations appLocalizations = AppLocalizations(const Locale("en"));

  GenerateTicket() {
    loadLanguage();
  }

  loadLanguage() async {
    lang = locator.get<ConnectionRepository>().terminal!.getLangauge()!;
    this.appLocalizations = await AppLocalizations.load(Locale(lang));
  }

  Future<List<int>> cashierReport(CashierReportModel report, bool isNote, {bool cashIn = false}) async {
    Preference? preference = locator.get<ConnectionRepository>().preference;
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    if (isNote) {
      bytes += ticket.text(
        "*** This is not a final report***\n For the final report please check the daily closing report",
        styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size3),
      );
      bytes += ticket.feed(1);
      bytes += ticket.text(
        preference!.restaurantName.toString(),
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );
      if (preference.phone != null)
        bytes += ticket.text(
          preference.phone.toString(),
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );
      if (preference.fax != null)
        bytes += ticket.text(
          preference.fax.toString(),
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );
      bytes += ticket.hr();
    }
    bytes += ticket.text(
      "Cashier Report",
      styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size2),
    );

    bytes += ticket.text(
      "Cashier: " + report.name.toString(),
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += ticket.text(
      "Starting",
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += ticket.row([
      PosColumn(
        text: "Date:" +
            report.cashier_days(report.cashier_in) +
            "/" +
            report.cashier_month(report.cashier_in) +
            "/" +
            report.cashier_year(report.cashier_in),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: "Time: " + report.cashier_hour(report.cashier_in) + ":" + report.cashier_min(report.cashier_in),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);
    if (report.cashier_out != null) {
      bytes += ticket.text(
        "Closing",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );
      bytes += ticket.row([
        PosColumn(
          text: "Date:" +
              report.cashier_days(report.cashier_out) +
              "/" +
              report.cashier_month(report.cashier_out) +
              "/" +
              report.cashier_year(report.cashier_out),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Time: " + report.cashier_hour(report.cashier_out) + ":" + report.cashier_min(report.cashier_out),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    bytes += ticket.hr();

    if (report.total_Transactions != null || report.total_income != 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Tranactions:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: report.total_Transactions.toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += ticket.row([
        PosColumn(
          text: "Opening Amount:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.start_amount),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += ticket.row([
        PosColumn(
          text: "Total Payments:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.total_Sale),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += ticket.row([
        PosColumn(
          text: "Total Income:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.total_income),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    bytes += ticket.feed(2);
    if (report.details.length > 0) {
      bytes += ticket.text(
        "Sales By Tender",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += ticket.row([
        PosColumn(
          text: "Tenders",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Total",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: "Equivalant",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += ticket.hr();
      for (var item in report.details) {
        bytes += await cashierByTender(item);
      }
      bytes += ticket.hr();

      bytes += ticket.row([
        PosColumn(
          text: "",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: "Net Sale:",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.netSale),
          width: 4,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += ticket.feed(2);
    }

    if (report.categoryReports.length > 0) {
      bytes += ticket.text(
        "Income By Category",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      for (var item in report.categoryReports) {
        bytes += await incomeByCategory(item);
      }

      bytes += ticket.row([
        PosColumn(
          text: "Category Total:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.categoryTotal),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += ticket.hr();
      bytes += ticket.row([
        PosColumn(
          text: "Total:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.categoryTotal),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += ticket.feed(2);
    }

    if (report.combine.length > 0) {
      bytes += ticket.text(
        "Short/Over Report",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += ticket.hr();

      for (var item in report.combine) {
        bytes += await byShortOver(item, report);
      }

      bytes += ticket.hr();
    }
    if (cashIn) {
      if (report.local_currency.length > 0) {
        bytes += ticket.text(
          "Local Currency",
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );
        bytes += ticket.feed(1);
        bytes += ticket.row([
          PosColumn(
            text: "",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "Qty",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "Total",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.hr();
        for (var item in report.local_currency) {
          bytes += ticket.row([
            PosColumn(
              text: item.type.toString(),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: item.qty.toString(),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: Number.getNumber(item.amount),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
          ]);
        }
        bytes += ticket.hr();
        bytes += ticket.row([
          PosColumn(
            text: "Extra Cash",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.getNumber(report.extra_cash),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.hr();
        bytes += ticket.row([
          PosColumn(
            text: "Total",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.formatCurrency(report.localCurrencyTotal),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.feed(1);
      }

      if (report.other_tenders.length > 0) {
        bytes += ticket.text(
          "Other Tenders",
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );
        bytes += ticket.feed(1);
        bytes += ticket.row([
          PosColumn(
            text: "Name",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "Total",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "Equivalant",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.hr();
        for (var item in report.other_tenders) {
          bytes += ticket.row([
            PosColumn(
              text: item.payment_method!.name.toString(),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: Number.getNumber(item.amount!),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: Number.getNumber(item.amount!),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
          ]);
        }
        bytes += ticket.hr();

        bytes += ticket.row([
          PosColumn(
            text: "Total",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.formatCurrency(report.otherTenderTotal),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.feed(1);
      }
      if (report.forignCurrency.length > 0) {
        bytes += ticket.text(
          "Forign Currency",
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );
        bytes += ticket.feed(1);
        bytes += ticket.row([
          PosColumn(
            text: "Currency",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "Total",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: "Equivalant",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.hr();
        for (var item in report.forignCurrency) {
          bytes += ticket.row([
            PosColumn(
              text: item.payment_method!.name.toString(),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: Number.getNumber(item.amount!),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: Number.getNumber(item.equivalant),
              width: 4,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
          ]);
        }
        bytes += ticket.hr();

        bytes += ticket.row([
          PosColumn(
            text: "Total",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.formatCurrency(report.forignCurrencyTotal),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
      }
      bytes += ticket.hr();

      bytes += ticket.row([
        PosColumn(
          text: "Total",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.count),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += ticket.feed(1);
    }
    bytes += ticket.feed(1);

    return bytes;
  }

  Future<List<int>> cashierByTender(CashierReportDetails item) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(
        text: item.payment_method.toString(),
        width: 4,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: Number.getNumber(item.amount_paid),
        width: 4,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: Number.getNumber(item.actual_amount_paid),
        width: 4,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> incomeByCategory(CategoryCashier item) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(
        text: item.category_name!,
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: Number.getNumber(item.total!),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> openCashiers(OpenCashier item) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(
        text: item.id.toString(),
        width: 4,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: item.name.toString(),
        width: 4,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: item.computer_id.toString(),
        width: 4,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> openOrders(OpenOrder item) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(
        text: item.date_time!.day.toString() + "/" + item.date_time!.month.toString() + "/" + item.date_time!.year.toString(),
        width: 3,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: item.id.toString(),
        width: 3,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: item.serivce_name.toString(),
        width: 3,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: Number.getNumber(item.grand_price),
        width: 3,
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> salesByCategory(CategoryReport item) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += ticket.row([
      PosColumn(
        text: item.category_name.toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: Number.getNumber(item.total!),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> salesByTender(SalesByTender item) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(
        text: item.payment_method.toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: Number.getNumber(item.total!),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> salesByService(SalesService item) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(
        text: item.service_name.toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: Number.getNumber(item.total!),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> byShortOver(item, report) async {
    final profile = await CapabilityProfile.load();
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];

    if (item.payment_method != "Account") {
      if (item.payment_method_id == 1) {
        bytes += ticket.text(
          item.payment_method.toString(),
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );
        bytes += ticket.row([
          PosColumn(
            text: "Expected:",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.getNumber(item.start_amount + item.amount_paid - report.payOut_total).toString(),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.row([
          PosColumn(
            text: "Count:",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.getNumber(item.end_amount).toString(),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);

        bytes += ticket.row([
          PosColumn(
            text: "Short Over:",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.getNumber(item.end_amount - (item.start_amount + item.amount_paid - report.payOut_total)).toString(),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
      } else {
        bytes += ticket.text(
          item.payment_method.toString(),
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );
        bytes += ticket.row([
          PosColumn(
            text: "Expected:",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.getNumber(item.start_amount + item.amount_paid).toString(),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
        bytes += ticket.row([
          PosColumn(
            text: "Count:",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.getNumber(item.end_amount).toString(),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);

        bytes += ticket.row([
          PosColumn(
            text: "Short Over:",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: Number.getNumber(item.end_amount - (item.start_amount + item.amount_paid)).toString(),
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
      }
    }

    return bytes;
  }

  Future<List<int>> getClosingReport(DailyClosingModel report, Preference preference, DateTime date,
      {bool drawer = false, String? drawer_code}) async {
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final profile = await CapabilityProfile.load();
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bool isNote = false;
    bytes += ticket.text(
      preference.restaurantName.toString(),
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    if (preference.phone != null)
      bytes += ticket.text(
        preference.phone.toString(),
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );
    if (preference.fax != null)
      bytes += ticket.text(
        preference.fax.toString(),
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

    bytes += ticket.hr();
    bytes += ticket.text(
      "Daily Sales",
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    bytes += ticket.text(
      date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString(),
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(
        text: "Total Order:",
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: report.total_order.toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += ticket.row([
      PosColumn(
        text: "Total Transactions:",
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: report.total_transaction.toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += ticket.hr();

    bytes += ticket.row([
      PosColumn(
        text: "Total Sale:",
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: Number.formatCurrency(report.total_sale),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    if (report.total_charge_per_hour > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Charge Per Hour:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_charge_per_hour).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_minimum_charge > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Minimum Charge:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_minimum_charge).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_discount_amount > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Discount:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_discount_amount).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_surcharge_amount > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Surcharge:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_surcharge_amount).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_delivery_charge > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Delivery Charge:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_delivery_charge).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_tax > 0) {
      bytes += ticket.row([
        PosColumn(
          text: preference.tax1_name != null ? preference.tax1_name.toString() + ":" : "Tax 1:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_tax).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_tax2 > 0) {
      bytes += ticket.row([
        PosColumn(
          text: preference.tax2_name != null ? preference.tax2_name.toString() + ":" : "Tax 2:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_tax2).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_tax3 > 0) {
      bytes += ticket.row([
        PosColumn(
          text: preference.tax3_name != null ? preference.tax3_name.toString() + ":" : "Tax 3:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_tax3).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_rounding > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Rounding:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_rounding).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_payOut > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Pay Out:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_payOut).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    bytes += ticket.row([
      PosColumn(
        text: "Net Income:",
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
        ),
      ),
      PosColumn(
        text: Number.formatCurrency((report.total - report.total_payOut)),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
        ),
      ),
    ]);

    bytes += ticket.hr();

    if (report.totalGuests > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Guests:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: report.totalGuests.toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }

    if (report.total_void > 0) {
      bytes += ticket.row([
        PosColumn(
          text: "Total Void:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.getNumber(report.total_void).toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
    }
    if (report.total_void > 0 || report.totalGuests > 0) {
      bytes += ticket.hr();
    }

    if (report.serviceReports.length > 0) {
      bytes += ticket.text(
        "Sales By Service",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += ticket.hr();

      for (var item in report.serviceReports) {
        salesByService(item);
      }
      bytes += ticket.row([
        PosColumn(
          text: "Total:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.total_service_sales),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += ticket.hr();
    }

    if (report.tenderReports.length > 0) {
      bytes += ticket.text(
        "Income By Tender",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += ticket.hr();

      for (var item in report.tenderReports) {
        salesByTender(item);
      }
      bytes += ticket.row([
        PosColumn(
          text: "Total:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.total_tender_sales),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += ticket.hr();
    }

    if (report.categoryReports.length > 0) {
      bytes += ticket.text(
        "Sales By Category",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += ticket.hr();

      for (var item in report.categoryReports) {
        bytes += await salesByCategory(item);
      }
      bytes += ticket.row([
        PosColumn(
          text: "Total:",
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
          ),
        ),
        PosColumn(
          text: Number.formatCurrency(report.total_category_sales),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += ticket.hr();
    }
    bytes += ticket.feed(2);
    // put cashier Report here
    for (var item in report.cashierReports) {
      bytes += await cashierReport(item, isNote);
    }

    if (report.openOrders.length > 0) {
      bytes += ticket.text(
        "Open Orders",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );
      bytes += ticket.hr();
      bytes += ticket.row([
        PosColumn(
          text: "Date",
          width: 3,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: "Order",
          width: 3,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: "Type",
          width: 3,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: "Total",
          width: 3,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
      ]);

      bytes += ticket.hr();

      for (var item in report.openOrders) {
        bytes += await openOrders(item);
      }
      bytes += ticket.hr();
    }

    if (report.openCashiers.length > 0) {
      bytes += ticket.text(
        "Open Cashiers",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );
      bytes += ticket.hr();
      bytes += ticket.row([
        PosColumn(
          text: "Cashier ID",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: "Name",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: "Terminal",
          width: 4,
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        ),
      ]);

      bytes += ticket.hr();

      for (var item in report.openCashiers) {
        bytes += await openCashiers(item);
      }
      bytes += ticket.hr();
    }
    bytes += ticket.feed(3);
    bytes += ticket.cut();
    // if (drawer != null && drawer) bytes += ticket.text(drawerCode(drawer_code));

    return bytes;
  }

  getCashierReport(CashierReportModel report, bool isNote, {bool cashIn = false}) async {
    Preference? preference = locator.get<ConnectionRepository>().preference;
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    final profile = await CapabilityProfile.load();
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += await cashierReport(report, isNote, cashIn: cashIn);
    bytes += ticket.feed(3);
    bytes += ticket.cut();
    return bytes;
  }

  getTicketBytes(List<PrintFormat> list, {bool kitchen = false}) async {
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;

    final profile = await CapabilityProfile.load();
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];

    list.forEach((printFormat) async {
      if (printFormat.type == PrintFormatType.center) {
        bytes += ticket.text(printFormat.data[0],
            styles: const PosStyles(
              align: PosAlign.center,
            ));
      } else if (printFormat.type == PrintFormatType.twoColumns) {
        bytes += ticket.row([
          PosColumn(
            text: printFormat.data[0],
            width: 6,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: printFormat.data[1],
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      } else if (printFormat.type == PrintFormatType.menuItem) {
        bytes += ticket.row([
          PosColumn(
            text: printFormat.data[0] + " " + printFormat.data[1],
            width: 6,
            styles: PosStyles(
              height: kitchen == true ? PosTextSize.size2 : PosTextSize.size1,
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: printFormat.data[2],
            width: 6,
            styles: PosStyles(
              height: kitchen == true ? PosTextSize.size2 : PosTextSize.size1,
              align: PosAlign.right,
            ),
          ),
        ]);
      } else if (printFormat.type == PrintFormatType.discount) {
        bytes += ticket.text(printFormat.data[0], styles: const PosStyles(align: PosAlign.center));
      } else if (printFormat.type == PrintFormatType.doubleHeight) {
      } else if (printFormat.type == PrintFormatType.single) {
        bytes += ticket.row([
          PosColumn(
            text: printFormat.data[0],
            width: 6,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: "",
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      } else if (printFormat.type == PrintFormatType.line) {
        if (printFormat.data.length > 0) {
          bytes += ticket.hr();
        }
      } else if (printFormat.type == PrintFormatType.twoColumnsTextCustomSize) {
        bytes += ticket.row([
          PosColumn(
            text: printFormat.data[0],
            width: 8,
            // ignore: prefer_const_constructors
            styles: PosStyles(
              align: PosAlign.left,
            ),
          ),
          PosColumn(
            text: printFormat.data[1],
            width: 4,
            // ignore: prefer_const_constructors
            styles: PosStyles(
              align: PosAlign.right,
            ),
          ),
        ]);
      } else if (printFormat.type == PrintFormatType.menuModifier) {
        bytes += ticket.row([
          PosColumn(
            text: orderPrint
                .menuModifierDrawing(double.parse(printFormat.data[1]), double.parse(printFormat.data[2]).toInt(), printFormat.data[0])
                .padLeft(8),
            width: 9,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: "",
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      } else if (printFormat.type == PrintFormatType.voided) {
        bytes += ticket.row([
          PosColumn(
            text: printFormat.data[0],
            width: 6,
            styles: PosStyles(align: PosAlign.left, height: kitchen == true ? PosTextSize.size2 : PosTextSize.size1),
          ),
          PosColumn(
            text: "",
            width: 6,
            styles: PosStyles(align: PosAlign.right, height: kitchen == true ? PosTextSize.size2 : PosTextSize.size1),
          ),
        ]);
      } else if (printFormat.type == PrintFormatType.total) {
        bytes += ticket.row([
          PosColumn(
            text: printFormat.data[0],
            width: 6,
            styles: const PosStyles(align: PosAlign.left, height: PosTextSize.size2),
          ),
          PosColumn(
            text: printFormat.data[1],
            width: 6,
            styles: const PosStyles(align: PosAlign.right, height: PosTextSize.size2),
          ),
        ]);
      }
    });

    bytes += ticket.feed(3);
    bytes += ticket.cut();

    return bytes;
  }

  getImageTicket(List<PrintFormat> list, {bool kitchen = false}) async {
    final Terminal? terminal = locator.get<ConnectionRepository>().terminal;

    final profile = await CapabilityProfile.load();
    final ticket = Generator(terminal!.printerSize == "80" ? PaperSize.mm80 : PaperSize.mm58, profile);

    Preference? preference = locator.get<ConnectionRepository>().preference;
    double position = 0.0;
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 25,
    );

    TextStyle totalStyle = const TextStyle(
      color: Colors.black,
      fontSize: 35,
    );

    TextStyle kitchenStyle = const TextStyle(
      color: Colors.black,
      fontSize: 35,
    );
    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder, Rect.fromPoints(const Offset(0.0, 0.0), const Offset(200, 200)));
    canvas.drawColor(Colors.white, BlendMode.src);
    TextPainter textPainter;
    list.forEach((printFormat) async {
      if (printFormat.textStyle == null) {
        printFormat.textStyle = textStyle;
      } else if (printFormat.textStyle == null && (printFormat.type == PrintFormatType.total)) {
        printFormat.textStyle = totalStyle;
      }

      if (printFormat.type == PrintFormatType.logo) {
        var temp = base64.decode(printFormat.data[0]);
        im.Image? img = im.decodeImage(temp.buffer.asUint8List());
        ticket.image(img!);
      } else if (printFormat.type == PrintFormatType.center) {
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: printFormat.textStyle), textAlign: TextAlign.center, textDirection: TextDirection.ltr)
          ..layout(minWidth: 600);
        textPainter.paint(canvas, Offset(0, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.twoColumns) {
        if (this.lang == 'ar') printFormat.data = printFormat.data.reversed.toList();
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: printFormat.textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
          ..layout(minWidth: 300);
        textPainter.paint(canvas, Offset(0, position));

        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[1], style: printFormat.textStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
          ..layout(minWidth: 300);
        textPainter.paint(canvas, Offset(250, position));
        if (kitchen == true)
          position = position + 50;
        else
          position = position + 40;
      } else if (printFormat.type == PrintFormatType.menuItem) {
        //width 600
        if (this.lang == 'en') {
          //qty
          textPainter = TextPainter(
              text: TextSpan(text: printFormat.data[0], style: kitchen == true ? kitchenStyle : printFormat.textStyle),
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr)
            ..layout(minWidth: 100);
          textPainter.paint(canvas, Offset(0, position));

          //name
          textPainter = TextPainter(
              text: TextSpan(text: printFormat.data[1], style: kitchen == true ? kitchenStyle : printFormat.textStyle),
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr)
            ..layout(minWidth: 300);
          textPainter.paint(canvas, Offset(50, position));

          //price
          textPainter = TextPainter(
              text: TextSpan(text: printFormat.data[2], style: kitchen == true ? kitchenStyle : printFormat.textStyle),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl)
            ..layout(minWidth: 200);
          textPainter.paint(canvas, Offset(350, position));
        } else {
          //price
          textPainter = TextPainter(
              text: TextSpan(text: printFormat.data[2], style: kitchen == true ? kitchenStyle : printFormat.textStyle),
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr)
            ..layout(minWidth: 200);
          textPainter.paint(canvas, Offset(0, position));

          //name
          textPainter = TextPainter(
              text: TextSpan(text: printFormat.data[1], style: kitchen == true ? kitchenStyle : printFormat.textStyle),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl)
            ..layout(minWidth: 300);
          textPainter.paint(canvas, Offset(180, position));

          //qty
          textPainter = TextPainter(
              text: TextSpan(text: printFormat.data[0], style: kitchen == true ? kitchenStyle : printFormat.textStyle),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl)
            ..layout(minWidth: 100);
          textPainter.paint(canvas, Offset(450, position));
        }
        if (kitchen == true)
          position = position + 50;
        else
          position = position + 30;
      } else if (printFormat.type == PrintFormatType.discount) {
        if (this.lang == 'ar') printFormat.data = printFormat.data.reversed.toList();
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: printFormat.textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
          ..layout(maxWidth: 600);
        textPainter.paint(canvas, Offset(200, position));
        position = position + 30.0;
      } else if (printFormat.type == PrintFormatType.doubleHeight) {
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.single) {
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: printFormat.textStyle),
            textAlign: this.lang == 'ar' ? TextAlign.right : TextAlign.left,
            textDirection: TextDirection.ltr)
          ..layout(minWidth: 550);
        textPainter.paint(canvas, Offset(0, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.voided) {
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: kitchen == true ? kitchenStyle : printFormat.textStyle),
            textAlign: this.lang == 'ar' ? TextAlign.right : TextAlign.left,
            textDirection: this.lang == 'ar' ? TextDirection.rtl : TextDirection.ltr)
          ..layout(minWidth: 550);
        textPainter.paint(canvas, Offset(0, position));
        if (kitchen == true)
          position = position + 50;
        else
          position = position + 30;
      } else if (printFormat.type == PrintFormatType.line) {
        if (printFormat.data.length > 0) {
          textPainter = TextPainter(
              text: TextSpan(text: orderPrint.printLine("-"), style: textStyle), textAlign: TextAlign.center, textDirection: TextDirection.ltr)
            ..layout(maxWidth: 600);
          textPainter.paint(canvas, Offset(0, position));
          position = position + 30;
        }
      } else if (printFormat.type == PrintFormatType.twoColumnsTextCustomSize) {
        if (this.lang == 'ar') printFormat.data = printFormat.data.reversed.toList();
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: printFormat.textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
          ..layout(minWidth: 300);
        textPainter.paint(canvas, Offset(0, position));

        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[1], style: printFormat.textStyle), textAlign: TextAlign.right, textDirection: TextDirection.ltr)
          ..layout(minWidth: 300);
        textPainter.paint(canvas, Offset(250, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.menuModifier) {
        textPainter = TextPainter(
            text: TextSpan(
                text:
                    orderPrint.menuModifierDrawing(double.parse(printFormat.data[1]), double.parse(printFormat.data[2]).toInt(), printFormat.data[0]),
                style: printFormat.textStyle),
            textAlign: this.lang == 'ar' ? TextAlign.right : TextAlign.left,
            textDirection: this.lang == 'ar' ? TextDirection.rtl : TextDirection.ltr)
          ..layout(maxWidth: 600);
        textPainter.paint(canvas, Offset(this.lang == 'ar' ? 400 : 50, position));
        position = position + 30;
      } else if (printFormat.type == PrintFormatType.total) {
        if (this.lang == 'ar') printFormat.data = printFormat.data.reversed.toList();
        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[0], style: printFormat.textStyle), textAlign: TextAlign.left, textDirection: TextDirection.ltr)
          ..layout(minWidth: 300);
        textPainter.paint(canvas, Offset(0, position));

        textPainter = TextPainter(
            text: TextSpan(text: printFormat.data[1], style: printFormat.textStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
          ..layout(minWidth: 300);
        textPainter.paint(canvas, Offset(250, position));
        position = position + 50;
      }
    });
    position = position + 60;
    textPainter = TextPainter(text: TextSpan(text: "", style: totalStyle), textAlign: TextAlign.right, textDirection: TextDirection.rtl)
      ..layout(minWidth: 200);
    textPainter.paint(canvas, Offset(0, position));

    var picture = recorder.endRecording();
    var img = await picture.toImage(600, position.ceil());
    var pngBytes = await img.toByteData(format: ImageByteFormat.png);
    im.Image? receiptImg = im.decodeImage(pngBytes!.buffer.asUint8List());

    List<int> bytes = [];
    bytes += ticket.image(receiptImg!);
    bytes += ticket.feed(3);
    bytes += ticket.cut();

    return bytes;
  }
}
