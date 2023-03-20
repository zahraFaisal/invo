import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'custom/menu_item_list.dart';
import 'menu_item.dart';

class Discount {
  int id;
  String name;
  double amount;
  DateTime? start_date;
  DateTime? end_date;
  String? description;
  bool in_active;
  bool is_percentage;
  List<Role>? Roles;
  List<DiscountItem>? items = [];
  double? min_price;

  List<DiscountItem> get activeItems {
    return items!.where((f) => f.isDeleted == false).toList();
  }

  Discount(
      {this.id = 0,
      required this.name,
      this.amount = 0,
      this.start_date,
      this.end_date,
      this.description,
      this.in_active = false,
      this.is_percentage = false,
      this.min_price,
      this.Roles,
      required this.items}) {
    if (amount == null) amount = 0;
    if (min_price == null) min_price = 0;
    if (is_percentage == null) is_percentage = false;
    if (Roles == null) Roles = [];
    if (items == null) items = [];
  }

  factory Discount.fromJson(Map<String, dynamic> json) {
    List<Role> _roles = [];
    if (json.containsKey('Roles'))
      // ignore: curly_braces_in_flow_control_structures
      for (var item in json['Roles']) {
        _roles.add(Role.fromJson(item));
      }

    List<DiscountItem> _items = [];
    if (json.containsKey('items'))
      // ignore: curly_braces_in_flow_control_structures
      for (var item in json['items']) {
        _items.add(DiscountItem.fromJson(item));
      }

    DateTime? _startDateTime;
    if (json['start_date'] != null && !json['start_date'].contains("NaN")) {
      if (json.containsKey('start_date')) {
        if (json['start_date'].contains("+")) {
          _startDateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(json['start_date'].substring(6, json['start_date'].length - 7)), isUtc: true);
        } else {
          _startDateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(json['start_date'].substring(6, json['start_date'].length - 2)), isUtc: true);
        }
      }
    }

    DateTime? _endDateTime;
    if (json['end_date'] != null) {
      if (json.containsKey('end_date')) {
        if (json['end_date'].contains("+")) {
          _endDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['end_date'].substring(6, json['end_date'].length - 7)), isUtc: true);
        } else {
          _endDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['end_date'].substring(6, json['end_date'].length - 2)), isUtc: true);
        }
      }
    } else if (json['expire_date'] != null && !json['expire_date'].contains("NaN")) {
      if (json['expire_date'].contains("+")) {
        _endDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['expire_date'].substring(6, json['expire_date'].length - 7)), isUtc: true);
      } else {
        _endDateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['expire_date'].substring(6, json['expire_date'].length - 2)), isUtc: true);
      }
    }

    return Discount(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        amount: json['amount'] == null ? 0 : double.parse(json['amount'].toString()),
        start_date: _startDateTime,
        end_date: _endDateTime,
        in_active: json.containsKey('in_active') ? json['in_active'] : false,
        is_percentage: json.containsKey('is_percentage') ? json['is_percentage'] : false,
        min_price: json['min_price'] == null ? 0 : double.parse(json['min_price'].toString()),
        Roles: _roles,
        items: _items);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'amount': amount,
      'start_date': start_date == null ? null : start_date!.toUtc().millisecondsSinceEpoch,
      'expire_date': end_date == null ? null : end_date!.toUtc().millisecondsSinceEpoch,
      'in_active': in_active == true ? 1 : 0,
      'is_percentage': is_percentage == true ? 1 : 0,
      'description': description,
      'min_price': min_price,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    List<Map<String, dynamic>>? _Roles = this.Roles != null ? this.Roles!.map((i) => i.toMapRequest()).toList() : null;
    List<Map<String, dynamic>>? _items = this.items != null ? this.items!.map((i) => i.toMap()).toList() : null;
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'start_date': (start_date == null) ? null : "/Date(" + (start_date!.millisecondsSinceEpoch).toString() + ")/",
      'expire_date': (end_date == null) ? null : "/Date(" + (end_date!.millisecondsSinceEpoch).toString() + ")/",
      'in_active': in_active,
      'is_percentage': is_percentage,
      'description': description,
      'min_price': min_price,
      'Roles': _Roles,
      'items': _items
    };
    return map;
  }

  factory Discount.fromMap(Map<String, dynamic> map) {
    List<DiscountItem> _items = List<DiscountItem>.empty(growable: true);
    if (map.containsKey('items') && map['items'] != null) {
      for (var item in map['items']) {
        _items.add(DiscountItem.fromJson(item));
      }
    }
    List<Role> _Roles = List<Role>.empty(growable: true);
    if (map.containsKey('Roles') && map['Roles'] != null) {
      for (var item in map['Roles']) {
        _Roles.add(Role.fromJson(item));
      }
    }

    Discount discount = Discount(id: map["id"] ?? 0, name: map["name"], items: map["items"]);
    discount.amount = double.parse(map['amount'] == null ? "0.0" : map['amount'].toString());
    discount.start_date = (map['start_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['start_date'], isUtc: true));
    discount.end_date = (map['expire_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['expire_date'], isUtc: true));
    discount.description = map['description'];
    discount.in_active = (map['in_active'] == 1 || map['in_active'] == true) ? true : false;
    discount.is_percentage = (map['is_percentage'] == 1 || map['is_percentage'] == true) ? true : false;
    discount.min_price = double.parse(map['min_price'] == null ? "0.0" : map['min_price'].toString());
    discount.items = _items;
    discount.Roles = _Roles;

    return discount;
  }

  void setStartDate(DateTime date) {
    start_date = date;
  }

  void setEndDate(DateTime date) {
    end_date = date;
  }
}

class DiscountItem {
  int? id;
  int? discount_id;
  int? menu_item_id;
  MenuItemList? item;
  bool? isDeleted = false;
  DiscountItem({this.id, this.discount_id, this.menu_item_id, this.item}) {
    isDeleted = false;
  }

  factory DiscountItem.fromJson(Map<String, dynamic> json) {
    return DiscountItem(id: json['id'], discount_id: json['discount_id'], menu_item_id: json['menu_item_id']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'discount_id': discount_id,
      'menu_item_id': menu_item_id,
    };
    return map;
  }

  DiscountItem.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    discount_id = map['discount_id'];
    menu_item_id = map['menu_item_id'];
    item = MenuItemList(id: menu_item_id!, name: map['menu_item_name']);
  }
}
