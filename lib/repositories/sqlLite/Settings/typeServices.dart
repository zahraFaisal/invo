import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/repositories/interface/Settings/ITypeService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class TypeServices implements ITypeService {
  @override
  Future<List<Service>> getAll() async {
    List<Service> services = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from services");
    for (var item in result) {
      services.add(new Service.fromMap(item));
    }
    return services;
  }

  @override
  Future<bool> saveAll(List<Service> temp) async {
    final Database? database = await SqliteRepository().db;
    for (var item in temp) {
      await database!.update('services', item.toUpdateMap(), where: "id = ?", whereArgs: [item.id], conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return true;
  }
}
