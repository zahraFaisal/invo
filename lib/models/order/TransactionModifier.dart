import 'package:invo_mobile/models/preference.dart';
import 'package:json_annotation/json_annotation.dart';

import '../menu_modifier.dart';
import 'menu_modifier_reference.dart';

part 'TransactionModifier.g.dart';

@JsonSerializable()
class TransactionModifier {
  int id;
  int transaction_id;
  int modifier_id;

  MenuModifier? modifier = null;
  String note = "";
  double qty;
  double actual_price = 0;
  double price = 0;
  bool isForced = false;
  String? _display;

  TransactionModifier({this.id = 0, this.modifier, this.note = "", this.price = 0, this.isForced = false, this.qty = 1, this.actual_price = 0, this.modifier_id = 0, this.transaction_id = 0});

  factory TransactionModifier.fromJsonString(json) {
    return TransactionModifier(
        id: json['id'],
        modifier: json['modifier'] == null ? null : MenuModifier.fromJson(json['modifier'] as Map<String, dynamic>),
        note: json['note'] ?? "",
        price: json['price'] != null ? (json['price'] as num).toDouble() : 0,
        isForced: json['isForced'] ?? false,
        qty: json['qty'] != null ? (json['qty'] as num).toDouble() : 0,
        actual_price: json['actual_price'] != null ? (json['actual_price'] as num).toDouble() : 0);
  }

  Map<String, dynamic> toJson() => _$TransactionModifierToJson(this);

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    map['modifier'] = modifier;
    var _actual_price = calculateTotalPrice(map['qty']);
    map['actual_price'] = _actual_price;
    return map[key];
  }

  factory TransactionModifier.fromMap(Map<String, dynamic> map) {
    TransactionModifier transactionModifier = TransactionModifier();
    MenuModifier _modifier = MenuModifier();
    if (map['display_name'] != null) {
      _modifier = new MenuModifier.fromMap(map);
    }
    transactionModifier.id = map['id'];
    transactionModifier.note = map['note'];
    transactionModifier.price = map['price'];
    transactionModifier.isForced = map['is_forced'] == 1 ? true : false;
    transactionModifier.qty = map['qty'];
    transactionModifier.modifier_id = map['modifier_id'];
    transactionModifier.transaction_id = map['transaction_id'];
    transactionModifier.modifier = _modifier;
    transactionModifier.actual_price = map['price'];
    return transactionModifier;
  }

  Map<String, dynamic> toMap() {
    final val = <String, dynamic>{'note': note, 'price': price, 'qty': qty, 'is_forced': isForced, 'modifier_id': modifier_id, 'transaction_id': transaction_id};
    return val;
  }

  double calculateTotalPrice(double _qty) {
    actual_price = _qty * qty * ((price == null) ? 0 : price);
    return actual_price;
  }

  String? get display {
    if (modifier == null) {
      return note;
    } else {
      return modifier!.display;
    }
  }

  String? get displayKitchen {
    if (modifier == null) {
      return note;
    } else {
      return modifier!.kitchenName;
    }
  }

  set display(String? name) {
    _display = name;
  }

  String? get recieptName {
    if (modifier == null) {
      return note;
    } else {
      return modifier!.receiptName;
    }
  }
}
