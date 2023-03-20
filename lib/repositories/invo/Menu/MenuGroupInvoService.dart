import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuGroupService.dart';
import 'package:sqflite/sqlite_api.dart';

class MenuGroupInvoService implements IMenuGroupService {
  @override
  checkIfNameExists(MenuGroup group) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  delete(MenuGroup group) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<MenuGroup?>? get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<MenuGroup>> getActive() {
    // TODO: implement getActive
    throw UnimplementedError();
  }

  @override
  Future<List<MenuGroup>>? getAll({List<int>? except}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<MenuGroup>> getList(int menuId) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(MenuGroup surcharge) {
    // TODO: implement save
  }

  @override
  updateMenuType(List<MenuGroup> temp, int menuId) {
    // TODO: implement updateMenuType
    throw UnimplementedError();
  }

  @override
  Future<List<MenuGroup>> getUpdatedMenuGroup(DateTime? lastUpdateTime) {
    // TODO: implement getUpdatedMenuGroup
    throw UnimplementedError();
  }

  @override
  Future<bool>? saveIfNotExists(List<MenuGroup> groups) {
    throw UnimplementedError();
  }

  @override
  Future<List<MenuGroup>> getListwithUnassigned(int menuId) {
    throw UnimplementedError();
  }

  @override
  void UpdateMenuGroupNullUpdateTime() {
    // TODO: implement UpdateMenuGroupNullUpdateTime
  }
}
