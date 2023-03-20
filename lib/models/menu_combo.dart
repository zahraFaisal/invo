import 'package:invo_mobile/models/menu_item.dart';

class MenuCombo {
  int id;
  int sub_menu_item_id;
  MenuItem? sub_menu_item;
  int parent_menu_item_id;
  int qty;
  bool Is_Deleted;

  MenuCombo({this.id = 0, this.sub_menu_item_id = 0, this.sub_menu_item, this.parent_menu_item_id = 0, this.qty = 0, this.Is_Deleted = false});

  factory MenuCombo.fromJson(Map<String, dynamic> json) {
    return MenuCombo(
        id: json['id'],
        sub_menu_item_id: json['sub_menu_item_id'],
        sub_menu_item: json['sub_menu_item'],
        parent_menu_item_id: json['parent_menu_item_id'],
        Is_Deleted: json['Is_Deleted'] == null ? false : json['Is_Deleted'],
        qty: (json['qty'] == null) ? 1 : json['qty']);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'sub_menu_item_id': sub_menu_item_id,
      'sub_menu_item': sub_menu_item,
      'parent_menu_item_id': parent_menu_item_id,
      'qty': qty,
      'Is_Deleted': Is_Deleted,
    };
    return map;
  }

  factory MenuCombo.fromMap(Map<String, dynamic> map) {
    MenuCombo menuCombo = MenuCombo();
    menuCombo.id = (map['id'] == null) ? 0 : map['id'];
    menuCombo.Is_Deleted = (map['Is_Deleted'] == null) ? false : map['Is_Deleted'];
    menuCombo.qty = (map['qty'] == null) ? 1 : map['qty'];
    menuCombo.sub_menu_item_id = map['sub_menu_item_id'] ?? 0;
    menuCombo.sub_menu_item = (map["sub_menu_item"] != null) ? MenuItem.fromMap(map["sub_menu_item"]) : new MenuItem();
    menuCombo.parent_menu_item_id = (map['parent_menu_item_id'] == null) ? 0 : map['parent_menu_item_id'];
    return menuCombo;
  }
}
