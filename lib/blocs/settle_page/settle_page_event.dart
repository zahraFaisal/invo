import 'package:invo_mobile/models/order/order_payment.dart';
import 'package:invo_mobile/models/payment_method.dart';

abstract class SettlePageEvent {}

class MethodClicked implements SettlePageEvent {
  PaymentMethod method;
  double paymentAmount;
  MethodClicked(this.method, this.paymentAmount);
}

class CancelPayment implements SettlePageEvent {
  OrderPayment payment;
  CancelPayment(this.payment);
}

class ConfirmPayment implements SettlePageEvent {
  ConfirmPayment();
}
