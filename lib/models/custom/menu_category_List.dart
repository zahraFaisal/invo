class MenuCategoryList {
  int id;
  String name;
  double price;

  MenuCategoryList({this.id = 0, this.name = "", this.price = 0});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{'id': id == 0 ? null : id, 'name': name, 'price': price};
    return map;
  }

  factory MenuCategoryList.fromMap(Map<String, dynamic> map) {
    MenuCategoryList menuCategoryList = MenuCategoryList();
    menuCategoryList.id = map['id'] ?? 0;
    menuCategoryList.name = map['name'] ?? "";
    menuCategoryList.price = map['price'] ?? 0;
    return menuCategoryList;
  }
}
