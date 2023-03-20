import 'package:invo_mobile/models/employee.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_reference.g.dart';

@JsonSerializable()
class EmployeeReference {
  int id;
  String name;

  EmployeeReference({required this.id, required this.name});

  factory EmployeeReference.fromJson(Map<String, dynamic> json) {
    return EmployeeReference(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id == 0 ? null : id, 'name': name};
    return map;
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    return map[key];
  }

  factory EmployeeReference.fromEmployee(Employee employee) {
    return EmployeeReference(id: employee.id, name: employee.name);
  }

  Map<String, dynamic> toJson() => _$EmployeeReferenceToJson(this);
}
