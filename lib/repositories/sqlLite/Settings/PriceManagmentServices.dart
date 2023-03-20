import 'dart:convert';

import 'package:invo_mobile/models/custom/price_managment_list.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPriceManagment.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class PriceManagmentService implements IPriceManagmentService {
  Future<List<PriceManagementList>> getList() async {
    List<PriceManagementList> prices = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("""
    Select Price_Managment.id,Price_Managment.title,Discounts.name as discount ,Surcharges.name as surcharge, price_labels.name as price_label
    ,Price_Managment.from_date, Price_Managment.to_date, Price_Managment.repeat
    from Price_Managment
    Left join Discounts on Discounts.id=discount_id
    Left join Surcharges on surcharges.id=surcharge_id
    Left join price_labels on price_labels.id=price_label_id""");

    for (var item in result) {
      prices.add(new PriceManagementList.fromMap(item));
    }
    return prices;
  }

  Future<PriceManagement> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("Price_Managment", where: "id = ?", whereArgs: [id])).first;
    return PriceManagement.fromMap(item);
  }

  @override
  Future<List<PriceManagement>> getAll() async {
    List<PriceManagement> priceManagement = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = (await database!.query("Price_Managment"));
    for (var item in result) {
      priceManagement.add(new PriceManagement.fromMap(item));
    }
    return priceManagement;
  }

  @override
  Future<bool> save(PriceManagement price) async {
    final Database? database = await SqliteRepository().db;
    int result;
    result = await database!.insert('Price_Managment', price.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print(result.toString());

    return result > 0;
  }

  void delete(int id) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawDelete('DELETE FROM Price_Managment WHERE id = $id');
    print(result.toString());
  }

  @override
  Future<bool> checkIfNameExists(PriceManagement price) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!
        .rawQuery("Select Count(*) as count from Price_Managment where id != ? and title = ?", [price.id == null ? 0 : price.id, price.title]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }
}
