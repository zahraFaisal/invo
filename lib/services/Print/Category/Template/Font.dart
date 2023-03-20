import 'dart:convert';
import 'dart:core';

class TemplateStyle {
  String? familyName;
  String? fontSize;
  String? fontStyle;
  String? paddingLeft;
  TemplateStyle({this.familyName, this.fontSize, this.fontStyle, this.paddingLeft});

  factory TemplateStyle.fromJson(Map<String, dynamic> json) {
    return TemplateStyle(
      familyName: json['familyName'],
      fontSize: json['fontSize'].toString(),
      fontStyle: json['fontStyle'],
      paddingLeft: json['paddingLeft'].toString(),
    );
  }

  getPaddingLeft() {
    if (paddingLeft == null || paddingLeft == "") {
      return 0;
    } else {
      return double.parse(paddingLeft!);
    }
  }

  getFamilyName() {
    if (familyName == null || familyName == "") {
      return "Arial Narrow";
    } else {
      return familyName;
    }
  }

  getFontSize() {
    if (fontSize == null || fontSize == "") {
      return 11;
    } else {
      return double.parse(fontSize!);
    }
  }

  getFontStyle() {
    if (fontStyle == null || fontStyle == "") {
      return 0;
    } else {
      switch (fontStyle) {
        case "Regular":
          return 0;
        case "Bold":
          return 1;
        case "Italic":
          return 2;
        case "Underline":
          return 4;
        case "Strikeout":
          return 8;
        default:
          return 0;
          break;
      }
    }
  }
}
