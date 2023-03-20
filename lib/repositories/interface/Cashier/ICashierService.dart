import 'package:invo_mobile/models/cashier.dart';
import 'package:invo_mobile/models/custom/cashier_reference.dart';

abstract class ICashierService {
  Future<Cashier?> get(int id);
  Future<Cashier?> save(Cashier cashier);
  Future<Cashier?> getCashierReference(int empId);
  Future<Cashier?> getTerminalCashier(int terminalId);
}
