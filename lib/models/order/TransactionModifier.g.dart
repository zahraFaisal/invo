// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransactionModifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModifier _$TransactionModifierFromJson(Map<String, dynamic> json) {
  return TransactionModifier(
      id: json['id'] as int,
      modifier: json['modifier'] == null ? null : MenuModifier.fromJson(json['modifier'] as Map<String, dynamic>),
      modifier_id: json['modifier_id'] == null ? 0 : (json['modifier_id'] as int),
      note: json['note'] as String,
      price: (json['price'] as num).toDouble(),
      isForced: json['isForced'] as bool,
      qty: (json['qty'] as num).toDouble(),
      actual_price: (json['actual_price'] as num).toDouble());
}

Map<String, dynamic> _$TransactionModifierToJson(TransactionModifier instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'modifier': instance.modifier,
    'qty': instance.qty,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  if (instance.modifier_id > 0) {
    val['modifier_id'] = instance.modifier_id;
  }

  if (instance.note != "") {
    writeNotNull('note', instance.note);
  }

  writeNotNull('actual_price', instance.actual_price);
  writeNotNull('price', instance.price);
  writeNotNull('isForced', instance.isForced);
  return val;
}
