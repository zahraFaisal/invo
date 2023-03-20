import 'package:invo_mobile/models/order/order_payment.dart';

class DirectSettle {
  List<OrderPayment>? payments;
  bool is_Completed;

  DirectSettle({this.payments, this.is_Completed = false}) {
    this.payments = List<OrderPayment>.empty(growable: true);
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> temp = List<Map<String, dynamic>>.empty(growable: true);

    for (var item in this.payments!) {
      temp.add(item.toJson());
    }

    var map = <String, dynamic>{
      'payments': temp,
      'Is_Completed': is_Completed,
    };
    return map;
  }
}
