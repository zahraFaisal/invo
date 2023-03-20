class SurchargeList {
  int id;
  String name;
  double amount;
  bool is_percentage;

  SurchargeList({this.id = 0, this.name = "", this.amount = 0, this.is_percentage = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'additional_price': amount,
      'is_percentage': is_percentage,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'amount': amount,
      'additional_price': amount,
      'is_percentage': is_percentage,
    };
    return map;
  }

  factory SurchargeList.fromMap(Map<String, dynamic> map) {
    SurchargeList surchargeList = SurchargeList();
    surchargeList.id = map['id'] ?? 0;
    surchargeList.name = map['name'] ?? "";
    surchargeList.amount = map['amount'] ?? 0;
    surchargeList.is_percentage = (map["is_percentage"] == 1) ? true : false;
    return surchargeList;
  }
}
