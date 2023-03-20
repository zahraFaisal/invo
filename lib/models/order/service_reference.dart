import 'package:invo_mobile/models/Service.dart';
import 'package:json_annotation/json_annotation.dart';

import '../menu_item.dart';
part 'service_reference.g.dart';

@JsonSerializable()
class ServiceReference {
  int id;
  String? name;
  String? alternative;

  ServiceReference({required this.id, required this.name, this.alternative = ""});

  String? get serviceName {
    if (alternative == null || alternative == "") {
      return name;
    }
    return alternative;
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    return map[key];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name, 'Service_name': name, 'alternative': alternative};
    return map;
  }

  factory ServiceReference.fromService(Service item) {
    return ServiceReference(
      id: item.id,
      name: item.name,
      alternative: item.alternative,
    );
  }

  factory ServiceReference.fromJson(Map<String, dynamic> json) {
    return ServiceReference(id: json['id'] ?? 0, name: json['name'] ?? "", alternative: json['alternative'] ?? "");
  }

  Map<String, dynamic> toJson() => _$ServiceReferenceToJson(this);
}
