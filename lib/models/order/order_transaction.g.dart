// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderTransaction _$OrderTransactionFromJson(Map<String, dynamic> json) {
  return OrderTransaction(
      id: json['id'] ?? 0,
      grand_price: (json['grand_price'] as num).toDouble(),
      employee_id: json['employee_id'] as int,
      item_price: (json['item_price'] as num).toDouble(),
      menu_item: json['menu_item'] == null ? null : MenuItem.fromJson(json['menu_item'] as Map<String, dynamic>),
      menu_item_id: json['menu_item_id'] as int,
      modifiers: (json['modifiers'] as List).map((e) => e == null ? TransactionModifier() : TransactionModifier.fromJsonString(e)).toList(),
      GUID: json['GUID'] as String,
      apply_tax1: json['apply_tax1'] as bool,
      apply_tax2: json['apply_tax2'] as bool,
      apply_tax3: json['apply_tax3'] as bool,
      discountable: json['discountable'] as bool,
      discount_id: json['discount_id'] as int,
      discount: json['discount'] == null ? null : DiscountReference.fromJson(json['discount'] as Map<String, dynamic>),
      discount_amount: (json['discount_amount'] as num).toDouble(),
      discount_percentage: json['discount_percentage'] as bool,
      discount_actual_price: (json['discount_actual_price'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
      status: json['status'] as int,
      sub_menu_item:
          (json['sub_menu_item'] as List).map((e) => e == null ? TransactionCombo() : TransactionCombo.fromJson(e as Map<String, dynamic>)).toList())
    ..tax1 = (json['tax1'] as num).toDouble()
    ..tax2 = (json['tax2'] as num).toDouble()
    ..tax3 = (json['tax3'] as num).toDouble()
    ..tax2_tax1 = json['tax2_tax1'] as bool
    ..tax1_amount = (json['tax1_amount'] as num).toDouble()
    ..tax2_amount = (json['tax2_amount'] as num).toDouble()
    ..tax3_amount = (json['tax3_amount'] as num).toDouble();
}

Map<String, dynamic> _$OrderTransactionToJson(OrderTransaction instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'employee_id': instance.employee_id,
    'menu_item_id': instance.menu_item_id,
    'menu_item': instance.menu_item,
    'qty': instance.qty,
    'item_price': instance.item_price,
    'status': instance.status,
    'grand_price': instance.grand_price,
    'GUID': instance.GUID,
    'discountable': instance.discountable == null ? false : instance.discountable,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  void writeNotDefault(String key, dynamic value) {
    if (value is double || value is int) {
      if (value != 0) {
        val[key] = value;
      }
    } else if (value is bool) {
      if (value != false) {
        val[key] = value;
      }
    } else if (value is List) {
      if (value != null && value.length > 0) {
        val[key] = value;
      }
    }
  }

  writeNotNull('discount_id', instance.discount_id);
  writeNotNull('discount', instance.discount);
  writeNotDefault('discount_percentage', instance.discount_percentage);
  writeNotDefault('discount_amount', instance.discount_amount);
  writeNotDefault('discount_actual_price', instance.discount_actual_price);
  writeNotDefault('apply_tax1', instance.apply_tax1);
  writeNotDefault('apply_tax2', instance.apply_tax2);
  writeNotDefault('apply_tax3', instance.apply_tax3);
  writeNotDefault('tax1', instance.tax1);
  writeNotDefault('tax2', instance.tax2);
  writeNotDefault('tax3', instance.tax3);
  writeNotDefault('tax2_tax1', instance.tax2_tax1);
  writeNotDefault('tax1_amount', instance.tax1_amount);
  writeNotDefault('tax2_amount', instance.tax2_amount);
  writeNotDefault('tax3_amount', instance.tax3_amount);
  writeNotDefault('modifiers', instance.modifiers);
  writeNotDefault('sub_menu_item', instance.sub_menu_item);

  writeNotNull('Void_reason', instance.Void_reason);
  writeNotNull('EmployeeVoid_id', instance.EmployeeVoid_id);
  writeNotDefault('Waste', instance.Waste);
  writeNotDefault('Just_Voided', instance.Just_Voided);
  writeNotNull('is_printed', instance.is_printed);
  if (instance.hold_time != null) {
    writeNotNull(
        'hold_time', "/Date(" + (instance.hold_time!.millisecondsSinceEpoch + new DateTime.now().timeZoneOffset.inMilliseconds).toString() + ")/");
  } else {
    writeNotNull('hold_time', null);
  }

  return val;
}
