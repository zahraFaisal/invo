import 'dart:convert';

import 'modifier_price.dart';

class MenuModifier {
  int id;
  String name;
  String secondary_name;
  String? display_name;
  String? secondary_display_name;
  String? secondary_description;
  double additional_price;
  String? receipt_text;
  String? kitchen_name;
  String? description;
  bool in_active;
  bool is_visible;
  bool is_multiple = false;
  List<ModifierPrice>? prices;
  DateTime? update_time;

  bool? isSelected = false;

  getPrice() {
    return (additional_price == null) ? "0.000" : additional_price.toStringAsFixed(3);
  }

  String? get display {
    if ((display_name == null || display_name == "")) {
      return name;
    } else {
      return display_name;
    }
  }

  String? get kitchenName {
    if (kitchen_name != null && kitchen_name != "")
      return kitchen_name;
    else if (display_name != null && display_name != "")
      return display_name;
    else
      return name;
  }

  String? get receiptName {
    if (receipt_text != null && receipt_text != "")
      return receipt_text;
    else if (display_name != null && display_name != "")
      return display_name;
    else
      return name;
  }

  MenuModifier(
      {this.id = 0,
      this.name = "",
      this.secondary_name = "",
      this.display_name = "",
      this.secondary_display_name = "",
      this.description = "",
      this.secondary_description = "",
      this.additional_price = 0,
      this.receipt_text = "",
      this.kitchen_name = "",
      this.in_active = false,
      this.is_multiple = false,
      this.is_visible = false});

  factory MenuModifier.fromJson(Map<String, dynamic> json) {
    double price = json['additional_price'] == null ? 0 : double.parse(json['additional_price'].toString());
    return MenuModifier(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      secondary_name: json['secondary_name'] ?? "",
      display_name: json['display_name'] ?? "",
      secondary_display_name: json['secondary_display_name'] ?? "",
      receipt_text: json['receipt_text'] ?? "",
      kitchen_name: json['kitchen_text'] ?? "",
      additional_price: price,
      in_active: json['in_active'] ?? false,
      is_multiple: json['is_multiple'] ?? false,
      is_visible: json['is_visible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{"id": id, "name": name, "display_name": display_name, "secondary_display_name": secondary_display_name, "receipt_text": receipt_text, "kitchen_text": kitchen_name};

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    map['display'] = display;
    map['secondary_display_name'] = secondary_display_name;
    return map[key];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'secondary_name': secondary_name,
      'display_name': display_name,
      'secondary_description': secondary_description,
      'secondary_display_name': secondary_display_name,
      'receipt_text': receipt_text,
      'additional_price': additional_price,
      'kitchen_text': kitchen_name,
      'description': description,
      'in_active': in_active == true ? 1 : 0,
      'is_visible': is_visible == true ? 1 : 0,
      'is_multiple': is_multiple == true ? 1 : 0,
      'update_time': (update_time == null) ? null : update_time!.toUtc().millisecondsSinceEpoch
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    List<Map<String, dynamic>>? _prices = this.prices != null ? this.prices!.map((i) => i.toMap()).toList() : null;
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'secondary_name': secondary_name,
      'secondary_description': secondary_description,
      'secondary_display_name': secondary_display_name,
      'display_name': display_name,
      'receipt_text': receipt_text,
      'additional_price': additional_price,
      'kitchen_text': kitchen_name,
      'description': description,
      'in_active': in_active == true ? 1 : 0,
      'is_visible': is_visible == true ? 1 : 0,
      'is_multiple': is_multiple == true ? 1 : 0,
      'price': additional_price,
      'prices': _prices
    };
    return map;
  }

  factory MenuModifier.fromMap(Map<String, dynamic> map) {
    MenuModifier menuModifier = MenuModifier();
    menuModifier.id = map['id'] ?? 0;
    menuModifier.name = map['name'];
    menuModifier.secondary_name = map['secondary_name'];
    menuModifier.display_name = map['display_name'];
    menuModifier.secondary_display_name = map["secondary_display_name"];
    menuModifier.secondary_description = map["secondary_description"];
    menuModifier.receipt_text = map['receipt_text'];
    menuModifier.additional_price = map['additional_price'] == null ? 0.0 : double.parse(map['additional_price'].toString());
    menuModifier.kitchen_name = map['kitchen_text'];
    menuModifier.description = map['description'];
    menuModifier.in_active = (map['in_active'] == 1) ? true : false;
    menuModifier.is_visible = (map['is_visible'] == 1 || map['is_visible'] == true) ? true : false;
    menuModifier.is_multiple = (map['is_multiple'] == 1 || map['is_multiple'] == true) ? true : false;

    if (map['update_time'] != null) {
      if (map['update_time'] is int) {
        menuModifier.update_time = ((map['update_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['update_time']) : null)!;
      } else {
        menuModifier.update_time = DateTime.fromMillisecondsSinceEpoch(int.parse(map['update_time'].substring(6, map['update_time'].length - 7)));
      }
    }

    // update_time = DateTime.fromMillisecondsSinceEpoch(int.parse(map['update_time'].substring(6, map['update_time'].length - 7)));

    List<ModifierPrice> _prices = List<ModifierPrice>.empty(growable: true);
    if (map['prices'] != null)
      for (var item in map['prices']) {
        _prices.add(ModifierPrice.fromMap(item));
      }

    menuModifier.prices = _prices;
    return menuModifier;
  }
}
