import 'package:invo_mobile/models/menu_group.dart';

class IMenuGroupService {
  Future<List<MenuGroup>>? getList(int menuId) {}
  Future<List<MenuGroup>>? getAll({List<int>? except}) {}
  Future<List<MenuGroup>>? getActive() {}
  Future<List<MenuGroup>>? getListwithUnassigned(int menuId) {}

  Future<MenuGroup?>? get(int id) {}
  void save(MenuGroup surcharge) {}

  checkIfNameExists(MenuGroup group) {}

  delete(MenuGroup group) {}
  Future<List<MenuGroup>>? getUpdatedMenuGroup(DateTime? lastUpdateTime) {}
  Future<bool>? saveIfNotExists(List<MenuGroup> groups) {}
  UpdateMenuGroupNullUpdateTime() {}
  updateMenuType(List<MenuGroup> temp, int menuId) {}
}
