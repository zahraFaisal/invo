import 'package:invo_mobile/models/customer/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_reference.g.dart';

@JsonSerializable()
class CustomerReference {
  int id_number;
  String name;

  CustomerReference({this.id_number = 0, this.name = ""});

  factory CustomerReference.fromJson(Map<String, dynamic> json) {
    return CustomerReference(id_number: json['id_number'] ?? 0, name: json['name'] ?? "");
  }

  Map<String, dynamic> toJson() => _$CustomerReferenceToJson(this);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id_number': id_number == 0 ? null : id_number, 'name': name};
    return map;
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    return map[key];
  }

  factory CustomerReference.fromCustomer(Customer customer) {
    return CustomerReference(id_number: customer.id_number, name: customer.name);
  }
}
