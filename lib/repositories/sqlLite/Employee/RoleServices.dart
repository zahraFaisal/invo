import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/interface/Employee/IRoleServices.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class RoleService implements IRoleService {
  Future<List<RoleList>> getActiveList() async {
    List<RoleList> roles = List<RoleList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name from Roles where in_active=0");
    for (var item in result) {
      roles.add(new RoleList.fromMap(item));
    }
    return roles;
  }

  Future<List<RoleList>> getList() async {
    List<RoleList> roles = List<RoleList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.query("Select id,name from Roles");
    for (var role in result) {
      roles.add(new RoleList.fromMap(role));
    }
    return roles;
  }

  Future<List<Role>> getAllRoles() async {
    List<Role> roles = List<Role>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from Roles");
    for (var role in result) {
      roles.add(new Role.fromMap(role));
    }
    return roles;
  }

  Future<Role> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> role = (await database!.query("Roles", where: "id = ?", whereArgs: [id])).first;
    return Role.fromMap(role);
  }

  @override
  void save(Role role) async {
    final Database? database = await SqliteRepository().db;
    int result;

    result = await database!.insert('Roles', role.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print(result.toString());
  }

  void update(Role role) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE  Roles  SET in_Active = ? WHERE id =?', ['1', role.id_number]);

    print(result.toString());
  }

  @override
  Future<bool> checkIfNameExists(Role role) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from Roles where id != ? and lower(name) = ?",
        [role.id_number == null ? 0 : role.id_number, role.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveIfNotExists(List<Role> roles) async {
    try {
      final Database? database = await SqliteRepository().db;
      var found = false;
      for (var role in roles) {
        found = await checkIfNameExists(role);
        if (!found) {
          var list = role.toMap();
          list["id_number"] = null;
          await database!.insert('Roles', list, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
