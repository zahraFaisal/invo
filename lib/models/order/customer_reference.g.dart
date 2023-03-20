// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerReference _$CustomerReferenceFromJson(Map<String, dynamic> json) {
  return CustomerReference(
      id_number: json['id_number'] as int, name: json['name'] as String);
}

Map<String, dynamic> _$CustomerReferenceToJson(CustomerReference instance) =>
    <String, dynamic>{'id_number': instance.id_number, 'name': instance.name};
