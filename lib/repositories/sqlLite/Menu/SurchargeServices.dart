import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/repositories/interface/Menu/ISurchargeService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class SurchargeService implements ISurchargeService {
  Future<List<SurchargeList>> getActiveList() async {
    List<SurchargeList> surcharges = List<SurchargeList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,amount,is_percentage from Surcharges where in_active=0");
    for (var item in result) {
      surcharges.add(SurchargeList.fromMap(item));
    }
    return surcharges;
  }

  Future<List<SurchargeList>> getList() async {
    List<SurchargeList> surcharges = List<SurchargeList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,amount,is_percentage from Surcharges");
    for (var item in result) {
      surcharges.add(SurchargeList.fromMap(item));
    }
    return surcharges;
  }

  Future<Surcharge> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> surcharge = (await database!.query("Surcharges", where: "id = ?", whereArgs: [id])).first;
    return Surcharge.fromMap(surcharge);
  }

  @override
  getAll() async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = (await database!.query("Surcharges")).toList();

    List<Surcharge> surcharges = List<Surcharge>.empty(growable: true);
    for (var item in list) {
      surcharges.add(Surcharge.fromMap(item));
    }
    return surcharges;
  }

  @override
  void save(Surcharge surcharge) async {
    final Database? database = await SqliteRepository().db;
    int result;

    result = await database!.insert('Surcharges', surcharge.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void update(Surcharge surcharge) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE Surcharges SET in_Active = ? WHERE id =?', ['1', surcharge.id]);
  }

  @override
  checkIfNameExists(Surcharge surcharge) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from Surcharges where id != ? and lower(name) = ?",
        [surcharge.id == null ? 0 : surcharge.id, surcharge.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveIfNotExists(List<Surcharge> surcharges) async {
    try {
      final Database? database = await SqliteRepository().db;
      for (var surcharge in surcharges) {
        var list = await database!.rawQuery("Select * from Surcharges where name = ?", [surcharge.name]);
        if (list.length == 0) {
          surcharge.id = 0;
          await database.insert('Surcharges', surcharge.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
