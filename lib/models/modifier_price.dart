import 'dart:convert';

import 'package:invo_mobile/models/price_label.dart';

class ModifierPrice {
  int id;
  int item_id;
  PriceLabel? label;
  int? label_id;
  int menu_modifier_id;
  double? price;
  String name;
  double default_price;

  ModifierPrice(
      {this.id = 0,
      this.label,
      this.label_id = 0,
      this.menu_modifier_id = 0,
      this.price = 0,
      this.default_price = 0,
      this.name = "",
      this.item_id = 0}) {}

  String get priceTxt {
    if (price == null) return "";
    return price.toString();
  }

  set priceTxt(String? value) {
    if (value == null)
      price = null;
    else {
      double? x = double.tryParse(value);
      price = x;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic>? _label = this.label != null ? this.label!.toMap() : null;
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'label_id': label_id,
      'menu_item_id': menu_modifier_id,
      'price': price,
      'label': {'id': _label!['id'], 'Name': _label['name'], 'in_active': _label['in_active']}
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    Map<String, dynamic>? _label = this.label != null ? this.label!.toMap() : null;
    var map = <String, dynamic>{
      'id': id,
      'label_id': label_id,
      'menu_item_id': menu_modifier_id,
      'price': price,
      'default_price': default_price,
      'name': name,
      'item_id': item_id,
      'label': _label
    };
    return map;
  }

  factory ModifierPrice.fromMap(Map<String, dynamic> map) {
    ModifierPrice modifierPrice = ModifierPrice();
    modifierPrice.id = (map['id'] != null) ? map['id'] : 0;
    modifierPrice.item_id = map['item_id'] == null ? 0 : map['item_id'];
    modifierPrice.label_id = (map['label'] != null) ? map['label']['id'] : 0;
    modifierPrice.price = map['price'] == null ? 0.0 : double.parse(map['price'].toString());
    modifierPrice.name = map['name'];
    modifierPrice.label = PriceLabel.fromMap(map);
    modifierPrice.default_price = (map['default_price'] == null) ? 0.0 : double.parse(map['default_price'].toString());
    return modifierPrice;
  }
}
