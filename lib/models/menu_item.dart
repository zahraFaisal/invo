import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/quick_modifier.dart';

import 'Menu_popup_mod.dart';
import 'discount.dart';
import 'menu_combo.dart';
import 'menu_selection.dart';

class MenuItem {
  int id;
  String? name;
  String? secondary_name;
  String? secondary_description;
  double default_price;
  double? additional_cost;
  String? description;
  String? icon;
  String? large_icon;
  String? barcode;
  String? new_barcode;
  int? type;
  String? default_forecolor;
  String? receipt_text;
  String? kitchen_text;
  bool? in_stock;
  int preperation_time = 0;
  int countDown = 0;
  Discount? discount;
  List<MenuCombo>? menu_item_combo;
  List<MenuPopupMod>? popup_mod;
  MenuPopupMod? mod;
  List<QuickModifier>? quick_mod;
  List<MenuSelection>? selections;
  List<MenuPrice>? prices;

  int? menu_category_id;

  bool discountable = true;
  bool? in_active;
  bool apply_tax1 = false;
  bool apply_tax2 = false;
  bool apply_tax3 = false;
  bool? enable_count_down;
  bool? seasonale_price;
  bool? double_height;
  bool? double_width;

  bool? firstInGroup;
  String? heroTag;
  String? food_nutrition;

  bool? open_price;
  bool? order_By_Weight;
  String? weight_unit;
  bool isSelected = false;

  String? label_services;
  double? new_price;
  DateTime? update_time;
  String? get priceTxt {
    if (default_price == 0) {
      return "On select";
    }
    return "BD " + default_price.toStringAsFixed(3);
  }

  String? receipt_name() {
    if (this.receipt_text == null) this.receipt_text = "";

    if (this.receipt_text != "") return this.receipt_text;

    return this.name;
  }

  String? kitchen_name() {
    if (this.kitchen_text == null) this.kitchen_text = "";

    if (this.kitchen_text != "") return this.kitchen_text;

    return this.receipt_name();
  }

  String? get receiptName {
    if (receipt_text == null || receipt_text == "") {
      return name;
    } else {
      return receipt_text;
    }
  }

  String? get kitchenName {
    if (kitchen_text == null || kitchen_text == "") {
      return '';
    } else {
      return kitchen_text;
    }
  }

  Color? get color {
    if (default_forecolor == null || default_forecolor == "") {
      default_forecolor = "#FDAC2F";
    }

    if (default_forecolor!.contains("#")) {
      default_forecolor = default_forecolor!.toUpperCase().replaceAll("#", "");
      if (default_forecolor!.length == 6) {
        default_forecolor = "FF" + default_forecolor!;
      }
    }

    try {
      return Color(int.parse(default_forecolor!, radix: 16));
    } catch (e) {
      return Color(int.parse("FFFDAC2F", radix: 16));
    }
  }

  Uint8List? get imageByte {
    if (icon == null) {
      return null;
    }
    return base64.decode(icon!);
  }

  //custom function
  bool? isPopUpValid() {
    for (var item in popup_mod!) {
      if (item.is_forced == true) {
        if (item.modifiers.where((f) => f.selected == true).length != item.repeat) {
          return false;
        }
      }
    }
    return true;
  }

  void setFoodNutrition(int index, var setting) {
    if (food_nutrition == null) food_nutrition = "0;0;0;0";
    List<String> feature = food_nutrition!.split(';');
    String _setting = setting.toString().replaceAll(";", "");
    if (index > feature.length - 1) {
      List<String> arr = [];
      for (int i = 0; i <= feature.length - 1; i++) {
        arr[i] = feature[i];
      }
      feature = arr;
    }
    feature[index] = _setting;
    food_nutrition = "${feature[0].toString()};${feature[1].toString()};${feature[2].toString()};${feature[3].toString()}";
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    map['secondary_name'] = secondary_name;
    return map[key];
  }

  double get calories {
    if (food_nutrition == null || food_nutrition == "") return 0;
    return double.parse(food_nutrition!.split(";")[0]);
  }

  set calories(double value) {
    if (value == null) value = 0;
    setFoodNutrition(0, value.toString());
  }

  double get fat {
    if (food_nutrition == null || food_nutrition == "") return 0;
    return double.parse(food_nutrition!.split(";")[1]);
  }

  set fat(double value) {
    if (value == null) value = 0;
    setFoodNutrition(1, value.toString());
  }

  double get carb {
    if (food_nutrition == null || food_nutrition == "") return 0;
    return double.parse(food_nutrition!.split(";")[2]);
  }

  set carb(double value) {
    if (value == null) value = 0;
    setFoodNutrition(2, value.toString());
  }

  double get protein {
    if (food_nutrition == null || food_nutrition == "") return 0;
    return double.parse(food_nutrition!.split(";")[3]);
  }

  set protein(double value) {
    if (value == null) value = 0;
    setFoodNutrition(3, value.toString());
  }

  MenuItem(
      {this.id = 0,
      this.name,
      this.secondary_name,
      this.default_price = 0,
      this.additional_cost,
      this.description,
      this.icon,
      this.large_icon,
      this.barcode,
      this.type = 1,
      this.default_forecolor,
      this.quick_mod,
      this.receipt_text,
      this.kitchen_text,
      this.in_stock = true,
      this.preperation_time = 0,
      this.countDown = 0,
      this.menu_item_combo,
      this.popup_mod,
      this.apply_tax1 = true,
      this.apply_tax2 = true,
      this.apply_tax3 = true,
      this.enable_count_down,
      this.seasonale_price,
      this.selections,
      this.discountable = false,
      this.food_nutrition,
      this.open_price = false,
      this.order_By_Weight,
      this.discount,
      this.mod,
      this.weight_unit,
      this.in_active = false,
      this.prices,
      this.label_services,
      this.new_price,
      this.new_barcode}) {
    if (default_price == null) default_price = 0;
    if (countDown == null) countDown = 0;

    if (preperation_time == null) preperation_time = 0;
    if (in_stock == null) in_stock = true;
    if (in_active == null) in_active = false;
    if (discountable == null) discountable = false;
    if (apply_tax1 == null) apply_tax1 = false;
    if (apply_tax2 == null) apply_tax2 = false;
    if (apply_tax3 == null) apply_tax3 = false;
    if (order_By_Weight == null) order_By_Weight = false;
    if (enable_count_down == null) enable_count_down = false;
    if (seasonale_price == null) seasonale_price = false;
    if (type == null) type = 1;
    if (quick_mod == null) quick_mod = List<QuickModifier>.empty(growable: true);

    if (menu_item_combo == null) menu_item_combo = new List<MenuCombo>.empty(growable: true);
    if (popup_mod == null) popup_mod = new List<MenuPopupMod>.empty(growable: true);
    if (selections == null) selections = new List<MenuSelection>.empty(growable: true);
    if (prices == null) prices = new List<MenuPrice>.empty(growable: true);
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    var price = double.tryParse((json['default_price']).toString());
    if (price == null) {
      price = 0;
    }

    List<MenuPopupMod> popup = List<MenuPopupMod>.empty(growable: true);
    if (json.containsKey('popup_mod') && json['popup_mod'] != null) {
      for (var item in json['popup_mod']) {
        popup.add(MenuPopupMod.fromJson(item));
      }
      popup.sort((a, b) => a.level.compareTo(b.level));
    }

    List<QuickModifier> quickMod = List<QuickModifier>.empty(growable: true);
    if (json.containsKey('quick_mod') && json['quick_mod'] != null)
      for (var item in json['quick_mod']) {
        quickMod.add(QuickModifier.fromJson(item));
      }

    List<MenuSelection> _selections = List<MenuSelection>.empty(growable: true);
    if (json.containsKey('selections') && json['selections'] != null) {
      for (var item in json['selections']) {
        _selections.add(MenuSelection.fromJson(item));
      }
      _selections.sort((a, b) => a.level.compareTo(b.level));
    }

    List<MenuCombo> _combos = List<MenuCombo>.empty(growable: true);
    if (json.containsKey('menu_item_combo') && json['menu_item_combo'] != null)
      for (var item in json['menu_item_combo']) {
        _combos.add(MenuCombo.fromJson(item));
      }

    List<MenuPrice> _prices = List<MenuPrice>.empty(growable: true);
    if (json.containsKey('prices') && json['prices'] != null)
      for (var item in json['prices']) {
        _prices.add(MenuPrice.fromJson(item));
      }

    // Discount _discount = new Discount();
    // if (json.containsKey('discount') && json['discount'] != null)
    //   _discount = Discount.fromJson(json['discount']);

    return MenuItem(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        secondary_name: json['secondary_name'] ?? "",
        default_price: price,
        description: json['description'] ?? "",
        icon: json['icon'],
        large_icon: json['large_icon'],
        barcode: json['barcode'] == null ? "" : json['barcode'],
        type: json['type'] ?? 1,
        default_forecolor: json['default_forecolor'] ?? "",
        receipt_text: json['receipt_text'] ?? "",
        kitchen_text: json['kitchen_text'] ?? "",
        in_stock: json['in_stock'] ?? false,
        menu_item_combo: _combos,
        quick_mod: quickMod,
        popup_mod: popup,
        selections: _selections,
        prices: _prices,
        food_nutrition: json['food_nutrition'] ?? "",
        apply_tax1: json['apply_tax1'] ?? false,
        apply_tax2: json['apply_tax2'] ?? false,
        apply_tax3: json['apply_tax3'] ?? false,
        open_price: json['open_price'] ?? false,
        order_By_Weight: json['order_By_Weight'] ?? false,
        weight_unit: json['weight_unit'] ?? "",
        discountable: json['discountable'] ?? false,
        in_active: json['in_active'] ?? false,
        label_services: json['label_services'] ?? "");
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name, 'secondary_name': secondary_name, 'receipt_text': receipt_text, 'kitchen_text': kitchen_text, 'order_By_Weight': order_By_Weight, 'weight_unit': weight_unit, 'label_services': label_services};

  //temporary value
  double qty = 1;
  double totalPrice = 0;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'default_price': default_price,
      'secondary_name': secondary_name,
      'secondary_description': secondary_description,
      'additional_cost': additional_cost,
      'description': description,
      'barcode': barcode,
      'type': type,
      'receipt_text': receipt_text,
      'kitchen_text': kitchen_text,
      'in_stock': in_stock == null ? true : in_stock,
      'preperation_time': preperation_time == null ? 0 : preperation_time,
      'count_down': countDown == null ? 0 : countDown,
      'food_nutrition': food_nutrition,
      'apply_tax1': apply_tax1,
      'apply_tax2': apply_tax2,
      'apply_tax3': apply_tax3,
      'enable_count_down': enable_count_down,
      'seasonale_price': seasonale_price,
      'open_price': open_price,
      'order_By_Weight': order_By_Weight,
      'weight_unit': weight_unit == null ? 0 : weight_unit,
      'discountable': discountable,
      'menu_category_id': menu_category_id,
      'in_active': in_active,
      'default_forecolor': default_forecolor,
      'icon': icon,
      'update_time': (update_time == null) ? null : update_time!.toUtc().millisecondsSinceEpoch
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    List<Map<String, dynamic>>? _quick_mod = this.quick_mod != null ? this.quick_mod?.map((i) => i.toMapRequest()).toList() : null;

    List<Map<String, dynamic>>? _popup_mod = this.popup_mod != null ? this.popup_mod?.map((i) => i.toMapRequest()).toList() : null;

    List<Map<String, dynamic>>? _menu_item_combo = this.menu_item_combo != null ? this.menu_item_combo?.map((i) => i.toMap()).toList() : null;

    List<Map<String, dynamic>>? _selections = this.selections != null ? this.selections?.map((i) => i.toMap()).toList() : null;

    List<Map<String, dynamic>>? _prices = this.prices != null ? this.prices?.map((i) => i.toMapRequest()).toList() : null;

    Map<String, dynamic>? _mod = this.mod != null ? this.mod!.toMap() : null;
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'default_price': default_price,
      'secondary_description': secondary_description,
      'secondary_name': secondary_name,
      'price': default_price,
      'additional_cost': additional_cost,
      'description': description,
      'barcode': barcode,
      'type': type,
      'receipt_text': receipt_text,
      'kitchen_text': kitchen_text,
      'in_stock': in_stock == null ? true : in_stock,
      'preperation_time': preperation_time,
      'count_down': countDown,
      'food_nutrition': food_nutrition,
      'apply_tax1': apply_tax1,
      'apply_tax2': apply_tax2,
      'apply_tax3': apply_tax3,
      'enable_count_down': enable_count_down,
      'seasonale_price': seasonale_price,
      'open_price': open_price,
      'order_By_Weight': order_By_Weight,
      'weight_unit': weight_unit,
      'discountable': discountable,
      'menu_category_id': menu_category_id,
      'in_active': in_active,
      'default_forecolor': default_forecolor,
      'icon': icon,
      'quick_mod': _quick_mod,
      'popup_mod': _popup_mod,
      'menu_item_combo': _menu_item_combo,
      'selections': _selections,
      'prices': _prices,
      'mod': _mod
    };

    return map;
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    List<MenuPopupMod> popup = List<MenuPopupMod>.empty(growable: true);
    if (map.containsKey('popup_mod') && map['popup_mod'] != null) {
      for (var item in map['popup_mod']) {
        popup.add(MenuPopupMod.fromJson(item));
      }
      popup.sort((a, b) => a.level.compareTo(b.level));
    }

    MenuItem menuItem = MenuItem();
    menuItem.popup_mod = popup;

    menuItem.id = map['id'] ?? 0;
    menuItem.name = map['name'];
    menuItem.secondary_name = map['secondary_name'];
    menuItem.secondary_description = map['secondary_description'];
    menuItem.default_price = map['default_price'] != null ? double.parse(map['default_price'].toString()) : 0.0;
    menuItem.additional_cost = map['additional_cost'] != null ? double.parse(map['additional_cost'].toString()) : 0.0;
    menuItem.new_price = map['new_price'] != null ? double.parse(map['new_price'].toString()) : 0.0;

    menuItem.description = map['description'];
    menuItem.barcode = map['barcode'] == null ? "" : map['barcode'];
    menuItem.new_barcode = map['new_barcode'] == null ? "" : map['new_barcode'];
    if (map['type'] == null) {
      menuItem.type = map['type'];
    } else {
      menuItem.type = (map['type'] is num) ? map['type'] * 1 : int.parse(map['type']);
    }

    menuItem.receipt_text = map['receipt_text'];
    menuItem.kitchen_text = map['kitchen_text'];
    menuItem.in_stock = map['in_stock'] == null ? true : ((map['in_stock'] == 1 || map['in_stock'] == true) ? true : false);
    menuItem.preperation_time = map['preperation_time'] ?? 0;
    menuItem.countDown = map['count_down'] ?? 0;
    menuItem.seasonale_price = (map['seasonale_price'] == 1 || map['seasonale_price'] == true) ? true : false;

    menuItem.default_forecolor = map['default_forecolor'];
    menuItem.food_nutrition = map['food_nutrition'];
    menuItem.apply_tax1 = (map['apply_tax1'] == 1 || map['apply_tax1'] == true) ? true : false;
    menuItem.apply_tax2 = (map['apply_tax2'] == 1 || map['apply_tax2'] == true) ? true : false;
    menuItem.apply_tax3 = (map['apply_tax3'] == 1 || map['apply_tax3'] == true) ? true : false;
    menuItem.enable_count_down = (map['enable_count_down'] == 1 || map['enable_count_down'] == true) ? true : false;
    menuItem.open_price = (map['open_price'] == 1 || map['open_price'] == true) ? true : false;
    menuItem.order_By_Weight = (map['order_By_Weight'] == 1 || map['order_By_Weight'] == true) ? true : false;
    menuItem.weight_unit = map['weight_unit'];
    if (map['menu_category_id'] == null) {
      menuItem.menu_category_id = map['menu_category_id'];
    } else {
      menuItem.menu_category_id = (map['menu_category_id'] is num) ? map['menu_category_id'] * 1 : int.parse(map['menu_category_id']);
    }

    menuItem.discountable = (map['discountable'] == 1 || map['discountable'] == true) ? true : false;
    menuItem.in_active = (map['in_active'] == 1 || map['in_active'] == true) ? true : false;
    menuItem.icon = map['icon'];

    List<QuickModifier> _quick_mod = List<QuickModifier>.empty(growable: true);
    if (map['quick_mod'] != null)
      for (var item in map['quick_mod']) {
        _quick_mod.add(QuickModifier.fromMap(item));
      }

    menuItem.quick_mod = _quick_mod;

    List<MenuCombo> menu_item_combo = List<MenuCombo>.empty(growable: true);
    List<MenuSelection> selections = List<MenuSelection>.empty(growable: true);
    // List<MenuCombo> _menu_item_combo = new List<MenuCombo>();
    // if (map['menu_item_combo'] != null)
    //   for (var item in map['menu_item_combo']) {
    //     _menu_item_combo.add(MenuCombo.fromMap(item));
    //   }

    // menu_item_combo = _menu_item_combo;

    // List<MenuSelection> _selections = new List<MenuSelection>();
    // if (map['selections'] != null)
    //   for (var item in map['selections']) {
    //     _selections.add(MenuSelection.fromMap(item));
    //   }

    // selections = _selections;

    List<MenuPrice> _prices = List<MenuPrice>.empty(growable: true);
    if (map['prices'] != null)
      for (var item in map['prices']) {
        _prices.add(MenuPrice.fromMap(item));
      }

    menuItem.prices = _prices;
    menuItem.update_time = (map['update_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['update_time']) : null;
    return menuItem;
  }
}

class MenuItemIcon {
  int? menu_item_id;
  var image;
  var large_icon;
  MenuItemIcon.fromMap(Map<String, dynamic> map) {
    menu_item_id = map['id'];
    image = map['icon'];
  }
}
