import 'dart:convert';

import 'package:invo_mobile/services/Print/Category/Template/Barcode.dart';
import 'package:invo_mobile/services/Print/Category/Template/CenterTextBox.dart';
import 'package:invo_mobile/services/Print/Category/Template/EInvoice.dart';
import 'package:invo_mobile/services/Print/Category/Template/IElement.dart';
import 'package:invo_mobile/services/Print/Category/Template/LeftTextBox.dart';
import 'package:invo_mobile/services/Print/Category/Template/Line.dart';
import 'package:invo_mobile/services/Print/Category/Template/Logo.dart';
import 'package:invo_mobile/services/Print/Category/Template/QRCode.dart';
import 'package:invo_mobile/services/Print/Category/Template/SideTextBox.dart';
import 'package:invo_mobile/services/Print/Category/Template/Table.dart';
import 'package:invo_mobile/services/Print/Category/Template/TextBox.dart';
import 'package:json_annotation/json_annotation.dart';

class TemplateTypeConverter extends JsonConverter {
  @override
  fromJson(json) {
    var typeValue = json['Type'];
    IElement model;
    switch (typeValue) {
      case "Logo":
        model = new Logo();
        break;
      case "Barcode":
        model = new Barcode();
        break;
      case "TextBox":
        model = new TextBox();
        break;
      case "Table":
        model = new Table();
        break;
      case "Line":
        model = new Line();
        break;
      case "CenterTextBox":
        model = new CenterTextBox();
        break;
      case "SideTextBox":
        model = new SideTextBox();
        break;
      case "LeftTextBox":
        model = new LeftTextBox();
        break;
      case "EInvoice":
        model = new EInvoice();
        break;
      case "QR":
        model = new QR();
        break;
      default:
        model = new Line();
        break;
    }

    try {
      model.fromJson(json);
    } catch (ex) {
      print(ex.toString());
    }

    return model;
  }

  @override
  toJson(object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
