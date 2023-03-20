import 'menu_item.dart';

class Selection {
  int id;
  int menu_item_id;
  int menu_selection_id;

  MenuItem? menuItem;

  Selection({this.id = 0, this.menu_item_id = 0, this.menu_selection_id = 0, this.menuItem});

  factory Selection.fromJson(Map<String, dynamic> json) {
    return Selection(id: json['id'] ?? 0, menu_item_id: json['menu_item_id'] ?? 0, menu_selection_id: json['menu_selection_id'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      ' menu_item_id': menu_item_id,
      'menu_selection_id': menu_selection_id,
    };
    return map;
  }

  factory Selection.fromMap(Map<String, dynamic> map) {
    Selection selection = Selection();
    selection.id = map['id'];
    selection.menu_item_id = map['menu_item_id'];
    selection.menu_selection_id = map['menu_selection_id'];
    return selection;
  }
}
