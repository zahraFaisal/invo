import 'package:json_annotation/json_annotation.dart';
part 'customer_address.g.dart';

@JsonSerializable()
class CustomerAddress {
  int id;
  String address_line1;
  String address_line2;
  String? flat;
  String? building;
  String? house;
  String? road;
  String? street;
  String? block;
  String? zipCode;
  String? city;
  String? state;
  String? postalCode;
  String? additional_information;
  bool is_default = false;
  int? customer_id_number;
  bool? Is_Deleted = false;

  CustomerAddress({
    this.id = 0,
    this.address_line1 = "",
    this.address_line2 = "",
    this.customer_id_number = 0,
    this.is_default = false,
  }) {
    Is_Deleted = false;
  }

  String get fullAddress {
    String text = "";
    if (additional_information != null && additional_information != "") text = text + '  additional information: $additional_information';
    if (address_line1 != null && address_line1 != "") text = text + '  $address_line1';
    return text;
  }

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
        id: json['id'],
        address_line1: json['address_line1'] ?? "",
        address_line2: json['address_line2'] ?? "",
        is_default: (json['is_default'] == null) ? false : json['is_default']);
  }

  Map<String, dynamic> toJson() => _$CustomerAddressToJson(this);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'address_line1': address_line1,
      'address_line2': address_line2,
      'is_default': is_default,
      'customer_id_number': customer_id_number,
      'delivery_charge': 0,
      'flat': flat,
      'building': building,
      'house': house,
      'road': road,
      'street': street,
      'block': block,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'additional_information': additional_information
    };
    return map;
  }

  factory CustomerAddress.fromMap(Map<String, dynamic> map) {
    CustomerAddress customerAddress = CustomerAddress();
    customerAddress.id = map['id'] ?? 0;
    customerAddress.address_line1 = map['address_line1'] ?? "";
    customerAddress.address_line2 = map['address_line2'] ?? "";
    customerAddress.is_default = map['is_default'] == 1 ? true : false;
    customerAddress.customer_id_number = map['customer_id_number'];
    customerAddress.flat = map['flat'];
    customerAddress.building = map['building'];
    customerAddress.house = map['house'];
    customerAddress.road = map['road'];
    customerAddress.street = map['street'];
    customerAddress.block = map['block'];
    customerAddress.zipCode = map['zipCode'];
    customerAddress.city = map['city'];
    customerAddress.state = map['state'];
    customerAddress.postalCode = map['postalCode'];
    customerAddress.additional_information = map['additional_information'];
    return customerAddress;
  }

  void setVal(String item, String val) {
    if (item == 'Flat') flat = val;
    if (item == 'Building') building = val;
    if (item == 'House') house = val;
    if (item == 'Road') road = val;
    if (item == 'Street') street = val;
    if (item == 'Block') block = val;
    if (item == 'ZipCode') zipCode = val;
    if (item == 'City') city = val;
    if (item == 'State') state = val;
    if (item == 'Line1') address_line1 = val;
    if (item == 'Line2') address_line2 = val;
  }

  save() {
    List<String> list = [];
    if (flat != null) list.add("Flat:$flat");
    if (building != null) list.add("Building:$building");
    if (house != null) list.add("House:$house");
    if (road != null) list.add("Road:$road");
    if (street != null) list.add("Street:$street");
    if (block != null) list.add("Block:$block");
    if (zipCode != null) list.add("ZipCode:$zipCode");
    if (city != null) list.add("City:$city");
    if (state != null) list.add("State:$state");

    if (list.length > 0) {
      address_line1 = list.join(";");
    }
  }

  String? initalVal(String item) {
    if (address_line1 != null) {
      var addressList1 = address_line1.split(";");
      String text;
      String field;

      for (var i = 0; i < addressList1.length; i++) {
        if (addressList1[i] != "") {
          text = addressList1[i].split(':')[1];
          field = addressList1[i].split(':')[0];
          if (field.toLowerCase() == item.toLowerCase()) return text;
        }
      }
    } else
      return "";
  }

  setInitalVal() {
    if (address_line1 != null) {
      var addressList1 = address_line1.split(";");
      String text;
      String field;

      for (var i = 0; i < addressList1.length; i++) {
        if (addressList1[i] != "") {
          text = addressList1[i].split(':')[1];
          field = addressList1[i].split(':')[0];
          setVal(field, text);
        }
      }
    }
  }
}
