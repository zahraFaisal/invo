class Surcharge {
  int? id;
  String name;
  bool in_active;
  double amount;
  bool apply_tax1;
  bool apply_tax2;
  bool apply_tax3;
  bool is_percentage;
  String? description;

  Surcharge({this.id, this.name = "", this.amount = 0, this.in_active = false, this.is_percentage = false, this.description = "", this.apply_tax1 = false, this.apply_tax2 = false, this.apply_tax3 = false});
  factory Surcharge.fromJson(Map<String, dynamic> json) {
    return Surcharge(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      amount: double.parse(json['amount'].toString()),
      in_active: json.containsKey('in_active') ? json['in_active'] : false,
      is_percentage: json.containsKey('is_percentage') ? json['is_percentage'] : false,
      apply_tax1: json.containsKey('apply_tax1') ? json['apply_tax1'] : false,
      apply_tax2: json.containsKey('apply_tax2') ? json['apply_tax2'] : false,
      apply_tax3: json.containsKey('apply_tax3') ? json['apply_tax3'] : false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'amount': amount,
        'is_percentage': is_percentage,
        'apply_tax1': apply_tax1,
        'apply_tax2': apply_tax2,
        'apply_tax3': apply_tax3,
      };

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'amount': amount,
      'is_percentage': is_percentage == true ? 1 : 0,
      'description': description,
      'in_active': in_active == true ? 1 : 0,
      'apply_tax1': apply_tax1 == true ? 1 : 0,
      'apply_tax2': apply_tax2 == true ? 1 : 0,
      'apply_tax3': apply_tax3 == true ? 1 : 0,
    };
    return map;
  }

  factory Surcharge.fromMap(Map<String, dynamic> map) {
    Surcharge surcharge = Surcharge();
    surcharge.id = map['id'] ?? 0;
    surcharge.name = map['name'] ?? "";
    surcharge.amount = map['amount'] == null ? 0 : double.parse(map["amount"].toString());
    surcharge.description = map["description"];
    surcharge.is_percentage = (map["is_percentage"] == 1 || map["is_percentage"] == "true") ? true : false;
    surcharge.in_active = (map["in_active"] == 1 || map["in_active"] == true) ? true : false;
    surcharge.apply_tax1 = (map["apply_tax1"] == 1) ? true : false;
    surcharge.apply_tax2 = (map["apply_tax2"] == 1) ? true : false;
    surcharge.apply_tax3 = (map['apply_tax3'] == 1) ? true : false;
    return surcharge;
  }
}
