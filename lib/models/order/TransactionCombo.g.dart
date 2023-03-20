// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransactionCombo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCombo _$TransactionComboFromJson(Map<String, dynamic> json) {
  return TransactionCombo(
      id: json['id'] as int,
      price: json['price'] == null ? 0 : (json['price'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
      note: json['note'] ?? "",
      menu_item_id: json['menu_item_id'] as int,
      menu_item: json['menu_item'] == null ? null : MenuItem.fromJson(json['menu_item'] as Map<String, dynamic>),
      modifiers: (json['modifiers'] as List).map((e) => e == null ? TransactionModifier() : TransactionModifier.fromJsonString(e)).toList());
}

Map<String, dynamic> _$TransactionComboToJson(TransactionCombo instance) {
  final val = <String, dynamic>{'id': instance.id, 'qty': instance.qty, 'menu_item_id': instance.menu_item_id, 'menu_item': instance.menu_item, 'modifiers': instance.modifiers};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('note', instance.note);
  writeNotNull('price', instance.price);
  return val;
}
