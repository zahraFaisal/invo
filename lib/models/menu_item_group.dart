import 'package:invo_mobile/models/menu_item.dart';

class MenuItemGroup {
  int id;
  int menu_group_id;
  int menu_item_id;
  int index;
  bool double_height;
  bool double_width;
  MenuItem? menu_item;
  DateTime? update_time;

  MenuItemGroup(
      {this.id = 0,
      this.menu_group_id = 0,
      this.menu_item_id = 0,
      this.index = 0,
      this.double_height = false,
      this.double_width = false,
      this.menu_item});

  factory MenuItemGroup.fromJson(Map<String, dynamic> json) {
    return MenuItemGroup(
      id: json['id'] ?? 0,
      menu_group_id: json['menu_group_id'] ?? 0,
      menu_item_id: json['menu_item_id'] ?? 0,
      index: json['index'] ?? 0,
      double_height: (json['double_height'] == null) ? false : json['double_height'],
      double_width: (json['double_width'] == null) ? false : json['double_width'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'menu_group_id': menu_group_id,
      'menu_item_id': menu_item_id,
      'index': index != null ? index : 0,
      'double_height': double_height == true ? 1 : 0,
      'double_width': double_width == true ? 1 : 0,
      'update_time': (update_time == null) ? null : update_time!.toUtc().millisecondsSinceEpoch
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    Map<String, dynamic>? _menu_item = this.menu_item != null ? this.menu_item!.toMapRequest() : null;
    var map = <String, dynamic>{
      'id': id,
      'menu_group_id': menu_group_id,
      'menu_item_id': menu_item_id,
      'index': index,
      'double_height': double_height,
      'double_width': double_width,
      'menu_item': _menu_item,
      'update_time': (update_time == null) ? null : update_time!.toUtc().millisecondsSinceEpoch
    };
    return map;
  }

  factory MenuItemGroup.fromMap(Map<String, dynamic> map) {
    MenuItemGroup menuItemGroup = MenuItemGroup();
    MenuItem _menu_item = MenuItem();
    if (map.containsKey('menu_item') && map['menu_item'] != null) {
      _menu_item = MenuItem.fromMap(map['menu_item']);
    }
    menuItemGroup.id = map['id'] ?? 0;
    menuItemGroup.menu_group_id = map['menu_group_id'] ?? 0;
    menuItemGroup.menu_item_id = map['menu_item_id'] ?? 0;
    menuItemGroup.index = map['index'];
    menuItemGroup.double_height = (map['double_height'] == 1 || map['double_height'] == true) ? true : false;
    menuItemGroup.double_width = (map['double_width'] == 1 || map['double_width'] == true) ? true : false;
    menuItemGroup.menu_item = _menu_item;
    menuItemGroup.update_time = ((map['update_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['update_time']) : null);
    return menuItemGroup;
  }
}
