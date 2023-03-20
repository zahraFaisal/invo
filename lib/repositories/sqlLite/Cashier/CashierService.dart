import 'package:flutter/foundation.dart';
import 'package:invo_mobile/models/cashier.dart';
import 'package:invo_mobile/models/cashier_detail.dart';
import 'package:invo_mobile/repositories/interface/Cashier/ICashierService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class CashierService implements ICashierService {
  @override
  Future<Cashier?> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("Cashiers", where: "id = ?", whereArgs: [id])).first;
    Cashier temp = Cashier.fromMap(item);
    //load discount items
    List<Map<String, dynamic>> tempDetails = (await database.rawQuery("""Select Cashier_details.*
                                    from Cashier_details 
                                    where cashier_id =""" +
            id.toString()))
        .toList();

    temp.details = [];
    for (var item in tempDetails) {
      temp.details?.add(CashierDetail.fromMap(item));
    }

    return temp;
  }

  @override
  Future<Cashier?> save(Cashier cashier) async {
    try {
      Database? database = await SqliteRepository().db;
      if (cashier.id == 0 || cashier.id == null) {
        cashier.id = await database!.insert('Cashiers', cashier.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } else {
        await database!.update('Cashiers', cashier.toMap(), where: "id = ?", whereArgs: [cashier.id], conflictAlgorithm: ConflictAlgorithm.replace);
      }

      for (var item in cashier.details!) {
        item.cashier_id = cashier.id;
        if (item.id == 0) {
          item.id = await database.insert('Cashier_details', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          await database.update('Cashier_details', item.toMap(), where: "id = ?", whereArgs: [item.id], conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      return cashier;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  @override
  Future<Cashier?> getTerminalCashier(terminalId) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = (await database!.rawQuery("""SELECT [Cashiers].*
                              FROM [Cashiers]
                              Where [cashier_out] IS NULL and terminal_id = ?
                              Order by [Cashiers].id desc""", [terminalId]));
    if (list != null && list.length > 0) {
      var item = list[0];
      Cashier temp = Cashier.fromMap(item);
      return temp;
    }
    return null;
  }

  @override
  Future<Cashier?> getCashierReference(int empId) async {
    try {
      Database? database = await SqliteRepository().db;
      List<Map<String, dynamic>> list = (await database!.rawQuery("""SELECT [Cashiers].*
                              FROM [Cashiers]
                              Where [cashier_out] IS NULL and employee_id = ?
                              Order by [Cashiers].id desc""", [empId]));
      if (list != null && list.length > 0) {
        var item = list[0];
        Cashier temp = Cashier.fromMap(item);
        return temp;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
