import 'package:invo_mobile/models/cashier.dart';
import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/price_label.dart';

abstract class ICustomerService {
  Future<Customer?>? get(int id);
  Future<Customer?> getByPhone(String phone);
  Future<Customer?> save(Customer customer);
  Future<List<CustomerList>?>? getAllCustomers(String _filter);
  Future<List<Customer>?>? getAll();
  Future<bool?>? saveIfNotExists(List<Customer> customers, List<PriceLabel> priceLabels);
}
