import 'package:json_annotation/json_annotation.dart';

import '../surcharge.dart';

part 'surcharge_reference.g.dart';

@JsonSerializable()
class SurchargeReference {
  int id;
  String name;

  SurchargeReference({this.id = 0, this.name = ""});

  factory SurchargeReference.fromJson(Map<String, dynamic> json) {
    return SurchargeReference(id: json['id'] ?? 0, name: json['name'] ?? "");
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    return map[key];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
    };
    return map;
  }

  factory SurchargeReference.fromSurcharge(Surcharge surcharge) {
    return SurchargeReference(id: surcharge.id!, name: surcharge.name);
  }

  Map<String, dynamic> toJson() => _$SurchargeReferenceToJson(this);
}
