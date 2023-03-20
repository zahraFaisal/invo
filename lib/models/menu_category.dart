import 'dart:convert';

class MenuCategory {
  int id;
  String name;
  int index;
  bool in_active = false;
  int department_id;

  MenuCategory({this.id = 0, this.name = "", this.index = 0, this.in_active = false, this.department_id = 0}) {}

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      ' name': name,
      'index': index,
      'in_active': in_active == true ? 1 : 0,
      'department_id ': department_id,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'index': index,
      'in_active': in_active == true ? 1 : 0,
      'department_id ': department_id,
    };
    return map;
  }

  factory MenuCategory.fromMap(Map<String, dynamic> map) {
    MenuCategory menuCategory = MenuCategory();
    menuCategory.id = map['id'] ?? 0;
    menuCategory.name = map['name'] ?? "";
    menuCategory.index = map['index'] == null ? 0 : map['index'];
    menuCategory.in_active = (map['in_active'] == 1 || map['in_active'] == true) ? true : false;
    menuCategory.department_id = map['department_id'] ?? 0;
    return menuCategory;
  }
}
