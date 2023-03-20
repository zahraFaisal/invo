// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerContact _$CustomerContactFromJson(Map<String, dynamic> json) {
  return CustomerContact(
      id: json['id'] as int,
      contact: json['contact'] as String,
      type: json['type'] as int)
    ..Is_Deleted = json['Is_Deleted'] as bool;
}

Map<String, dynamic> _$CustomerContactToJson(CustomerContact instance) =>
    <String, dynamic>{
      'id': instance.id == null ? 0 : instance.id,
      'contact': instance.contact,
      'type': instance.type
    };
