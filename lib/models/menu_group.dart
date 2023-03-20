import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class MenuGroup {
  int id;
  String name;
  String secondary_name = "";

  int menu_type_id;
  int index;
  String backcolor;
  bool in_active;
  DateTime? update_time;

  bool isSelected;
  MenuGroup({this.id = 0, this.name = "", this.secondary_name = "", this.menu_type_id = 0, this.index = 0, this.backcolor = "#FF7732", this.in_active = false, this.isSelected = false});

  int getColorFromHex() {
    if (backcolor == null) backcolor = "#FF7732";
    String hexColor = backcolor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  factory MenuGroup.fromJson(Map<String, dynamic> json) {
    bool inActive = false;
    if (json['in_active'] != null) {
      inActive = json['in_active'];
    }

    return MenuGroup(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      secondary_name: json['secondary_name'] ?? "",
      menu_type_id: json['menu_type_id'] ?? 0,
      backcolor: json['backcolor'],
      index: json['index'] ?? 0,
      in_active: inActive,
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id == 0 ? null : id, 'name': name, 'menu_type_id': menu_type_id, 'backcolor': backcolor, 'index': index == null ? 0 : index, 'in_active': in_active == true ? 1 : 0, 'update_time': (update_time == null) ? null : update_time!.toUtc().millisecondsSinceEpoch};
    return map;
  }

  factory MenuGroup.fromMap(Map<String, dynamic> map) {
    MenuGroup menuGroup = MenuGroup();
    menuGroup.id = map['id'] ?? 0;
    menuGroup.name = map['name'];
    menuGroup.menu_type_id = int.parse(map['menu_type_id'].toString());
    menuGroup.backcolor = map['backcolor'];
    menuGroup.index = map['index'];
    menuGroup.in_active = map['in_active'] == 1 ? true : false;
    menuGroup.update_time = (map['update_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['update_time']) : null;
    return menuGroup;
  }
}
