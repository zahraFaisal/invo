import 'dart:convert';
import 'dart:core';
import 'package:invo_mobile/services/Print/Category/Template/Font.dart';

import 'Hidden.dart';
import 'Visible.dart';

class IElement {
  String? type;
  List<dynamic>? value;
  TemplateStyle? style;
  Hidden? hidden;
  Visible? visible;
  IElement({this.type, this.value, this.style, this.hidden, this.visible});

  fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    value = json['Value'];

    if (json['Style'] != null) style = TemplateStyle.fromJson(json['Style']);

    if (json['Hidden'] != null) hidden = Hidden.fromJson(json['Hidden']);

    if (json['Visible'] != null) visible = Visible.fromJson(json['Visible']);
  }
}
