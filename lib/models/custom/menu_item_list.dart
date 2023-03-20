import 'package:invo_mobile/models/menu_combo.dart';

import '../Menu_popup_mod.dart';
import '../discount.dart';
import '../menu_price.dart';
import '../quick_modifier.dart';

class MenuItemList {
  int id;
  String barcode;
  String name;
  double price;
  int menu_category_id;
  String description;
  String? icon;
  bool isDeleted;
  int type;
  bool isSelected;

  MenuItemList(
      {this.id = 0,
      this.name = "",
      this.price = 0,
      this.barcode = "",
      this.menu_category_id = 0,
      this.description = "",
      this.type = 0,
      this.isDeleted = false,
      this.isSelected = false});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'default_price': price,
      'icon': icon,
      'barcode': barcode,
      'menu_category_id': menu_category_id,
      'description': description,
      'type': type
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'Name': name,
      'default_price': price,
      'barcode': barcode,
      'menu_category_id': menu_category_id,
      'description': description,
      'type': type
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'default_price': price,
      'barcode': barcode,
      'menu_category_id': menu_category_id,
      'description': description
    };
    return map;
  }

  factory MenuItemList.fromMap(Map<String, dynamic> map) {
    MenuItemList menuItemList = MenuItemList();
    menuItemList.id = map['id'] ?? 0;
    menuItemList.name = map['name'] ?? "";
    menuItemList.price = map['default_price'] == null ? 0.0 : double.parse(map['default_price'].toString());
    menuItemList.barcode = map['barcode'] ?? "";
    menuItemList.menu_category_id = map['menu_category_id'] ?? 0;
    menuItemList.icon = map['icon'];
    menuItemList.description = map['description'] ?? "";
    menuItemList.type = map['type'] ?? 0;
    menuItemList.isDeleted = map['is_deleted'] == null ? false : map['is_deleted'];
    return menuItemList;
  }
}
