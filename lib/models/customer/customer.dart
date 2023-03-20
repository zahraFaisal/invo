import 'dart:convert';

import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:json_annotation/json_annotation.dart';
part 'customer.g.dart';

@JsonSerializable()
class Customer {
  int id_number;
  String name;
  String note;
  int? price_id;
  List<CustomerContact> contacts;
  List<CustomerAddress> addresses;

  List<CustomerContact> get activeContacts {
    return contacts.where((f) => f.Is_Deleted == false).toList();
  }

  List<CustomerAddress> get activeAddresses {
    return addresses.where((f) => f.Is_Deleted == false).toList();
  }

  Customer({
    this.id_number = 0,
    this.name = "",
    this.note = "",
    this.price_id,
    required this.contacts,
    required this.addresses,
  }) {
    // if (this.contacts == null) this.contacts = List<CustomerContact>.empty(growable: true);
    // if (this.addresses == null) this.addresses = List<CustomerAddress>.empty(growable: true);
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    List<CustomerContact> _contacts = List<CustomerContact>.empty(growable: true);
    List<CustomerAddress> _addresses = List<CustomerAddress>.empty(growable: true);

    for (var item in json['contacts']) {
      _contacts.add(CustomerContact.fromJson(item));
    }

    for (var item in json['addresses']) {
      _addresses.add(CustomerAddress.fromJson(item));
    }

    return Customer(
        id_number: json['id_number'] ?? 0,
        name: json['name'] ?? "",
        note: json['note'] ?? "",
        price_id: json['price_id'],
        contacts: _contacts,
        addresses: _addresses);
  }

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_number': id_number == 0 ? null : id_number,
      'name': name,
      'note': note,
      'price_id': price_id,
      'in_active': 0,
      'allow_credit': 0,
      'credit_limits': 0,
      'discount': 0,
    };
    return map;
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    List<CustomerContact> _contacts = List<CustomerContact>.empty(growable: true);
    List<CustomerAddress> _addresses = List<CustomerAddress>.empty(growable: true);
    if (map['contacts'] != null) {
      for (var item in map['contacts']) {
        _contacts.add(CustomerContact.fromMap(item));
      }
    }

    if (map['addresses'] != null) {
      for (var item in map['addresses']) {
        _addresses.add(CustomerAddress.fromMap(item));
      }
    }

    Customer customer = Customer(
        id_number: map['id_number'] ?? 0,
        name: map['name'],
        note: map['note'] ?? "",
        price_id: map['price_id'],
        contacts: _contacts,
        addresses: _addresses);
    return customer;
  }

  void set id_number_(int id) {
    this.id_number = id;
  }

  int get id_number_ {
    if (this.id_number != null)
      return this.id_number;
    else
      return 0;
  }
}
