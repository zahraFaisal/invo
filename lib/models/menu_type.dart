class MenuType {
  int id;
  String name;
  int? price_id;
  bool in_active;

  DateTime? update_time;
  MenuType({this.id = 0, this.name = "", this.price_id, this.in_active = false});

  factory MenuType.fromJson(Map<String, dynamic> json) {
    return MenuType(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price_id: json['price_id'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id == 0 ? null : id, 'name': name, 'price_id': price_id, 'in_active': in_active == true ? 1 : 0, 'update_time': (update_time == null) ? null : update_time!.toUtc().millisecondsSinceEpoch};
    return map;
  }

  factory MenuType.fromMap(Map<String, dynamic> map) {
    MenuType menuType = MenuType();
    menuType.id = map['id'];
    menuType.name = map['name'];
    menuType.price_id = map['price_id'];
    menuType.in_active = map['in_active'] == 1 ? true : false;
    menuType.update_time = ((map['update_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['update_time']) : null);
    return menuType;
  }
}
