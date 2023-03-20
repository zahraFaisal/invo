import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dineIn_table_reference.g.dart';

@JsonSerializable()
class DineInTableReference {
  int id;
  String name;

  DineInTableReference({this.id = 0, this.name = ""});

  factory DineInTableReference.fromJson(Map<String, dynamic> json) {
    return DineInTableReference(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => _$DineInTableReferenceToJson(this);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id == 0 ? null : id, 'name': name};
    return map;
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    return map[key];
  }

  factory DineInTableReference.fromTable(DineInTable table) {
    return DineInTableReference(id: table.id, name: table.name);
  }
}
