import 'Selection.dart';

class MenuSelection {
  int id;
  int menu_item_id;
  int level;
  int no_of_selection;
  List<Selection>? Selections;

  MenuSelection({this.id = 0, this.level = 0, this.menu_item_id = 0, this.no_of_selection = 0, this.Selections});

  factory MenuSelection.fromJson(Map<String, dynamic> json) {
    List<Selection> _selections = List<Selection>.empty(growable: true);
    for (var item in json['Selections']) {
      _selections.add(Selection.fromJson(item));
    }

    return MenuSelection(
        id: json['id'] ?? 0,
        level: json['level'] ?? 0,
        menu_item_id: json['menu_item_id'] ?? 0,
        no_of_selection: json['no_of_selection'] ?? 0,
        Selections: _selections);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'level': level,
      'menu_item_id': menu_item_id,
      'no_of_selection': no_of_selection,
    };
    return map;
  }

  factory MenuSelection.fromMap(Map<String, dynamic> map) {
    MenuSelection menuSelection = MenuSelection();
    int NoOfSelection;
    if (map['no_of_selection'] == null) {
      NoOfSelection = 1;
    } else {
      NoOfSelection = (map['no_of_selection'] is num) ? map['no_of_selection'] * 1 : int.parse(map['no_of_selection']);
    }

    menuSelection.id = map['id'] == null ? 0 : map['id'];
    menuSelection.level = map['level'];
    menuSelection.menu_item_id = map['menu_item_id'];
    menuSelection.no_of_selection = NoOfSelection;
    return menuSelection;
  }
}
