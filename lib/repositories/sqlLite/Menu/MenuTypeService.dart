import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuTypeService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class MenuTypeService implements IMenuTypeService {
  @override
  checkIfNameExists(MenuType menu) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery(
        "Select Count(*) as count from Menu_types where id != ? and lower(name) = ?", [menu.id == null ? 0 : menu.id, menu.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void delete(MenuType menuType) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawQuery("Update Menu_groups set menu_type_id = NULL,in_active = 1 where menu_type_id =" + menuType.id.toString());

    result = await database.rawQuery("Update Menu_types set in_active = 1 where id =" + menuType.id.toString());
  }

  @override
  Future<MenuType> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("Menu_types", where: "id = ?", whereArgs: [id])).first;
    return MenuType.fromMap(item);
  }

  @override
  Future<List<MenuType>> getActiveList() async {
    List<MenuType> menus = List<MenuType>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from Menu_types where in_active = 0");
    for (var item in result) {
      menus.add(MenuType.fromMap(item));
    }
    return menus;
  }

  Future<List<MenuType>?>? getUpdatedMenuType(DateTime? lastUpdateTime) async {
    if (lastUpdateTime == null) return getActiveList();
    List<MenuType> menus = List<MenuType>.empty(growable: true);

    int _date = lastUpdateTime.toUtc().millisecondsSinceEpoch;

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result =
        await database!.rawQuery("Select * from Menu_types where in_active = 0 and (update_time IS NULL || update_time > $_date)");
    for (var item in result) {
      menus.add(new MenuType.fromMap(item));
    }
    return menus;
  }

  UpdateMenuTypeNullUpdateTime() async {
    final Database? database = await SqliteRepository().db;
    var date = new DateTime.now().toUtc().millisecondsSinceEpoch;
    var result = await database!.rawQuery("Update Menu_types Set [update_time] = $date Where [update_time] IS NULL");
  }

  @override
  Future<List<MenuType>> getList() async {
    List<MenuType> menus = List<MenuType>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name from Menu_types where in_active = 1");
    for (var item in result) {
      menus.add(new MenuType.fromMap(item));
    }
    return menus;
  }

  @override
  void save(MenuType menuType) async {
    final Database? database = await SqliteRepository().db;
    await database!.insert('Menu_types', menuType.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<bool> saveIfNotExists(List<MenuType> menuTypes) async {
    try {
      final Database? database = await SqliteRepository().db;
      for (var menuType in menuTypes) {
        var list = await database!.rawQuery("Select * from Menu_types where name = ?", [menuType.name]);
        if (list.length == 0) {
          var list = menuType.toMap();
          list["id"] = null;
          await database.insert('Menu_types', list, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
