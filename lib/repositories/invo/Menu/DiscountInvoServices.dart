import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/interface/Menu/IDiscountService.dart';

class DiscountInvoService implements IDiscountService {
  @override
  checkIfNameExists(Discount discount) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<Discount> discounts, List<Role> roles, List<MenuItem> menuItems) {
    throw UnimplementedError();
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }

  @override
  Future<Discount?>? get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<DiscountList>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<DiscountList>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(Discount discount) {
    // TODO: implement save
  }
}
