class RoleList {
  int id;
  String name;
  bool isSelected;

  RoleList({this.id = 0, this.name = "", this.isSelected = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'id_number': id,
      'name': name,
    };
    return map;
  }

  factory RoleList.fromMap(Map<String, dynamic> map) {
    RoleList roleList = RoleList();
    roleList.id = map['id'] ?? 0;
    roleList.name = map['name'] ?? "";
    return roleList;
  }
}
