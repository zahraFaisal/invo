// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:invo_mobile/services/Print/Category/Template/Font.dart';
import 'package:invo_mobile/services/Print/Category/Template/Hidden.dart';
import 'package:invo_mobile/services/Print/Category/Template/TextBox.dart';
import 'package:invo_mobile/services/Print/Category/Template/Visible.dart';

class TableRow {
  String? source; //keep empty to use cells
  List<TableRow>? rows;
  List<TextBox>? cells;
  String? height;
  Visible? visible;
  Hidden? hidden;
  TemplateStyle? style;

  TableRow({this.cells, this.height, this.hidden, this.rows, this.source, this.style, this.visible});

  factory TableRow.fromJson(Map<String, dynamic> json) {
    List<TableRow> _rows = List<TableRow>.empty(growable: true);
    if (json['Rows'] != null && json['Rows'].length > 0)
      for (int i = 0; i < json['Rows'].length; i++) {
        _rows.add(TableRow.fromJson(json['Rows'][i]));
      }

    List<TextBox> _cells = List<TextBox>.empty(growable: true);
    TextBox textBox;
    if (json['Cells'] != null && json['Cells'].length > 0)
      for (int i = 0; i < json['Cells'].length; i++) {
        textBox = TextBox();
        textBox.fromJson(json['Cells'][i]);
        _cells.add(textBox);
      }

    return TableRow(
      cells: _cells,
      height: json['Heights'],
      hidden: json['Hidden'] != null ? Hidden.fromJson(json['Hidden']) : null,
      rows: _rows,
      source: json['Source'],
      style: json['Style'] != null ? TemplateStyle.fromJson(json['Style']) : null,
      visible: json['visible'] != null ? Visible.fromJson(json['visible']) : null,
    );
  }
}
