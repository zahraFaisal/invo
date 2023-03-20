class DiscountList {
  int id;
  String name;
  double amount;
  bool is_percentage;
  DiscountList({this.id = 0, this.name = "", this.amount = 0, this.is_percentage = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'amount': amount,
      'is_percentage': is_percentage == null ? false : is_percentage,
    };
    return map;
  }

  factory DiscountList.fromMap(Map<String, dynamic> map) {
    DiscountList discountList = DiscountList();
    discountList.id = map['id'] ?? 0;
    discountList.name = map['name'] ?? "";
    discountList.amount = map['amount'] ?? 0;
    discountList.is_percentage = map['is_percentage'] == null ? false : ((map['is_percentage'] == 1 || map['is_percentage'] == true) ? true : false);
    return discountList;
  }
}
