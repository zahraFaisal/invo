// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAddress _$CustomerAddressFromJson(Map<String, dynamic> json) {
  return CustomerAddress(
      id: json['id'] as int,
      address_line1: json['address_line1'] as String,
      address_line2: json['address_line2'] as String,
      is_default: json['is_default'] as bool)
    ..Is_Deleted = json['Is_Deleted'] as bool;
}

Map<String, dynamic> _$CustomerAddressToJson(CustomerAddress instance) =>
    <String, dynamic>{
      'id': instance.id == null ? 0 : instance.id,
      'address_line1': instance.address_line1,
      'address_line2': instance.address_line2,
      'is_default': instance.is_default,
      'Is_Deleted': instance.Is_Deleted
    };
