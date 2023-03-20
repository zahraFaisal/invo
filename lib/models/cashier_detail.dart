class CashierDetail {
  int id;
  int cashier_id;
  int payment_method_id;
  double rate;
  double start_amount;
  double end_amount;

  CashierDetail({
    this.id = 0,
    this.cashier_id = 0,
    this.payment_method_id = 0,
    this.rate = 0,
    this.end_amount = 0,
    this.start_amount = 0,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'id': id == null ? 0 : id,
      'cashier_id': cashier_id,
      'start_amount': start_amount == null ? 0 : start_amount,
      'end_amount': end_amount == null ? 0 : end_amount,
      'payment_method_id': payment_method_id,
      'rate': rate,
    };
    return map;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'cashier_id': cashier_id,
      'start_amount': start_amount,
      'end_amount': end_amount,
      'payment_method_id': payment_method_id,
      'rate': rate,
    };
    return map;
  }

  factory CashierDetail.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      CashierDetail cashierDetail = CashierDetail(
        id: map['id'],
      );
      cashierDetail.cashier_id = map['cashier_id'];
      cashierDetail.start_amount = map['start_amount'];
      cashierDetail.end_amount = map['end_amount'];
      cashierDetail.rate = map['rate'];
      cashierDetail.payment_method_id = map['payment_method_id'];
      return cashierDetail;
    } else {
      throw ArgumentError('Data is null');
    }
  }

  factory CashierDetail.fromJson(Map<String, dynamic> json) {
    return CashierDetail(
      id: json['id'] ?? 0,
      cashier_id: json['cashier_id'] ?? 0,
      start_amount: double.parse(json['start_amount'] == null ? "0" : json['start_amount'].toString()),
      end_amount: double.parse(json['end_amount'] == null ? "0" : json['end_amount'].toString()),
      rate: double.parse(json['rate'] == null ? "0" : json['rate'].toString()),
      payment_method_id: json['payment_method_id'] ?? 0,
    );
  }
}
