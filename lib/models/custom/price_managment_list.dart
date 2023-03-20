class PriceManagementList {
  int id;
  String name;
  String discount;
  String surcharge;
  String price_label;
  DateTime? from_date;
  DateTime? to_date;
  int repeat;
  PriceManagementList(
      {this.id = 0, this.name = "", this.discount = "", this.surcharge = "", this.price_label = "", this.from_date, this.to_date, this.repeat = 0});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id == 0 ? null : id, 'title': name, 'discount': discount, 'surcharge': surcharge, 'price_label': price_label};
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    String repeatName = '';
    if (repeat == 0) {
      repeatName = 'Once';
    } else if (repeat == 1) {
      repeatName = 'Daily';
    } else if (repeat == 2) {
      repeatName = 'Weekly';
    } else if (repeat == 3) {
      repeatName = 'Monthly';
    } else if (repeat == 4) {
      repeatName = 'Yearly';
    }
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'title': name,
      'Discount': discount,
      'Surcharge': surcharge,
      'price_label': price_label,
      'Price': price_label,
      'from_date': (from_date == null) ? null : "/Date(" + (from_date?.millisecondsSinceEpoch).toString() + ")/",
      'to_date': (to_date == null) ? null : "/Date(" + (to_date?.millisecondsSinceEpoch).toString() + ")/",
      'Repeat': repeatName,
      'repeat': repeat,
    };
    return map;
  }

  factory PriceManagementList.fromMap(Map<String, dynamic> map) {
    PriceManagementList priceManagementList = PriceManagementList();
    priceManagementList.id = map['id'] ?? 0;
    priceManagementList.name = map['title'] ?? "";
    priceManagementList.discount = map['discount'] ?? "";
    priceManagementList.surcharge = map['surcharge'] ?? "";
    priceManagementList.price_label = map['price_label'] ?? "";
    priceManagementList.from_date = map['from_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['from_date'], isUtc: true);
    priceManagementList.to_date = map['to_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['to_date'], isUtc: true);
    priceManagementList.repeat = map['repeat'] ?? 0;
    return priceManagementList;
  }
}
