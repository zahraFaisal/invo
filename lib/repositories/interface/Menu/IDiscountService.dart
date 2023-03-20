import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_item.dart';

class IDiscountService {
  Future<List<DiscountList>>? getActiveList() {}
  Future<List<DiscountList>>? getList() {}
  Future<Discount?>? get(int id) {}
  void save(Discount discount) {}
  void delete(int id) {}

  checkIfNameExists(Discount discount) {}
  Future<bool>? saveIfNotExists(List<Discount> discounts, List<Role> roles, List<MenuItem> menuItems) {}

  getAll() {}
}
