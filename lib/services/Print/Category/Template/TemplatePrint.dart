import 'dart:convert';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/services/Print/Category/Template/Line.dart';
import 'package:invo_mobile/services/Print/Category/Template/Logo.dart';
import 'package:invo_mobile/services/Print/Category/Template/SideTextBox.dart';
import 'package:invo_mobile/services/Print/Category/Template/Table.dart';
import 'package:invo_mobile/services/Print/Category/Template/TableRow.dart';
import 'package:invo_mobile/services/Print/Category/Template/TemplateFormat.dart';
import 'package:invo_mobile/services/Print/Category/Template/TextConverter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:invo_mobile/models/Number.dart';
import '../../PrintFormat.dart';
import 'CenterTextBox.dart';
import 'package:flutter/material.dart' as mi;

class TemplatePrint {
  //  Preference preference ;
  OrderHeader order;
  Preference preference;
  TemplateFormat format;

  TemplatePrint(this.order, this.preference, this.format);

  dynamic getProp(String key) => <String, dynamic>{
        'order': order,
        'preference': preference,
      }[key];

  getValue(String value, dynamic scope, {bool parseInt = false}) {
    try {
      if (value.startsWith("!")) {
        List<String> list;
        String x = value.substring(1);
        list = x.split('.');

        dynamic _obj = scope.getProp(list[0]);

        for (int i = 1; i < list.length; i++) {
          if (_obj == null) {
            return '';
          }
          _obj = _obj.getProp(list[i]);
        }

        if (_obj == null) {
          // return value;
          return '';
        }

        if (parseInt && _obj is double) {
          _obj = _obj.toInt();
        }
        return _obj.toString();
      } else {
        return value;
      }
    } catch (ex) {
      return value;
    }
  }

  getSource(String value, dynamic scope) {
    try {
      List<String> list;
      String x = value.substring(1);
      list = x.split('.');

      dynamic _obj = scope.getProp(list[0]);

      for (int i = 1; i < list.length; i++) {
        _obj = _obj.getProp(list[i]);
      }
      return _obj;
    } catch (ex) {
      return "";
    }
  }

  getValueConverter(TextConverter text, dynamic scope) {
    String value = text.value;
    if (value.startsWith("!")) {
      List<String> list;
      String x = value.substring(1, value.length);
      list = x.split('.');

      dynamic _obj = scope.getProp(list[0]);

      for (int i = 1; i < list.length; i++) {
        if (_obj == null) {
          return "";
        }
        _obj = _obj.getProp(list[i]);
      }

      if (_obj == null) {
        return "";
        // return "";
      }

      return ConvertText(_obj, text.converter);
    } else {
      return ConvertText(value, text.converter);
    }
  }

  ConvertText(Object value, String converter) {
    if (value == null || value.toString() == "") return "";
    switch (converter) {
      case "Date.ToLongDate":
        return (DateTime(value as int)); //need the format
      case "Date.ToShortDate":
        return (DateTime(value as int)); //need the format
      case "Date.ToShortTime":
        return (DateTime(value as int)); //need the format
      case "String.Trim":
        return value.toString().trim();
      case "Number":
        return Number.getNumber(value as double);
      case "Currency":
        return Number.formatCurrency(value as double);
      default:
        return value.toString();
    }
  }

  getValueText(List<dynamic> values, dynamic source) {
    String value = "";
    for (var item in values) {
      if (item is Map) {
        TextConverter converter = TextConverter.fromJson(item as Map<String, dynamic>);
        value += getValueConverter(converter, source);
      } else if (item is String) {
        value += getValue(item.toString(), source);
      }
    }
    return value;
  }

  List<PrintFormat> convertToPrint() {
    String value;
    dynamic element;
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    mi.TextStyle defaultStyle = mi.TextStyle(color: mi.Colors.black, fontSize: (double.parse(format.page!.defaultStyle!.fontSize!) * 2.5), fontWeight: mi.FontWeight.bold);
    for (var i = 0; i < format.body!.length; i++) {
      try {
        element = format.body![i];
        if (element.hidden != null) {
          value = getValue(element.hidden.property, this, parseInt: true);
          if (value == null || value == "" || value == element.hidden.value) {
            continue;
          }
        }

        if (element.visible != null) {
          value = getValue(element.visible.property, this);
          if (value != null && value != "" && value != element.visible.value) {
            continue;
          }
        }
        mi.TextStyle textStyle;
        if (element.style != null) {
          print(element.style);
          textStyle = mi.TextStyle(color: mi.Colors.black, fontSize: (double.parse(element.style.fontSize) * 2.5), fontWeight: mi.FontWeight.bold);
        } else {
          textStyle = defaultStyle;
        }
        if (element.type == "CenterTextBox") {
          printFormat.addAll(printCenterText(element, textStyle));
        } else if (element.type == "SideTextBox") {
          printFormat.addAll(printSideText(element, textStyle));
        } else if (element.type == "Table") {
          printFormat.addAll(printTableText(element, textStyle));
        } else if (element.type == "Line") {
          printFormat.addAll(printLineText(element));
        } else if (element.type == "Logo") {
          printFormat.addAll(printLogo(element));
        }
      } catch (e) {}
    }

    return printFormat;
  }

  List<PrintFormat> printCenterText(CenterTextBox element, mi.TextStyle textStyle) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    String value = getValueText(element.value!, this);
    printFormat.add(PrintFormat(PrintFormatType.center, [value], textStyle: textStyle));
    return printFormat;
  }

  List<PrintFormat> printTableText(Table element, mi.TextStyle textStyle) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    List<String> _values = [];
    var size = 3;
    if (element.columns != null) {
      size = element.columns!.length;
      for (var item in element.columns!) {
        _values.add(item.headerValue.toString());
      }
    }

    //Note : change to print format columns with custom width
    printFormat.add(PrintFormat(_values.length == 3 ? PrintFormatType.menuItem : PrintFormatType.twoColumns, _values, textStyle: textStyle));

    Object _obj = getSource(element.source!, this);

    var temp = "";
    String value;
    printFormat.addAll(printRows(_obj, element.rows!, textStyle));
    // if (_obj is List) {
    //   for (var _item in _obj) {
    //     for (var row in element.rows) {
    //       if (row.hidden != null) {
    //         value = getValue(row.hidden.property, _item, parseInt: true);
    //         if (value == null ||
    //             value == "" ||
    //             value.toString() == row.hidden.value.toString()) {
    //           continue;
    //         }
    //       }

    //       if (row.visible != null) {
    //         value = getValue(row.visible.property, _item, parseInt: true);
    //         if (value != null &&
    //             value != "" &&
    //             value.toString() != row.visible.value.toString()) {
    //           continue;
    //         }
    //       }

    //       _values = [];
    //       if (row.cells != null)
    //         for (var cell in row.cells) {
    //           value = getValueText(cell.value, _item);
    //           _values.add(value);
    //         }

    //       printFormat.add(PrintFormat(
    //           size == 3 ? PrintFormatType.menuItem : PrintFormatType.twoColumns,
    //           _values));
    //     }
    //   }
    // } else {
    //   //no source available
    // }
    return printFormat;
  }

  List<PrintFormat> printRows(dynamic _obj, List<TableRow> rows, mi.TextStyle textStyle) {
    String value;
    List<String> _values = [];
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);

    if (_obj is List) {
      for (var _item in _obj) {
        for (var row in rows) {
          if (row.hidden != null) {
            value = getValue(row.hidden!.property, _item, parseInt: true);
            if (value == null || value == "" || value.toString() == row.hidden!.value.toString()) {
              continue;
            }
          }

          if (row.visible != null) {
            value = getValue(row.visible!.property, _item, parseInt: true);
            if (value != null && value != "" && value.toString() != row.visible!.value.toString()) {
              continue;
            }
          }

          if (row.rows != null && row.rows!.length > 0) {
            printFormat.addAll(printRows(getSource(row.source!, _item), row.rows!, textStyle));
          } else if (row.cells != null) {
            _values = [];
            for (var cell in row.cells!) {
              value = getValueText(cell.value!, _item);
              _values.add(value);
            }
            if (!isEmptyValues(_values)) printFormat.add(PrintFormat(_values.length == 3 ? PrintFormatType.menuItem : PrintFormatType.twoColumns, _values, textStyle: textStyle));
          }
        }
      }
    } else {
      //no source available
    }
    return printFormat;
  }

  bool isEmptyValues(List<String> _values) {
    bool flag = true;
    for (var item in _values) {
      if (item.isNotEmpty) {
        flag = false;
        break;
      }
    }
    return flag;
  }

  List<PrintFormat> printSideText(SideTextBox element, mi.TextStyle textStyle) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    String leftValue = getValueText(element.leftValue!, this);
    String rightValue = getValueText(element.rightValue!, this);
    printFormat.add(PrintFormat(PrintFormatType.twoColumns, [leftValue, rightValue], textStyle: textStyle));
    return printFormat;
  }

  List<PrintFormat> printLogo(Logo element) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    String value = "";
    for (var item in element.value!) {
      if (item is String) {
        value = getValue(item.toString(), this);
      } else {
        print(item);
      }
    }
    printFormat.add(PrintFormat(PrintFormatType.logo, [value]));
    return printFormat;
  }

  List<PrintFormat> printLineText(Line element) {
    List<PrintFormat> printFormat = List<PrintFormat>.empty(growable: true);
    String value = "";

    printFormat.add(PrintFormat(PrintFormatType.line, [value]));
    return printFormat;
  }
}
