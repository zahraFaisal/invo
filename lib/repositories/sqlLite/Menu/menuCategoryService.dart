import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuCategoryService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class MenuCategoryService implements IMenuCategoryService {
  Future<List<MenuCategoryList>> getActiveList() async {
    List<MenuCategoryList> menuCategory = List<MenuCategoryList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name from Menu_categories where  in_active = 0");
    for (var item in result) {
      menuCategory.add(MenuCategoryList.fromMap(item));
    }
    return menuCategory;
  }

  Future<List<MenuCategoryList>> getList() async {
    List<MenuCategoryList> categories = List<MenuCategoryList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name from Menu_categories");
    for (var item in result) {
      categories.add(MenuCategoryList.fromMap(item));
    }
    return categories;
  }

  Future<MenuCategory> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("Menu_categories", where: "id = ?", whereArgs: [id])).first;
    return MenuCategory.fromMap(item);
  }

  @override
  Future<List<MenuItemList>> getCetegoriesItems(int id) async {
    List<MenuItemList> items = List<MenuItemList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result =
        await database!.rawQuery("Select id,name,default_price,barcode from Menu_items where in_active=0 and menu_Category_id = ?", [id]);

    for (var item in result) {
      items.add(MenuItemList.fromMap(item));
    }
    return items;
  }

  @override
  void save(MenuCategory menuCategory, List<MenuItemList> items) async {
    final Database? database = await SqliteRepository().db;
    int categoryId;
    if (menuCategory.id == 0 || menuCategory.id == null)
      categoryId = await database!.insert('Menu_categories', menuCategory.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      categoryId = menuCategory.id;
      await database!.update('Menu_categories', menuCategory.toMap(),
          where: "id = ?", whereArgs: [menuCategory.id], conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await database.rawUpdate('UPDATE Menu_items SET menu_Category_id = NULL WHERE menu_Category_id =?', [categoryId]);

    for (var item in items) {
      await database.rawUpdate('UPDATE Menu_items SET menu_Category_id = ? WHERE id = ?', [categoryId, item.id]);
    }
  }

  void delete(id) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE Menu_categories SET in_active = ? WHERE id =?', ['1', id]);
  }

  @override
  checkIfNameExists(MenuCategory category) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from Menu_categories where id != ? and lower(name) = ?",
        [category.id == null ? 0 : category.id, category.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveIfNotExists(List<MenuCategory> menuCategories) async {
    final Database? database = await SqliteRepository().db;
    try {
      for (var menuCategory in menuCategories) {
        var list = await database!.rawQuery("Select * from Menu_categories where name = ?", [menuCategory.name]);
        if (list.length == 0) {
          var list = menuCategory.toMap();
          list["id"] = null;
          await database.insert('Menu_categories', list, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<MenuCategory>> getAllMenuCategories() async {
    List<MenuCategory> categories = List<MenuCategory>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from Menu_categories");
    for (var item in result) {
      categories.add(MenuCategory.fromMap(item));
    }
    return categories;
  }
}
