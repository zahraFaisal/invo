import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/models/menu_type.dart';

class IMenuTypeService {
  Future<List<MenuType>>? getActiveList() {}
  Future<List<MenuType>>? getList() {}
  Future<MenuType>? get(int id) {}

  void save(MenuType menuType) {}
  void delete(MenuType menuType) {}
  Future<List<MenuType>?>? getUpdatedMenuType(DateTime? lastUpdateTime) {}
  Future<bool>? saveIfNotExists(List<MenuType> menuTypes) {}
  UpdateMenuTypeNullUpdateTime() {}
  checkIfNameExists(MenuType menu) {}
}
