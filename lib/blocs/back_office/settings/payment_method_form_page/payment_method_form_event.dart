import 'package:invo_mobile/models/payment_method.dart';


abstract class PaymentMethodFormEvent {}

class SavePaymentMethod extends PaymentMethodFormEvent{
 PaymentMethod method;
  SavePaymentMethod(this.method);
} 