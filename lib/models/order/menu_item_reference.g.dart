// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemReference _$MenuItemReferenceFromJson(Map<String, dynamic> json) {
  return MenuItemReference(
      id: json['id'] as int,
      name: json['name'] as String,
      secondary_name: json['secondary_name'] as String,
      order_By_Weight: json['order_By_Weight'] as bool,
      weight_unit: json['weight_unit'] as String);
}

Map<String, dynamic> _$MenuItemReferenceToJson(MenuItemReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'secondary_name': instance.secondary_name,
      'order_By_Weight': instance.order_By_Weight,
      'weight_unit': instance.weight_unit
    };
