import 'package:json_annotation/json_annotation.dart';

import '../menu_item.dart';
part 'menu_item_reference.g.dart';

@JsonSerializable()
class MenuItemReference {
  int id;
  String name;
  String secondary_name;
  bool order_By_Weight;
  String weight_unit;
  MenuItemReference({this.id = 0, this.name = "", this.secondary_name = "", this.order_By_Weight = false, this.weight_unit = ""});

  factory MenuItemReference.fromMenuItem(MenuItem item) {
    return MenuItemReference(
        id: item.id, name: item.name!, secondary_name: item.secondary_name!, order_By_Weight: item.order_By_Weight!, weight_unit: item.weight_unit!);
  }

  factory MenuItemReference.fromJson(Map<String, dynamic> json) => _$MenuItemReferenceFromJson(json);
}
