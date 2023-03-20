import 'package:flutter/foundation.dart';
import 'package:invo_mobile/models/custom/payment_method_list.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPaymentMethosService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class PaymentMethodService implements IPaymentMethodService {
  Future<List<PaymentMethodList>> getActiveList() async {
    List<PaymentMethodList> method = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,symbol from payment_methods where  in_active=0");
    for (var item in result) {
      method.add(new PaymentMethodList.fromMap(item));
    }
    return method;
  }

  Future<List<PaymentMethodList>> getList() async {
    List<PaymentMethodList> methods = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,symbol from payment_methods");
    for (var item in result) {
      methods.add(new PaymentMethodList.fromMap(item));
    }
    return methods;
  }

  @override
  Future<List<PaymentMethod>?> getAll() async {
    List<PaymentMethod> methods = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from payment_methods");
    for (var item in result) {
      methods.add(new PaymentMethod.fromMap(item));
    }
    return methods;
  }

  Future<bool> checkIfNameExists(PaymentMethod method) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from payment_methods where id != ? and lower(name) = ?",
        [method.id == null ? 0 : method.id, method.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<PaymentMethod> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("payment_methods", where: "id = ?", whereArgs: [id])).first;
    return PaymentMethod.fromMap(item);
  }

  Future<PaymentMethod> insertIfNotPaymentExists(int id, String name) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select * from payment_methods where name = ?", [name]);

    if (result.length == 0) {
      PaymentMethod method = new PaymentMethod(id: id, name: name, rate: 1, after_decimal: 3, type: 2, in_active: false);
      await database.insert('payment_methods', method.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return method;
    } else {
      return new PaymentMethod();
    }
  }

  @override
  Future<bool> save(PaymentMethod method) async {
    final Database? database = await SqliteRepository().db;
    int result;
    if (method.type != 1) {
      List<Map<String, dynamic>> temp = await database!.rawQuery("Select * from payment_methods where type = 1");
      if (temp != null && temp.length > 0) {
        method.rate = temp[0]['rate'];
        method.symbol = temp[0]['symbol'];
        method.after_decimal = temp[0]['after_decimal'];
      }
    }
    result = await database!.insert('payment_methods', method.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return result > 0;
  }

  void delete(int id) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE payment_methods SET in_Active = ? WHERE id =?', ['1', id]);

    print(result.toString());
  }

  @override
  Future<bool> update(PaymentMethod method) async {
    final Database? database = await SqliteRepository().db;
    int result;

    result = await database!.rawUpdate('UPDATE payment_methods SET after_decimal = ? WHERE id =?', [method.after_decimal, method.id]);
    print(result.toString());

    return result > 0;
  }

  @override
  Future<bool> saveIfNotExists(List<PaymentMethod> methods) async {
    try {
      final Database? database = await SqliteRepository().db;
      for (var method in methods) {
        var list = await database!.rawQuery("Select * from payment_methods where name = ?", [method.name]);
        if (list.length == 0) {
          var temp = method.toMap();
          temp['id'] = null;
          await database.insert('payment_methods', temp, conflictAlgorithm: ConflictAlgorithm.replace);
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
