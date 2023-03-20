import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuTypeService.dart';

class MenuTypeInvoService implements IMenuTypeService {
  @override
  checkIfNameExists(MenuType menu) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  void delete(MenuType menuType) {
    // TODO: implement delete
  }

  @override
  Future<MenuType> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<MenuType>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<MenuType>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(MenuType menuType) {
    // TODO: implement save
  }

  @override
  Future<List<MenuType>> getUpdatedMenuType(DateTime? lastUpdateTime) {
    // TODO: implement getUpdatedMenuType
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<MenuType> menuTypes) {
    throw UnimplementedError();
  }

  @override
  UpdateMenuTypeNullUpdateTime() {
    // TODO: implement UpdateMenuTypeNullUpdateTime
    throw UnimplementedError();
  }
}
