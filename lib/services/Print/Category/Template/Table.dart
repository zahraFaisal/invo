import 'package:invo_mobile/services/Print/Category/Template/IElement.dart';
import 'package:invo_mobile/services/Print/Category/Template/TableColumn.dart';
import 'package:invo_mobile/services/Print/Category/Template/TableRow.dart';

class Table extends IElement {
  String? source;
  List<TableColumn>? columns;
  List<TableRow>? rows;

  fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    var temp = json;
    List<TableColumn> _columns = List<TableColumn>.empty(growable: true);
    if (json['Columns'] != null && json['Columns'].length > 0)
      // ignore: curly_braces_in_flow_control_structures
      for (int i = 0; i < json['Columns'].length; i++) {
        _columns.add(TableColumn.fromJson(json['Columns'][i]));
      }

    List<TableRow> _rows = List<TableRow>.empty(growable: true);
    if (json['Rows'] != null && json['Rows'].length > 0)
      // ignore: curly_braces_in_flow_control_structures
      for (int i = 0; i < json['Rows'].length; i++) {
        _rows.add(TableRow.fromJson(json['Rows'][i]));
      }
    source = json['Source'];
    columns = _columns;
    rows = _rows;
  }
}
