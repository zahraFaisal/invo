import 'package:invo_mobile/models/price_label.dart';
import 'dart:convert';

class MenuPrice {
  int id;
  PriceLabel? label;
  int? label_id;
  int? item_id;
  int? menu_item_id;
  double? price;
  bool in_active;
  double default_price;
  String? name;
  String? _dispaly_price;
  String? category_name;
  MenuPrice({
    this.id = 0,
    this.label,
    this.label_id = 0,
    this.menu_item_id = 0,
    this.price = 0,
    this.in_active = false,
    this.name = "",
    this.default_price = 0,
    this.category_name = "",
    this.item_id = 0,
  });

  String get priceTxt {
    if (price == null) return "";
    return price.toString();
  }

  set priceTxt(String value) {
    if (value == null) {
      price = null;
    } else {
      double? x = double.tryParse(value);
      price = x!;
    }
  }

  factory MenuPrice.fromJson(Map<String, dynamic> json) {
    return MenuPrice(
      id: json['id'] ?? 0,
      label_id: json['label_id'] ?? 0,
      menu_item_id: json['menu_item_id'] ?? 0,
      price: json.containsKey('price') ? double.parse(json['price'].toString()) : 0,
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'label_id': label_id,
      'menu_item_id': menu_item_id,
      'price': price,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'label_id': label_id,
      'menu_item_id': menu_item_id,
      'price': price,
      'name': name,
      'default_price': default_price,
      'category_name': category_name,
      'item_id': item_id,
    };
    return map;
  }

  factory MenuPrice.fromMap(Map<String, dynamic> map) {
    MenuPrice menuPrice = MenuPrice();
    menuPrice.id = (map['id'] == null) ? 0 : map['id'];
    menuPrice.item_id = map['item_id'];
    menuPrice.label_id = map['label_id'];
    menuPrice.menu_item_id = map['menu_item_id'];
    menuPrice.price = map['price'] == null ? 0.0 : double.parse(map['price'].toString());
    menuPrice.name = map['name'];
    menuPrice.default_price = map['default_price'] == null ? 0.0 : double.parse(map['default_price'].toString());
    menuPrice.category_name = map['category_name'];
    return menuPrice;
  }
  String get dispaly_price {
    if (price == null) {
      return "";
    } else if (price! < 0) {
      return "";
    } else {
      if (_dispaly_price!.isEmpty || _dispaly_price == "-1") return price.toString();
      return _dispaly_price.toString();
    }
  }
}
