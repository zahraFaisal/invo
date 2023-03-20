import 'dart:io';
import 'dart:ui';

import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/services/Print/Category/Template/Page.dart';
import 'package:invo_mobile/services/Print/Category/Template/TemplateFormat.dart';
import 'package:invo_mobile/services/Print/Category/Template/TemplatePrint.dart';
import 'package:invo_mobile/services/Print/Category/Template/TemplateTypeConverter.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

import '../../Print/PrintFormat.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class OrderPrint {
  AppLocalizations appLocalizations = AppLocalizations(Locale("en"));
  Terminal? terminal = locator.get<ConnectionRepository>().terminal;

  String lang = "en";
  var fileData;
  OrderPrint() {
    loadLanguage();
  }

  loadLanguage() async {
    this.lang = locator.get<ConnectionRepository>().terminal!.getLangauge()!;
    this.appLocalizations = await AppLocalizations.load(Locale(lang));
  }

  loadFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    File filetocheck = File('/data/user/0/com.invopos.invo_mobile/app_flutter/receiptTemplate/Bahrain_Inclusive_Tax_Recipet.json');
    if ((await filetocheck.exists())) {
      // TODO:
      print("file exist");
    } else {
      // TODO:
      print("file not exist");
    }
    try {
      File file = File('$appDocPath/receiptTemplate/${terminal!.selectedTemp}');
      final String response = await file.readAsString();
      // final String response = await rootBundle.loadString('{$appDocPath/receiptTemplate/${terminal!.selectedTemp}');
      this.fileData = await json.decode(response);
    } catch (e) {
      print(e);
    }
  }

  List<PrintFormat> restaurantInfo(OrderHeader order) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);

    Preference? preference = locator.get<ConnectionRepository>().preference;
    if (preference!.taxInvoiceTitle != null && preference.taxInvoiceTitle!) {
      printFormat.add(PrintFormat(PrintFormatType.center, ["Tax Invoice"]));
      printFormat.add(PrintFormat(PrintFormatType.line, ["-"]));
      printFormat.add(PrintFormat(PrintFormatType.line, ["-"]));
    }

    if (preference.printRestaurantName != null && preference.printRestaurantName!) {
      printFormat.add(PrintFormat(PrintFormatType.doubleHeight, []));
      printFormat.add(PrintFormat(PrintFormatType.center, [preference.restaurantName!]));
      printFormat.add(PrintFormat(PrintFormatType.cancelDoubleHeight, []));
    }

    if (preference.address1 != null && preference.address1 != "") {
      printFormat.add(PrintFormat(PrintFormatType.center, [preference.address1]));
    }

    if (preference.address2 != null && preference.address2 != "") {
      printFormat.add(PrintFormat(PrintFormatType.center, [preference.address2]));
    }

    if (preference.phone != null && preference.phone != "") {
      printFormat.add(PrintFormat(PrintFormatType.center, [preference.phone]));
    }

    if (preference.fax != null && preference.fax != "") {
      printFormat.add(PrintFormat(PrintFormatType.center, [preference.fax]));
    }

    if (preference.url != null && preference.url != "") {
      printFormat.add(PrintFormat(PrintFormatType.center, [preference.url]));
    }

    return printFormat;
  }

  List<PrintFormat> printOrderFooter(OrderHeader order) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    Preference? preference = locator.get<ConnectionRepository>().preference;
    if (order.isItemTotalVisible) {
      printFormat.add(PrintFormat(PrintFormatType.line, ["-"]));
    }

    if (order.total_charge_per_hour! > 0) {
      printFormat.add(PrintFormat(PrintFormatType.single, ["Total Hours (" + (order.total_charge_per_hour! / order.charge_per_hour).toString() + "h)"]));
    }

    if (order.isItemTotalVisible) {
      printFormat.add(PrintFormat(PrintFormatType.single, [appLocalizations.translate("Item Total"), Number.formatCurrency(order.item_total)]));
    }

    if (order.total_charge_per_hour! > 0) {
      printFormat.add(PrintFormat(PrintFormatType.single, [appLocalizations.translate("Charge Per Hour"), Number.formatCurrency(order.total_charge_per_hour!)]));
    }

    if (order.min_charge > 0) {
      printFormat.add(PrintFormat(PrintFormatType.single, [appLocalizations.translate("Charge Per Hour"), Number.formatCurrency(order.minimum_charge)]));
    }

    if (order.discount_amount > 0) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Discount"), Number.formatCurrency(order.discount_actual_amount)]));
    }

    if (order.surcharge_amount > 0) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Discount"), Number.formatCurrency(order.surcharge_actual_amount)]));
    }

    if (order.delivery_charge > 0) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Delivery Charge"), Number.formatCurrency(order.delivery_charge)]));
    }
    if (order.isItemTotalVisible || order.delivery_charge > 0 || order.surcharge_amount > 0 || order.discount_amount > 0 || order.min_charge > 0 || order.total_charge_per_hour! > 0) {
      printFormat.add(PrintFormat(PrintFormatType.line, ["-"]));
    }

    if (order.total_tax3 > 0) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [preference!.tax3Alias! + " Collected", Number.formatCurrency(order.total_tax3)]));
    }

    if (order.isSubTotalVisible) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Sub Total"), Number.formatCurrency(order.sub_total_price)]));
    }

    if (order.total_tax > 0) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [preference!.tax1Alias!, Number.formatCurrency(order.total_tax)]));
    }

    if (order.total_tax2 > 0) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [preference!.tax2Alias!, Number.formatCurrency(order.total_tax2)]));
    }

    if (order.Rounding != 0) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Rounding"), Number.formatCurrency(order.Rounding)]));
    }
    if (order.total_tax3 > 0 || order.isSubTotalVisible || order.total_tax > 0 || order.total_tax2 > 0 || order.Rounding != 0) printFormat.add(PrintFormat(PrintFormatType.line, ["-"]));
    printFormat.add(PrintFormat(PrintFormatType.line, []));

    printFormat.add(PrintFormat(PrintFormatType.doubleHeight, []));
    printFormat.add(PrintFormat(PrintFormatType.total, [appLocalizations.translate("Total"), Number.formatCurrency(order.grand_price)]));

    printFormat.add(PrintFormat(PrintFormatType.line, []));

    if (order.payments != null) {
      for (var payment in order.payments.where((t) => t.status == 0)) {
        if (payment.method != null) {
          printFormat.add(PrintFormat(PrintFormatType.twoColumns, [payment.method!.name.toString(), Number.getNumber(payment.actualAmountTendered)]));
        } else {
          printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Account"), Number.getNumber(payment.actualAmountTendered)]));
        }
      }
      if (order.payments.length > 0 && order.amountBalance > 0) {
        printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Balance"), Number.getNumber(order.amountBalance)]));
      }
      if (order.amountChange > 0) {
        printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Change"), Number.getNumber(order.amountChange)]));
      }
    }

    double exclusiveNonTaxableItem = order.sub_total_price - order.exclusiveTax;

    double inclusiveNonTaxableItem = order.sub_total_price - order.inclusiveTax;

    if (order.exclusiveTax > 0 || order.inclusiveTax > 0) {
      if (order.exclusiveTax > 0) {
        printFormat.add(PrintFormat(PrintFormatType.line, []));
        printFormat.add(PrintFormat(PrintFormatType.line, []));

        printFormat.add(PrintFormat(PrintFormatType.twoColumnsTextCustomSize, [appLocalizations.translate("Exclusive-Taxed Items:"), Number.getNumber(order.exclusiveTax)]));

        //printFormat.add( PrintFormat(PrintFormatType.single, ["Items:"]));
        printFormat.add(PrintFormat(PrintFormatType.twoColumnsTextCustomSize, [appLocalizations.translate("None Exclusive-Taxed Items:"), Number.getNumber(exclusiveNonTaxableItem)]));

        //printFormat.add( PrintFormat(PrintFormatType.single, ["Items:"]));
      }
      if (order.inclusiveTax > 0) {
        printFormat.add(PrintFormat(PrintFormatType.twoColumnsTextCustomSize, [appLocalizations.translate("Inclusive-Taxed Items"), Number.getNumber(order.inclusiveTax)]));
        //printFormat.add( PrintFormat(PrintFormatType.single, ["Items:"]));

        printFormat.add(PrintFormat(PrintFormatType.twoColumnsTextCustomSize, [appLocalizations.translate("None Inclusive-Taxed Items"), Number.getNumber(inclusiveNonTaxableItem)]));

        //printFormat.add( PrintFormat(PrintFormatType.single, ["Items:"]));
        printFormat.add(PrintFormat(PrintFormatType.line, []));
      }
    }

    if (order.status == 4) {
      //void
      printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("**Voided**")]));
    } else if (order.status == 3) {
      //paid
      printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("**PAID**")]));
    }

    printFormat.add(PrintFormat(PrintFormatType.doubleHeight, []));

    printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("Reference No.") + order.ticket_number.toString()]));

    if (order.no_of_guests > 0 && order.service_id != null && order.service_id == 1) printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("Number Of guests ") + order.no_of_guests.toString()]));

    return printFormat;
  }

  List<PrintFormat> printRecieptItems(OrderHeader order, {bool kitchen = false}) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
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
        if (preference!.printRecipetNameAsSeconderyName != null && preference.printRecipetNameAsSeconderyName! && item.menu_item!.receipt_text != "" && item.menu_item!.receipt_text != null && item.menu_item!.receipt_text != item.menu_item!.name) {
          printFormat.add(PrintFormat(PrintFormatType.menuItem, [item.qtyString + weightUnit, kitchen == true ? item.menu_item!.kitchen_name()! : item.menu_item!.receiptName! + " " + _taxLabel, Number.getNumber(item.grand_price)]));
        } else {
          printFormat.add(PrintFormat(PrintFormatType.menuItem, [item.qtyString + weightUnit, kitchen == true ? item.menu_item!.kitchen_name()! : item.menu_item!.name! + " " + _taxLabel, Number.getNumber(item.grand_price)]));
        }

        if ((item.discount != null)) {
          if (item.discount!.name != null && item.discount_actual_price != 0.0) {
            printFormat.add(PrintFormat(PrintFormatType.discount, [item.discount!.name.toString() + "  (-" + Number.getNumber(item.discount_actual_price) + ")"]));
          }
        }
      } else if (item.status == 2) {
        if (!preference!.hideVoidedItem) {
          printFormat.add(PrintFormat(PrintFormatType.voided, [item.menu_item!.receiptName! + appLocalizations.translate("(Voided)")]));

          continue;
        }
      }
      if (item.modifiers != null)
        // ignore: curly_braces_in_flow_control_structures
        for (var modifer in item.modifiers!) {
          printFormat.add(PrintFormat(PrintFormatType.menuModifier, [kitchen == true ? modifer.displayKitchen! : modifer.display!, modifer.price.toString(), modifer.qty.toString()]));
        }

      if (item.sub_menu_item != null)
        for (var item in item.sub_menu_item!) {
          printFormat.add(PrintFormat(PrintFormatType.twoColumns, [item.menu_item!.receiptName!, item.qty.toString()]));

          if (item.modifiers != null)
            for (var modifer in item.modifiers!) {
              printFormat.add(PrintFormat(PrintFormatType.menuModifier, [modifer.recieptName!, modifer.price.toString(), modifer.qty.toString()]));
            }
        }
    }
    printFormat.add(PrintFormat(PrintFormatType.line, ["-"]));

    return printFormat;
  }

  List<PrintFormat> printOrderHeader(OrderHeader order, {bool kitchen = false}) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    Preference? preference = locator.get<ConnectionRepository>().preference;

    if (kitchen) printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("Kitchen")]));
    if (preference!.hideOrderNoInPrinting != null && preference.hideOrderNoInPrinting!) {
      if (order.service != null) {
        if (order.service!.alternative != null || order.service!.alternative != "") {
          printFormat.add(PrintFormat(
            PrintFormatType.twoColumns,
            [appLocalizations.translate("Reference No.") + order.ticket_number.toString(), order.service!.alternative!],
          ));
        } else {
          printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Reference No.") + order.ticket_number.toString(), order.service!.serviceName!]));
        }
      } else {
        printFormat.add(PrintFormat(PrintFormatType.single, [appLocalizations.translate("Reference No.") + order.ticket_number.toString()]));
      }
    } else {
      if (order.service != null) {
        if (order.service!.alternative != null && order.service!.alternative != "") {
          printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Order.") + order.id.toString(), order.service!.alternative!]));
        } else {
          printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Order.") + order.id.toString(), order.service!.serviceName != null ? order.service!.serviceName! : order.service!.name!]));
        }
      } else {
        printFormat.add(PrintFormat(PrintFormatType.single, [appLocalizations.translate("Order.") + order.id.toString()]));
      }
    }

    printFormat.add(PrintFormat(PrintFormatType.twoColumns, [appLocalizations.translate("Server") + " " + order.employee!.name, appLocalizations.translate("Terminal ") + (order.terminal_id == null ? "" : order.terminal_id.toString())]));

    printFormat.add(PrintFormat(PrintFormatType.twoColumns, [Misc.toShortDate(order.date_time!).toString(), Misc.toShortTime(order.date_time!).toString()]));

    if (order.customer != null && order.customer!.name != "" && order.customer!.name != null || (order.Label != null && order.Label != "")) {
      printFormat.add(PrintFormat(PrintFormatType.twoColumns, [(order.customer != null && order.customer!.name != "" && order.customer!.name != null) ? order.customer!.name : "", (order.Label != null && order.Label != "") ? order.Label! : ""]));
    }

    if (order.customer_contact != null && order.customer_contact != "") {
      printFormat.add(PrintFormat(PrintFormatType.single, [order.customer_contact!]));
    }

    if (order.customer_address != null && order.customer_address != "") {
      printFormat.add(PrintFormat(PrintFormatType.single, [order.customer_address!]));
      printFormat.add(PrintFormat(PrintFormatType.line, []));
    }

    if ((order.dinein_table != null)) {
      printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("Table ") + " " + order.dinein_table!.name]));
    }
    printFormat.add(PrintFormat(PrintFormatType.line, ["-"]));

    if (kitchen) {
      if (order.status == 4) {
        printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("** Voided **")]));
      } else if ((order.transaction.where((t) => t.is_printed == true).length > 0)) {
        printFormat.add(PrintFormat(PrintFormatType.center, [appLocalizations.translate("** Additional **")]));
      }
    }
    return printFormat;
  }

  String menuModifierDrawing(double price, int qty, String name) {
    Preference? preference = locator.get<ConnectionRepository>().preference;

    String text = "";
    String _modPrice = "";
    String _modQty = "";
    if (price == null || price == 0) {
      _modPrice = "";
    } else {
      _modPrice = " (Ex " + Number.getNumber(price) + ")";
    }

    if (preference!.printModPriceOnTicket != null && !preference.printModPriceOnTicket!) {
      _modPrice = "";
    }

    if (qty > 1) {
      _modQty = qty.toString() + "X";
    }

    if (this.lang == "en")
      text += (_modQty + name + _modPrice);
    else
      text += (_modPrice + name + _modQty);
    return text;
  }

  printLine(String char) {
    String temp = "";
    for (var i = 0; i < 80; i++) {
      temp += char;
    }
    return temp;
  }

  Future<List<PrintFormat>> printOrderReceipt(OrderHeader order, {bool kitchen = false}) async {
    var printingType = terminal!.printingType;
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    if (printingType != "Template") {
      if (kitchen == true) {
        printFormat.addAll(printOrderHeader(order, kitchen: true));
        printFormat.addAll(printRecieptItems(order, kitchen: true));
      } else {
        printFormat.addAll(restaurantInfo(order));
        printFormat.addAll(printOrderHeader(order));
        printFormat.addAll(printRecieptItems(order));
        printFormat.addAll(printOrderFooter(order));
      }
    } else {
      printFormat = await fromJsonFile(order);
    }

    return printFormat;
  }

  Future<List<PrintFormat>> fromJsonFile(OrderHeader order) async {
    TemplateTypeConverter templateTypeConverter = TemplateTypeConverter();
    try {
      await loadFile();
      if (this.fileData == null) return [];
      var temp;
      TemplateFormat format = TemplateFormat();
      format.page = PageT.fromJson(this.fileData['page']);
      for (int i = 0; i < this.fileData['Body'].length; i++) {
        try {
          temp = templateTypeConverter.fromJson(this.fileData['Body'][i]);
          format.body!.add(temp);
        } catch (e) {}
      }
      Preference? preference = locator.get<ConnectionRepository>().preference;
      TemplatePrint templatePrint = TemplatePrint(order, preference!, format);
      List<PrintFormat> printFormat = templatePrint.convertToPrint();
      return printFormat;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
