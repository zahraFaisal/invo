import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuGroupService.dart';
import 'package:sqflite/sqlite_api.dart';

import '../sqlite_repository.dart';
import 'dart:convert';

class MenuGroupService implements IMenuGroupService {
  Future<List<MenuGroup>> getList(int menuId) async {
    List<MenuGroup> groups = List<MenuGroup>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result =
        await database!.rawQuery("Select * from Menu_groups where in_active = 0 and menu_type_id = " + menuId.toString());

    for (var item in result) {
      groups.add(MenuGroup.fromMap(item));
    }
    return groups;
  }

  Future<List<MenuGroup>> getListwithUnassigned(int menuId) async {
    List<MenuGroup> groups = List<MenuGroup>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result =
        await database!.rawQuery("Select * from Menu_groups where in_active = 0 and menu_type_id = " + menuId.toString());

    // List<Map<String, dynamic>> result = await database
    //     .rawQuery("Select * from Menu_groups where in_active = 0 ");

    for (var item in result) {
      groups.add(new MenuGroup.fromMap(item));
    }
    return groups;
  }

  Future<List<MenuGroup>>? getAll({List<int>? except}) async {
    List<MenuGroup> groups = List<MenuGroup>.empty(growable: true);

    Database? database = await SqliteRepository().db;

    List<Map<String, dynamic>> result;
    if (except == null || except.length == 0) {
      result = await database!.rawQuery("Select * from Menu_groups where menu_type_id IS NULL");
    } else {
      String temp = "";
      for (var item in except) {
        temp += item.toString() + ",";
      }
      temp = temp.substring(0, temp.length - 1);
      result = await database!.rawQuery("Select * from Menu_groups where menu_type_id IS NULL and id Not IN (" + temp + ")");
    }
    for (var item in result) {
      groups.add(new MenuGroup.fromMap(item));
    }
    return groups;
  }

  Future<List<MenuGroup>>? getActive() async {
    List<MenuGroup> groups = List<MenuGroup>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result;

    result = await database!.rawQuery("Select * from Menu_groups");

    for (var item in result) {
      groups.add(MenuGroup.fromMap(item));
    }
    return groups;
  }

  Future<List<MenuGroup>>? getUpdatedMenuGroup(DateTime? lastUpdateTime) async {
    if (lastUpdateTime == null) return getActive()!;
    List<MenuGroup> groups = List<MenuGroup>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    int _date = lastUpdateTime.toUtc().millisecondsSinceEpoch;
    List<Map<String, dynamic>> result;

    result = await database!.rawQuery("Select * from Menu_groups WHERE (update_time IS NULL || update_time > $_date)");

    for (var item in result) {
      groups.add(MenuGroup.fromMap(item));
    }

    return groups;
  }

  UpdateMenuGroupNullUpdateTime() async {
    final Database? database = await SqliteRepository().db;
    var date = DateTime.now().toUtc().millisecondsSinceEpoch;
    var result = await database!.rawQuery("Update Menu_groups Set [update_time] = $date Where [update_time] IS NULL");
  }

  @override
  updateMenuType(List<MenuGroup> list, int menuId) async {
    String temp = "";
    for (var item in list) {
      temp += item.id.toString() + ",";
    }
    temp = temp.substring(0, temp.length - 1);

    Database? database = await SqliteRepository().db;
    try {
      int resault =
          await database!.rawUpdate("Update Menu_groups set in_active = 0, menu_type_id = " + menuId.toString() + " Where id IN (" + temp + ")");
      print(resault);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<MenuGroup?>? get(int? id) async {
    Database? database = await SqliteRepository().db;
    var groups = (await database!.query("Menu_groups", where: "id = ?", whereArgs: [id]));
    if (groups == null || groups.length == 0) {
      return null;
    }
    Map<String, dynamic> group = groups.first;

    return MenuGroup.fromMap(group);
  }

  @override
  void save(MenuGroup group) async {
    final Database? database = await SqliteRepository().db;
    int result;
    result = await database!.insert('Menu_groups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print(result.toString());
  }

  @override
  delete(MenuGroup group) async {
    final Database? database = await SqliteRepository().db;
    await database!.rawQuery("Delete from Menu_groups where id =" + group.id.toString());
    await database.rawQuery("Delete from Menu_item_groups where menu_group_id =" + group.id.toString());
  }

  @override
  checkIfNameExists(MenuGroup group) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery(
        "Select Count(*) as count from Menu_groups where id != ? and lower(name) = ?", [group.id == null ? 0 : group.id, group.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool>? saveIfNotExists(List<MenuGroup>? groups) async {
    try {
      final Database? database = await SqliteRepository().db;
      for (var group in groups!) {
        var list = await database!.rawQuery("Select * from Menu_groups where name = ?", [group.name]);
        if (list.isEmpty) {
          var list = group.toMap();
          list["id"] = null;
          await database.insert('Menu_groups', list, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
