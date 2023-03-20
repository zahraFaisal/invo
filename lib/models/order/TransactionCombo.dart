// ignore_for_file: non_constant_identifier_names

import 'package:invo_mobile/models/order/menu_modifier_reference.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

import '../menu_item.dart';
import 'TransactionModifier.dart';
import '../menu_modifier.dart';

part 'TransactionCombo.g.dart';

@JsonSerializable()
class TransactionCombo {
  int id;
  double price;
  double qty;
  String note;
  int menu_item_id;
  MenuItem? menu_item;
  List<TransactionModifier>? modifiers;

  TransactionCombo({this.id = 0, this.price = 0, this.qty = 0, this.note = "", this.menu_item_id = 0, this.menu_item, this.modifiers}) {
    modifiers = List<TransactionModifier>.empty(growable: true);
  }

  Map<String, dynamic> toJson() => _$TransactionComboToJson(this);

  bool addModifer(MenuModifier modifier, bool isForced) {
    TransactionModifier? transactionModifier;
    if (id == 0) {
      modifiers ??= [];
      transactionModifier = modifiers!.firstWhereOrNull((f) => f.modifier != null && f.modifier!.id == modifier.id);

      if (transactionModifier != null) {
        //modifier already exist
      } else {
        //add only if modifier is not exist before
        modifiers!.add(TransactionModifier(modifier: modifier, qty: 1, isForced: isForced, price: modifier.additional_price == null ? 0 : modifier.additional_price));
        return true;
      }
    }
    return false;
  }

  factory TransactionCombo.fromJson(Map<String, dynamic> json) => _$TransactionComboFromJson(json);
}
