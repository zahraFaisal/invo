class PriceLabel {
  int? id;
  String? name;
  bool? in_active;

  PriceLabel({this.id, this.name, this.in_active}) {
    if (in_active == null) in_active = false;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'in_active': in_active == true ? 1 : 0,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'Name': name,
      'in_active': in_active,
    };
    return map;
  }

  PriceLabel.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    if (map.containsKey('Name')) {
      if (map['Name'] != map['name']) {
        name = map['Name'];
      } else {
        name = map['name'];
      }
    } else {
      name = map['name'];
    }
    in_active = (map['in_active'] == 1 || map['in_active'] == true) ? true : false;
  }
}
