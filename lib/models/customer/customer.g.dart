// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  List<CustomerContact> _contacts = List<CustomerContact>.empty(growable: true);
  List<CustomerAddress> _addresses = List<CustomerAddress>.empty(growable: true);
  if (json['contacts'] != null) {
    for (var item in json['contacts']) {
      _contacts.add(CustomerContact.fromMap(item));
    }
  }

  if (json['addresses'] != null) {
    for (var item in json['addresses']) {
      _addresses.add(CustomerAddress.fromMap(item));
    }
  }

  return Customer(
      id_number: json['id_number'] as int, name: json['name'] as String, note: json['note'] as String, contacts: _contacts, addresses: _addresses);
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id_number': instance.id_number == null ? 0 : instance.id_number,
      'name': instance.name,
      'note': instance.note,
      'contacts': instance.contacts,
      'addresses': instance.addresses
    };
