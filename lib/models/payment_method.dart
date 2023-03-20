class PaymentMethod {
  int id;
  String name;
  double rate;
  int type; //1 Cash, 2 Card, 3 Cheque
  int after_decimal;
  String symbol;
  PaymentSettings? settings;
  bool in_active = false;
  bool verification_required;
  bool verification_only_numerical;

  PaymentMethod({
    this.id = 0,
    this.name = "",
    this.rate = 0,
    this.type = 1,
    this.settings,
    this.after_decimal = 3,
    this.verification_required = false,
    this.verification_only_numerical = false,
    this.symbol = "",
    this.in_active = false,
  }) {
    // if (in_active == null) in_active = false;
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    PaymentSettings paymentSettings = PaymentSettings(name: "");
    if (json['settings'] != null) {
      paymentSettings = PaymentSettings.fromJson(json['settings']);
    }
    return PaymentMethod(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      symbol: json['sympol'] ?? "\$",
      verification_required: json['verification_required'] ?? false,
      verification_only_numerical: json['verification_only_numerical'] ?? false,
      rate: json['rate'] != null ? double.parse(json['rate'].toString()) : 0,
      type: json['type'] != null ? int.parse(json['type'].toString()) : 0,
      settings: paymentSettings,
      after_decimal: json['after_decimal'] != null ? int.parse(json['after_decimal'].toString()) : 0,
    );
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    return map[key];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'symbol': symbol,
      'rate': rate,
      'verification_required': verification_required == true ? 1 : 0,
      'verification_only_numerical': verification_only_numerical == true ? 1 : 0,
      'type': type,
      'after_decimal': after_decimal,
      'in_active': in_active == true ? 1 : 0
    };
    return map;
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    PaymentMethod paymentMethod = PaymentMethod(settings: PaymentSettings());
    paymentMethod.id = map['id'];
    paymentMethod.name = map['name'];
    paymentMethod.symbol = map['symbol'] ?? map['sympol'];
    paymentMethod.rate = map['rate'];
    paymentMethod.type = map['type'];
    paymentMethod.verification_required = map['verification_required'] == 1 ? true : false;
    paymentMethod.verification_only_numerical = map['verification_only_numerical'] == 1 ? true : false;
    paymentMethod.after_decimal = map['after_decimal'];
    paymentMethod.in_active = (map['in_active'] == 1) ? true : false;
    return paymentMethod;
  }
}

class PaymentSettings {
  String name = "";
  // var data;

  PaymentSettings({this.name = ""});
  factory PaymentSettings.fromJson(Map<String, dynamic> json) {
    return PaymentSettings(
      name: json['name'] ?? "",
    );
  }
}
