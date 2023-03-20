class PaymentMethodList {
  int id;
  String name;
  String symbol;

  PaymentMethodList({this.id = 0, this.name = "", this.symbol = ""});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'symbol': symbol,
    };
    return map;
  }

  factory PaymentMethodList.fromMap(Map<String, dynamic> map) {
    PaymentMethodList paymentMethodList = PaymentMethodList();
    paymentMethodList.id = map['id'] ?? 0;
    paymentMethodList.name = map['name'] ?? "";
    paymentMethodList.symbol = map['symbol'] ?? "\$";
    return paymentMethodList;
  }
}
