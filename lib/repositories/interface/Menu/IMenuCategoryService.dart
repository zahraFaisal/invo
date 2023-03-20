import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_category.dart';

class IMenuCategoryService {
  Future<List<MenuCategoryList>>? getActiveList() {}
  Future<List<MenuCategoryList>>? getList() {}
  Future<MenuCategory>? get(int id) {}

  Future<List<MenuItemList>>? getCetegoriesItems(int id) {}
  Future<List<MenuCategory>>? getAllMenuCategories() {}
  Future<bool>? saveIfNotExists(List<MenuCategory> menuCategories) {}
  void save(MenuCategory menuCategory, List<MenuItemList> items) {}
  void delete(int id) {}

  checkIfNameExists(MenuCategory category) {}
}
