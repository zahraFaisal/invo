import 'package:flutter/material.dart';

class PrintFormat {
  late PrintFormatType type; //side , center , three colum , four column, image, line
  late List<String> data; // type = side => ["left", "right"]
  late bool bold;
  late TextStyle? textStyle;
  PrintFormat(this.type, this.data, {this.textStyle});
}

enum PrintFormatType {
  center,
  single,
  singleRight,
  logo,
  discount,
  menuItem,
  voidedMenuItem,
  menuModifier,
  fourCoulmns,
  line,
  voided,
  doubleHeight,
  cancelDoubleHeight,
  twoColumns,
  total,
  twoColumnsTextCustomSize
}
