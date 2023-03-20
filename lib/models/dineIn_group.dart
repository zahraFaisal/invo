import 'dineIn_table.dart';

class DineInGroup {
  int id;
  String name;
  List<DineInTable>? tables;
  bool in_active;
  String? position;
  int? price_id;
  bool isSelected;

  DineInGroup({this.id = 0, this.name = "", this.price_id = 0, this.tables, this.position = "", this.isSelected = false, this.in_active = false});

  factory DineInGroup.fromJson(Map<String, dynamic> json) {
    DineInGroup group =
        DineInGroup(id: json['id'] ?? 0, name: json['name'] ?? "", price_id: json['price_id'] ?? 0, position: json['position'], tables: []);

    DineInTable temp;
    List<DineInTable> tables = [];
    for (var item in json['tables']) {
      temp = DineInTable.fromJson(item);
      temp.group = group;
      tables.add(temp);
    }

    group.tables = tables;
    return group;
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'price_id': price_id,
      'in_active': in_active == true ? 1 : 0,
      'position': position,
    };
    return map;
  }

  factory DineInGroup.fromMap(Map<String, dynamic> map) {
    DineInGroup dineInGroup = DineInGroup();
    dineInGroup.id = map['id'];
    dineInGroup.name = map['name'];
    dineInGroup.price_id = map['price_id'];
    dineInGroup.in_active = map['in_active'] == 1 ? true : false;
    dineInGroup.position = map['position'];
    return dineInGroup;
  }
}
