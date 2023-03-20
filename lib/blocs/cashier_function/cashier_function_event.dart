import 'package:invo_mobile/models/payment_method.dart';

abstract class CashierFunctionPageEvent {}

class CancelCashierFunction implements CashierFunctionPageEvent {}

class SaveCashier implements CashierFunctionPageEvent {
  List<CashReigisterCount> details;
  SaveCashier(this.details);
}

class PrintCashier implements CashierFunctionPageEvent {}

class CashReigisterCount {
  PaymentMethod? method;
  double total;

  CashReigisterCount({this.method, this.total = 0});
}
