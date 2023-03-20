import 'package:json_annotation/json_annotation.dart';
part 'customer_contact.g.dart';

@JsonSerializable()
class CustomerContact {
  int id;
  String contact;
  int type;
  int customer_id_number;
  bool Is_Deleted;

  CustomerContact({this.id = 0, this.contact = "", this.type = 0, this.customer_id_number = 0, this.Is_Deleted = false});
  factory CustomerContact.fromJson(Map<String, dynamic> json) {
    return CustomerContact(
      id: json['id'] ?? 0,
      contact: json['contact'] ?? "",
      type: json['type'] ?? 0,
      customer_id_number: json['customer_id_number'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$CustomerContactToJson(this);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'contact': contact,
      'type': type,
      'customer_id_number': customer_id_number,
    };
    return map;
  }

  factory CustomerContact.fromMap(Map<String, dynamic> map) {
    CustomerContact customerContact = CustomerContact();
    customerContact.id = map['id'] ?? 0;
    customerContact.contact = map['contact'];
    customerContact.type = map['type'];
    customerContact.customer_id_number = map['customer_id_number'];
    return customerContact;
  }

  String get typeText {
    switch (type) {
      case 1:
        return "Phone";
        break;
      case 2:
        return "Mobile";
        break;
      case 3:
        return "Fax";
        break;
      case 4:
        return "Email";
        break;
      default:
        return "Phone";
    }
  }
}
