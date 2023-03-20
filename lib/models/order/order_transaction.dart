import 'package:intl/intl.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/order/menu_item_reference.dart';
import 'package:invo_mobile/models/order/menu_modifier_reference.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../menu_item.dart';
import 'TransactionCombo.dart';
import 'TransactionModifier.dart';
import '../discount.dart';
import '../menu_modifier.dart';
import 'discount_reference.dart';
import 'employee_reference.dart';
import 'package:collection/collection.dart';

part 'order_transaction.g.dart';

@JsonSerializable()
class OrderTransaction {
  int id = 0;

  int? employee_id;
  int? menu_item_id;
  MenuItem? menu_item;

  double qty = 1;
  double item_price;

  int status;
  double grand_price;
  String? GUID;

  bool discountable;

  @JsonKey(includeIfNull: false)
  int? discount_id;

  @JsonKey(includeIfNull: false)
  DiscountReference? discount;

  bool discount_percentage = false;
  double discount_amount = 0;
  double discount_actual_price;

  bool apply_tax1;
  bool apply_tax2;
  bool apply_tax3;
  double tax1;
  double tax2;
  double tax3;
  double cost;
  bool tax2_tax1 = false;

  double tax1_amount = 0;
  double tax2_amount = 0;
  double tax3_amount = 0;

  late String Void_reason = "";
  int? EmployeeVoid_id;
  late bool Waste = false;
  late bool Just_Voided = false;
  bool Is_Changed = false;
  bool is_printed = false;

  int seat_number;
  DateTime? date_time;
  DateTime? hold_time;

  int? order_id;
  double? default_price;
  DateTime? prepared_date;

  List<TransactionModifier>? modifiers;
  List<TransactionCombo>? sub_menu_item;

  EmployeeReference? void_employee;

  String get qtyString {
    if (qty - qty.truncate() == 0) {
      return qty.truncate().toString();
    } else {
      return qty.toString();
    }
  }

  OrderTransaction(
      {this.id = 0,
      this.grand_price = 0,
      this.employee_id,
      this.item_price = 0,
      this.menu_item,
      this.menu_item_id,
      this.modifiers,
      this.date_time,
      this.seat_number = 1,
      this.tax2_tax1 = false,
      this.GUID,
      this.apply_tax1 = false,
      this.apply_tax2 = false,
      this.apply_tax3 = false,
      this.discountable = true,
      this.void_employee,
      this.cost = 0,
      this.default_price,
      this.discount_id,
      this.discount,
      this.discount_amount = 0,
      this.discount_percentage = false,
      this.discount_actual_price = 0,
      this.tax1 = 0,
      this.tax2 = 0,
      this.tax3 = 0,
      this.tax1_amount = 0,
      this.tax2_amount = 0,
      this.tax3_amount = 0,
      this.qty = 1,
      this.is_printed = false,
      this.hold_time,
      this.prepared_date,
      this.status = 1,
      this.sub_menu_item}) {
    if (modifiers == null) modifiers = List<TransactionModifier>.empty(growable: true);
    if (sub_menu_item == null) sub_menu_item = new List<TransactionCombo>.empty(growable: true);
  }

  factory OrderTransaction.fromJson(Map<String, dynamic> json) {
    MenuItem menuItem = MenuItem(
      id: json['menu_item']['id'] ?? 0,
      name: json['menu_item']['name'],
      secondary_name: json['menu_item']['secondary_name'],
      kitchen_text: json['menu_item']['kitchen_text'],
      order_By_Weight: json['menu_item']['order_By_Weight'],
      weight_unit: json['menu_item']['weight_unit'],
      label_services: json['menu_item']['label_services'],
    );

    DiscountReference? _discount = (json.containsKey('discount')) ? DiscountReference.fromJson(json['discount']) : null;

    EmployeeReference? _void_employee = (json.containsKey('void_employee')) ? EmployeeReference.fromJson(json['void_employee']) : null;

    List<TransactionModifier> _modifiers = List<TransactionModifier>.empty(growable: true);
    if (json.containsKey('modifiers'))
      for (var item in json['modifiers']) {
        _modifiers.add(TransactionModifier.fromJsonString(item));
      }

    List<TransactionCombo> _subMenuItem = List<TransactionCombo>.empty(growable: true);
    if (json.containsKey('sub_menu_item'))
      for (var item in json['sub_menu_item']) {
        _subMenuItem.add(TransactionCombo.fromJson(item));
      }

    DateTime? _hold_time = (json.containsKey('hold_time') && json['hold_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['hold_time'].substring(6, json['hold_time'].length - 7))) : null;

    DateTime? _prepared_date = (json.containsKey('prepared_date') && json['prepared_date'] != null) ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['prepared_date'].substring(6, json['prepared_date'].length - 7))) : null;

    DateTime? _date_time;

    if (json['date_time'].toString().contains('T') && json['date_time'] != null) {
      _date_time = DateTime.fromMillisecondsSinceEpoch(DateTime.parse(json['date_time']).millisecondsSinceEpoch);
    } else if (json['date_time'] is num) {
      _date_time = DateTime.fromMillisecondsSinceEpoch(json['date_time']);
    } else if (json['date_time'] != null) {
      _date_time = DateTime.fromMillisecondsSinceEpoch(int.parse(json['date_time'].substring(6, json['date_time'].length - 7)));
    }

    return OrderTransaction(
      id: json['id'] ?? 0,
      modifiers: _modifiers,
      void_employee: _void_employee,
      grand_price: double.parse(json.containsKey('grand_price') ? json['grand_price'].toString() : "0"),
      date_time: _date_time,
      cost: json['cost'] != null ? json['cost'] : 0,
      default_price: json['default_price'] != null ? double.parse(json['default_price'].toString()) : 0.0,
      seat_number: json['seat_number'] != null ? json['seat_number'] : 0,
      employee_id: json['employee_id'],
      item_price: double.parse(json.containsKey('item_price') ? json['item_price'].toString() : "0"),
      menu_item: menuItem,
      menu_item_id: json['menu_item_id'],
      GUID: json['GUID'],
      apply_tax1: json['apply_tax1'],
      apply_tax2: json['apply_tax2'],
      apply_tax3: json['apply_tax3'],
      tax2_tax1: json['tax2_tax1'] ?? false,
      tax1_amount: json['tax1_amount'] == null ? 0 : double.parse(json['tax1_amount'].toString()),
      tax2_amount: json['tax2_amount'] == null ? 0 : double.parse(json['tax2_amount'].toString()),
      tax3_amount: json['tax3_amount'] == null ? 0 : double.parse(json['tax3_amount'].toString()),
      discountable: json['discountable'] == null ? false : json['discountable'],
      qty: double.parse(json['qty'].toString()),
      discount: _discount,
      discount_id: int.parse(json['discount_id'] == null ? "0" : json['discount_id'].toString()),
      discount_amount: double.parse(json['discount_amount'] == null ? "0" : json['discount_amount'].toString()),
      discount_percentage: json.containsKey('discount_percentage') ? json['discount_percentage'] : false,
      discount_actual_price: double.parse(json['discount_actual_price'] == null ? "0" : json['discount_actual_price'].toString()),
      status: int.parse(json['status'].toString()),
      hold_time: _hold_time,
      is_printed: json['is_printed'] == null ? false : json['is_printed'],
      sub_menu_item: _subMenuItem,
      prepared_date: _prepared_date,
    );
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    map['qty'] = qtyString;
    map["item_sub_total"] = item_sub_total;
    map["modifiers"] = modifiers;
    return map[key];
  }

  // factory OrderTransaction.fromJson(Map<String, dynamic> json) =>
  //     _$OrderTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTransactionToJson(this);

  factory OrderTransaction.fromMap(Map<String, dynamic> json) {
    MenuItem menuItem = MenuItem(
      id: json['menu_item_id'] ?? 0,
      name: json['Item_name'],
      order_By_Weight: (json['order_By_Weight'] == 1 || json['order_By_Weight'] == true) ? true : false,
      weight_unit: json['weight_unit'],
    );

    DiscountReference? _discount;
    if (json['discount_id'] != null && json['discount_id'] != 0) {
      _discount = new DiscountReference(id: json['discount_id'], name: json['discount_name']);
    }

    EmployeeReference _employee;
    if (json['employee_id'] != null && json['employee_id'] != 0) {
      _employee = new EmployeeReference(id: json['employee_id'], name: json['employee_name']);
    }

    DateTime? _hold_time = (json.containsKey('hold_time') && json['hold_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['hold_time']) : null;

    DateTime? _date_time = (json.containsKey('date_time') && json['date_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['date_time']) : null;

    DateTime? _prepared_date = (json.containsKey('prepared_date') && json['prepared_date'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['prepared_date']) : null;

    return OrderTransaction(
        id: json['id'],
        grand_price: double.parse(json.containsKey('grand_price') ? json['grand_price'].toString() : "0"),
        employee_id: json['employee_id'],
        seat_number: json['seat_number'] ?? 1,
        cost: json['cost'] ?? 0,
        default_price: json['default_price'],
        date_time: _date_time,
        item_price: double.parse(json.containsKey('item_price') ? json['item_price'].toString() : "0"),
        menu_item: menuItem,
        menu_item_id: json['menu_item_id'],
        GUID: json['GUID'],
        apply_tax1: json['apply_tax1'] == 1 ? true : false,
        apply_tax2: json['apply_tax2'] == 1 ? true : false,
        apply_tax3: json['apply_tax3'] == 1 ? true : false,
        tax1_amount: json['tax1_amount'] == null ? 0 : double.parse(json['tax1_amount'].toString()),
        tax2_amount: json['tax2_amount'] == null ? 0 : double.parse(json['tax2_amount'].toString()),
        tax3_amount: json['tax3_amount'] == null ? 0 : double.parse(json['tax3_amount'].toString()),
        discountable: json['discountable'] == 1 ? true : false,
        qty: json['qty'] != null ? double.parse(json['qty'].toString()) : 1,
        discount: _discount,
        discount_id: int.parse(json['discount_id'] == null ? "0" : json['discount_id'].toString()),
        discount_amount: double.parse(json['discount_amount'] == null ? "0" : json['discount_amount'].toString()),
        discount_percentage: json['discount_percentage'] == 1 ? true : false,
        discount_actual_price: double.parse(json['discount_actual_price'] == null ? "0" : json['discount_actual_price'].toString()),
        status: json['status'] != null ? int.parse(json['status'].toString()) : 1,
        hold_time: _hold_time,
        is_printed: json['is_printed'] == 1 ? true : false,
        prepared_date: _prepared_date);
  }

  Map<String, dynamic> toMap() {
    int? _dateTime = (date_time == null || date_time!.toUtc().millisecondsSinceEpoch == null) ? null : date_time?.toUtc().millisecondsSinceEpoch;

    int? _prepared_date = (prepared_date == null || prepared_date!.toUtc().millisecondsSinceEpoch == null) ? null : prepared_date!.toUtc().millisecondsSinceEpoch;

    final val = <String, dynamic>{
      'menu_item': menu_item,
      'employee_id': employee_id,
      'date_time': _dateTime,
      'menu_item_id': menu_item_id,
      'qty': qty,
      'item_price': item_price,
      'status': status,
      'grand_price': grand_price,
      'GUID': GUID,
      'order_id': order_id,
      'discountable': discountable,
      'seat_number': seat_number,
      'apply_tax1': apply_tax1,
      'apply_tax2': apply_tax2,
      'apply_tax3': apply_tax3,
      'tax1_amount': tax1_amount == null ? 0 : tax1_amount,
      'tax2_amount': tax2_amount == null ? 0 : tax2_amount,
      'tax3_amount': tax3_amount == null ? 0 : tax3_amount,
      'cost': cost,
      'default_price': default_price,
      'discount_id': discount_id,
      'discount_amount': discount_amount,
      'discount_percentage': discount_percentage,
      'discount_actual_price': discount_actual_price,
      'is_printed': is_printed,
      'prepared_date': _prepared_date
    };
    return val;
  }

  factory OrderTransaction.fromItem(MenuItem item, Preference preference, double qty, double price, Employee employee) {
    OrderTransaction orderTransaction = OrderTransaction();

    orderTransaction.modifiers = List<TransactionModifier>.empty(growable: true);
    orderTransaction.sub_menu_item = List<TransactionCombo>.empty(growable: true);

    orderTransaction.date_time = DateTime.now();
    orderTransaction.GUID = Uuid().v1();
    orderTransaction.menu_item_id = item.id;
    orderTransaction.menu_item = item;
    orderTransaction.qty = qty;
    orderTransaction.item_price = price == null ? item.default_price : price;
    orderTransaction.seat_number = 0;
    orderTransaction.status = TransactionStatus.Open.index;
    orderTransaction.apply_tax1 = item.apply_tax1;
    orderTransaction.apply_tax2 = item.apply_tax2;
    orderTransaction.apply_tax3 = item.apply_tax3;
    orderTransaction.discountable = item.discountable;
    orderTransaction.tax1 = preference.tax1;
    orderTransaction.tax2 = preference.tax2;
    orderTransaction.tax3 = preference.tax3;
    orderTransaction.tax2_tax1 = preference.tax2_tax1;
    orderTransaction.employee_id = employee.id;
    orderTransaction.cost = 0;
    orderTransaction.default_price = item.default_price;
    orderTransaction.calculateTotalPrice();
    return orderTransaction;
  }

  get isNew {
    return id == 0;
  }

  double get item_sub_total {
    return (item_price * qty);
  }

  calculateTotalPrice() {
    double modPrice = 0;
    if (modifiers != null && modifiers!.length > 0) {
      for (var _mod in modifiers!) {
        modPrice += _mod.calculateTotalPrice(qty);
      }
    }

    double subitem_mod_price = 0;
    if (sub_menu_item != null && sub_menu_item!.length > 0) {
      for (var item in sub_menu_item!) {
        if (item.modifiers != null) {
          for (var modifier in item.modifiers!) {
            subitem_mod_price += modifier.calculateTotalPrice(qty * item.qty);
          }
        }
      }
    }

    double price = (item_price * qty) + modPrice + subitem_mod_price;

    if (discount_percentage) {
      discount_actual_price = -price * (discount_amount / 100);
      price += discount_actual_price;
    } else {
      discount_actual_price = -discount_amount;
      price += discount_actual_price;
    }

    if (price < 0) price = 0;

    grand_price = price;
  }

  bool increasble(MenuItem item) {
    if (id == 0 && item.id == menu_item_id && status == 1 && modifiers!.length == 0 && sub_menu_item?.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool increasble_transaction(OrderTransaction transaction) {
    if (id == 0 && transaction.menu_item_id == menu_item_id && status == TransactionStatus.Open && transaction.modifiers!.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  void increaseQty() {
    qty++;
    calculateTotalPrice();
  }

  void decreaseQty() {
    qty--;
    calculateTotalPrice();
  }

  bool addModifer(MenuModifier modifier, bool isForced) {
    TransactionModifier? transactionModifier;
    if (id == 0) {
      transactionModifier = modifiers!.firstWhereOrNull((f) => f.modifier != null && f.modifier!.id == modifier.id);

      if (transactionModifier != null) {
        if (transactionModifier.modifier != null && transactionModifier.modifier!.is_multiple) {
          transactionModifier.qty++;
          calculateTotalPrice();
          return true;
        }
      } else {
        this.modifiers!.add(TransactionModifier(modifier: modifier, modifier_id: modifier.id, qty: 1, isForced: isForced, price: modifier.additional_price == null ? 0 : modifier.additional_price));
        calculateTotalPrice();
        return true;
      }
    }
    return false;
  }

  void removeModifer(TransactionModifier temp) {
    if (id == 0) {
      this.modifiers!.remove(temp);
      calculateTotalPrice();
    }
  }

  void addShortNote(String note, String price) {
    double? _price = double.tryParse(price);
    this.modifiers!.add(TransactionModifier(modifier: null, note: note, qty: 1, isForced: false, price: _price == null ? 0 : _price));
    calculateTotalPrice();
  }

  TransactionCombo? lastSubItem() {
    if (sub_menu_item!.length > 0) {
      return sub_menu_item![sub_menu_item!.length - 1];
    } else {
      return null;
    }
  }

  void addSubItem(MenuItem menuItem) {
    this.sub_menu_item!.add(TransactionCombo(
          id: 0,
          qty: 1,
          price: menuItem.default_price,
          menu_item: menuItem,
          menu_item_id: menuItem.id,
        ));
  }

  void addDiscount(Discount _discount) {
    if (_discount.id > 0) {
      discount = DiscountReference.fromDiscount(_discount);
      discount_id = _discount.id;
      discount_amount = _discount.amount;
      discount_percentage = _discount.is_percentage;
      calculateTotalPrice();
    }
  }

  void deleteDiscount() {
    discount = null;
    discount_id = null;
    discount_amount = 0;
    discount_percentage = false;
    calculateTotalPrice();
  }

  void removeLastSub() {
    try {
      this.sub_menu_item!.removeLast();
    } catch (e) {}
  }

  void holdUntilFire() {
    if (hold_time != null && hold_time!.year == 9999) {
      fire();
    } else if (!is_printed) {
      hold_time = new DateTime(9999, 1, 1);
    }
  }

  /// <summary>
  /// fire hold until fire item
  /// </summary>
  void fire() {
    hold_time = null;
  }

  OrderTransaction clone() {
    return OrderTransaction(
        id: 0,
        grand_price: this.grand_price,
        date_time: this.date_time,
        employee_id: this.employee_id,
        item_price: this.item_price,
        menu_item: this.menu_item,
        menu_item_id: this.menu_item_id,
        modifiers: this.modifiers,
        cost: this.cost,
        default_price: this.default_price,
        discount_actual_price: this.discount_actual_price,
        discount_percentage: this.discount_percentage,
        GUID: this.GUID,
        seat_number: this.seat_number,
        apply_tax1: this.apply_tax1,
        apply_tax2: this.apply_tax2,
        apply_tax3: this.apply_tax3,
        discountable: this.discountable,
        qty: this.qty,
        status: this.status,
        sub_menu_item: this.sub_menu_item,
        is_printed: this.is_printed);
  }
}

enum TransactionStatus {
  None,
  Open,
  Void,
}
