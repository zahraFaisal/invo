import 'package:flutter/foundation.dart';
import 'package:invo_mobile/models/custom/table_status.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/repositories/interface/Settings/IDineInService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class DineInService implements IDineInService {
  @override
  Future<List<DineInGroup>> loadSections() async {
    List<DineInGroup> groups = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from DineIn_table_groups where in_active=0");
    for (var item in result) {
      groups.add(new DineInGroup.fromMap(item));
    }
    return groups;
  }

  @override
  Future<List<DineInGroup>> getHiddenSections() async {
    List<DineInGroup> groups = [];
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from DineIn_table_groups where in_active=1");
    for (var item in result) {
      groups.add(new DineInGroup.fromMap(item));
    }
    return groups;
  }

  @override
  Future<DineInGroup> getSection(int groupId) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("DineIn_table_groups", where: "id = ?", whereArgs: [groupId])).first;
    return DineInGroup.fromMap(item);
  }

  @override
  Future<DineInGroup> saveSection(DineInGroup group) async {
    final Database? database = await SqliteRepository().db;

    if (group.id == 0 || group.id == null) {
      group.id = await database!.insert('DineIn_table_groups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await database!
          .update('DineIn_table_groups', group.toMap(), where: "id = ?", whereArgs: [group.id], conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return group;
  }

  @override
  Future<List<DineInGroup>> getAll() async {
    List<DineInGroup> groups = await loadSections();
    List<DineInTable> tables = await loadTables();

    List<DineInTable> temp;
    for (var group in groups) {
      temp = tables.where((f) => f.table_group_id == group.id).toList();
      group.tables = temp;
    }
    return groups;
  }

  @override
  Future<bool> checkIfNameExists(DineInGroup group) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery(
        "Select Count(*) as count from DineIn_table_groups where id != ? and lower(name) = ?",
        [group.id == null ? 0 : group.id, group.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  loadTables() async {
    List<DineInTable> groups = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from DineIn_tables where in_active=0");
    for (var item in result) {
      groups.add(new DineInTable.fromMap(item));
    }
    return groups;
  }

  @override
  pickTables(List<DineInTable> tables) async {
    Database? database = await SqliteRepository().db;
    tables.forEach((table) async {
      await database!.rawUpdate("Update DineIn_tables set in_active = 0 where  id = ?", [table.id]);
    });
  }

  @override
  pickSections(List<DineInGroup> groups) async {
    Database? database = await SqliteRepository().db;
    groups.forEach((group) async {
      await database!.rawUpdate("Update DineIn_table_groups set in_active = 0 where id = ?", [group.id]);
    });
  }

  @override
  loadGroupTables(int groupId) async {
    List<DineInTable> groups = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from DineIn_tables where table_group_id = ? and in_active=0", [groupId]);
    for (var item in result) {
      groups.add(new DineInTable.fromMap(item));
    }
    return groups;
  }

  @override
  getGroupHiddenTables(int groupId) async {
    List<DineInTable> groups = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from DineIn_tables where table_group_id = ? and in_active=1", [groupId]);
    for (var item in result) {
      groups.add(new DineInTable.fromMap(item));
    }
    return groups;
  }

  @override
  checkIfTableNameExists(DineInTable table) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery(
        "Select Count(*) as count from DineIn_tables where id != ? and lower(name) = ?", [table.id == null ? 0 : table.id, table.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<DineInTable> getTable(int tableId) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("DineIn_tables", where: "id = ?", whereArgs: [tableId])).first;
    return DineInTable.fromMap(item);
  }

  @override
  Future<DineInTable> saveTable(DineInTable table) async {
    final Database? database = await SqliteRepository().db;

    if (table.id == 0 || table.id == null) {
      table.id = await database!.insert('DineIn_tables', table.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await database!.update('DineIn_tables', table.toMap(), where: "id = ?", whereArgs: [table.id], conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return table;
  }

  @override
  saveTablePosition(DineInTable item) async {
    final Database? database = await SqliteRepository().db;
    await database!.rawUpdate("Update DineIn_tables set position = ? where id = ?", [item.postion, item.id]);
  }

  @override
  hideTable(int tableId) async {
    try {
      final Database? database = await SqliteRepository().db;
      await database!.rawUpdate("Update DineIn_tables set in_active = 1 where id = ?", [tableId]);
    } catch (e) {
      print("$e");
    }
  }

  @override
  Future<List<TableStatus>> fetchTablesStatus() async {
    final Database? database = await SqliteRepository().db;

    var resaults = await database!.rawQuery(
        """Select Order_headers.dinein_table_id as table_id,Min(Order_headers.date_time) as open_date,Count(*) as OrderCount,Case When Min(print_time) Is Null Then 0 Else 1 End as bill_printed
                                From Order_headers
                                where Order_headers.dinein_table_id IS Not NULL and (status = 1 or status = 2 or status = 6) 
                                Group by Order_headers.dinein_table_id""");

    List<TableStatus> temp = [];
    for (var item in resaults) {
      temp.add(TableStatus.fromMap(item));
    }
    return temp;
  }

  @override
  Future<void> delete(DineInGroup dineInGroup) async {
    final Database? database = await SqliteRepository().db;
    await database!.rawUpdate("Update DineIn_table_groups set in_active = 1 where id = ?", [dineInGroup.id]);
    await database.rawUpdate("Update DineIn_tables set in_active = 1 where table_group_id = ?", [dineInGroup.id]);
    // await database.rawQuery("Delete from DineIn_table_groups where id =" +
    //     dineInGroup.id.toString());
    // await database.rawQuery("Delete from DineIn_tables where table_group_id =" +
    //     dineInGroup.id.toString());
  }

  @override
  Future<bool> saveIfNotExists(List<DineInGroup> groups) async {
    try {
      final Database? database = await SqliteRepository().db;
      int id;
      var list;
      for (var group in groups) {
        list = await database!.rawQuery("Select * from DineIn_table_groups where name = ?", [group.name]);
        if (list.length == 0) {
          id = await database.insert('DineIn_table_groups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          id = list[0]['id'];
        }

        for (var table in group.tables!) {
          list = await database.rawQuery("Select * from DineIn_tables where name = ?", [table.name]);
          if (list.length == 0) {
            table.table_group_id = id;
            await database.insert('DineIn_tables', table.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}
