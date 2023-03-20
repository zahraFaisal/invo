import 'package:invo_mobile/models/payment_method.dart';

abstract class PaymentMethodLoadState {}

class PaymentMethodIsLoading extends PaymentMethodLoadState {}

class PaymentMethodIsLoaded extends PaymentMethodLoadState {
  final PaymentMethod method;
  PaymentMethodIsLoaded(this.method);
}
