import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuCategoryService.dart';
import 'package:sqflite/sqflite.dart';

class MenuCategoryInvoService implements IMenuCategoryService {
  @override
  checkIfNameExists(MenuCategory category) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }

  @override
  Future<MenuCategory> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<MenuCategoryList>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItemList>> getCetegoriesItems(int id) {
    // TODO: implement getCetegoriesItems
    throw UnimplementedError();
  }

  @override
  Future<List<MenuCategory>> getAllMenuCategories() {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<MenuCategory> menuCategories) {
    throw UnimplementedError();
  }

  @override
  Future<List<MenuCategoryList>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(MenuCategory menuCategory, List<MenuItemList> items) {
    // TODO: implement save
  }
}
