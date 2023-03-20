class ModifierList {
  int id;
  String name;
  double price;

  bool isSelected = false;

  ModifierList({this.id = 0, this.name = "", this.price = 0});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'additional_price': price,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'additional_price': price,
      'price': price,
    };
    return map;
  }

  factory ModifierList.fromMap(Map<String, dynamic> map) {
    ModifierList modifierList = ModifierList();
    modifierList.id = map['id'] ?? 0;
    modifierList.name = map['name'] ?? "";
    modifierList.price = map['additional_price'] ?? 0;
    return modifierList;
  }
}
