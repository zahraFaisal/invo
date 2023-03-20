import 'package:invo_mobile/models/payment_method.dart';

abstract class PaymentMethodListEvent {}

class LoadPaymentMethod extends PaymentMethodListEvent {}

class DeletePaymentMethod extends PaymentMethodListEvent {
 
  PaymentMethod method;
  DeletePaymentMethod(this.method);
}

