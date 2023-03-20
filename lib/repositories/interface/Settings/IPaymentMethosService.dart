import 'package:invo_mobile/models/custom/payment_method_list.dart';
import 'package:invo_mobile/models/payment_method.dart';

abstract class IPaymentMethodService {
  Future<List<PaymentMethodList>> getActiveList();
  Future<List<PaymentMethodList>> getList();
  Future<PaymentMethod> get(int id);
  Future<PaymentMethod> insertIfNotPaymentExists(int id, String name);
  Future<bool> saveIfNotExists(List<PaymentMethod> methods);
  Future<bool> save(PaymentMethod method);
  void delete(int id);
  Future<bool> checkIfNameExists(PaymentMethod method);
  Future<List<PaymentMethod>?> getAll();
  Future<bool> update(PaymentMethod method);
}
