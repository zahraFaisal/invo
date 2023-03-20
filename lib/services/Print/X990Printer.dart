// ignore: file_names
import 'dart:convert';
import 'package:android_plugin/android_plugin_method_channel.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/order/TransactionCombo.dart';
import 'package:invo_mobile/models/order/TransactionModifier.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/services/Print/Category/OrderPrint.dart';
import 'package:invo_mobile/services/Print/PrintFormat.dart';
import 'package:oktoast/oktoast.dart';
import '../../models/terminal.dart';
import '../../repositories/connection_repository.dart';
import '../../service_locator.dart';

class X990Printer {
  late OrderPrint orderPrint = OrderPrint();
  late String printingType;
  X990Printer() {
    Terminal? terminal = locator.get<ConnectionRepository>().terminal;
    printingType = terminal!.printingType;
  }

  printOrder(List<PrintFormat> printFormat) {
    if (printingType == "Drawing") {
      drawWithFormat(printFormat);
    } else {
      printWithFormat(printFormat);
    }
  }

  drawWithFormat(List<PrintFormat> list) {}

  printWithFormat(List<PrintFormat> list) {
    List<String> printData = [];
    for (var element in list) {
      switch (element.type) {
        case PrintFormatType.center:
          printData.add(centerText(element.data[0]));
          break;
        case PrintFormatType.twoColumns:
          printData.add(sideText(element.data[0], element.data[1]));
          break;
        case PrintFormatType.menuItem:
          printData.add(menuItem(element.data[0], element.data[1], element.data[2]));
          break;
        case PrintFormatType.discount:
          printData.add(discountText(element.data[0]));
          break;
        case PrintFormatType.doubleHeight:
          printData.add(doubleHeight);
          break;
        case PrintFormatType.single:
          printData.add(element.data[0]);
          break;
        case PrintFormatType.line:
          if (element.data.isNotEmpty) {
            printData.add(printLine("-"));
          } else {
            printData.add("\n");
          }
          break;
        case PrintFormatType.twoColumnsTextCustomSize:
          printData.add(sideTextCustomSize(element.data[0], element.data[1], leftWidth: 26));
          break;
        case PrintFormatType.menuModifier:
          printData.add("".padRight(5) + orderPrint.menuModifierDrawing(element.data[1] == null || element.data[1] == 'null' ? 0.0 : double.parse(element.data[1]), double.parse(element.data[2]).toInt(), element.data[0]));
          break;
        case PrintFormatType.voided:
          printData.add(voidedMenuItem(element.data[0]));
          break;
        case PrintFormatType.total:
          printData.add(sideText(element.data[0], element.data[1]));
          break;
        default:
      }
    }
    debugPrint(printData.join("\n"));
    printRcpt(printData);
  }

  printRcpt(List<String> printData) async {
    MethodChannelAndroidPlugin methodChannelCrediMaxEcr = MethodChannelAndroidPlugin();

    try {
      // String? res = await methodChannelCrediMaxEcr.isConnected();
      // if (res != null) {
      //   debugPrint("isConnected" + res);

      // }
      String? res2 = await methodChannelCrediMaxEcr.printRcpt(printData);
      if (res2 != null) {
        debugPrint("printed: " + res2);
        showToast("Print status: " + res2, duration: Duration(seconds: 10), backgroundColor: Colors.red, radius: 5, textStyle: TextStyle(color: Colors.white, fontSize: 22), position: ToastPosition(align: Alignment.topCenter, offset: -10));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  centerText(String value) {
    int padLeft = (16 - (value.length / 2)).toInt();
    return value.padLeft(padLeft + value.length, " ");
  }

  printLine(String char) {
    String temp = "";
    for (var i = 0; i < 32; i++) {
      temp += char;
    }
    return temp;
  }

  drawLine(String char) {
    String temp = "";
    for (var i = 0; i < 60; i++) {
      temp += char;
    }
    return temp;
  }

  String menuItem(String qty, String name, String price) {
    String text = "";

    if (name.length > 20) {
      name = name.substring(0, 19);
    }
    text += qty.padRight(4);
    text += name.padRight(20);
    text += price.padLeft(8);

    return text;
  }

  String voidedMenuItem(String text) {
    if (text.length > 27) {
      text = text.substring(0, 27);
    }
    return text.padLeft(4);

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

    text += "".padRight(6);
    text += (_modQty + modifer.recieptName! + _modPrice).padRight(24);

    return text;
  }

  String subMenuItem(TransactionCombo item) {
    String text = "";
    String _qty = "";
    if (item.qty > 1) {
      _qty = item.qty.toString();
    }

    text += "".padRight(6);
    text += (_qty + " " + item.menu_item!.receiptName!).padRight(24);

    return text;
  }

  String discountText(String text) {
    String text = "";

    text += "".padRight(8);
    text += text.padRight(22);

    return text;
  }

  String sideText(String left, String right, {bool doubleWidth = false}) {
    String text = "";

    text += left.padRight((doubleWidth) ? 8 : 16);
    //debugPrint("0000000000000000");
    if (left.length <= 16) {
      text += right.padLeft((doubleWidth) ? 8 : 16);
    } else {
      text += right.padLeft((doubleWidth) ? 8 : 16 - (left.length - 16));
    }
    //debugPrint(right.padLeft(7));
    return text;
  }

  String sideTextCustomSize(String left, String right, {int leftWidth = 0, int rightWidth = 0}) {
    if (leftWidth == 0) {
      leftWidth = 16;
    }

    if (rightWidth == 0) {
      rightWidth = 32 - leftWidth;
    }

    String text = "";
    text += left.padRight(leftWidth);
    text += right.padLeft(rightWidth);
    return text;
  }

  String threeColumn(String text1, String text2, text3, {bool doubleWidth = false}) {
    String text = "";

    // 32
    text += text1.padRight((doubleWidth) ? 6 : 11);
    text += text2.padRight((doubleWidth) ? 6 : 11);
    text += text3.padLeft((doubleWidth) ? 5 : 10);

    return text;
  }

  String customthreeColumn(String text1, String text2, text3, {bool doubleWidth = false}) {
    String text = "";

    // 32
    text += text1.padRight((doubleWidth) ? 4 : 9);
    text += text2.padRight((doubleWidth) ? 7 : 12);
    text += text3.padLeft((doubleWidth) ? 6 : 10);

    return text;
  }

  String fourColumn(String text1, String text2, text3, String text4, {bool doubleWidth = false}) {
    String text = "";

    // 32
    text += text1.padRight((doubleWidth) ? 4 : 8);
    text += text2.padRight((doubleWidth) ? 4 : 8);
    text += text3.padLeft((doubleWidth) ? 4 : 8);
    text += text4.padLeft((doubleWidth) ? 4 : 8);

    return text;
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
}
