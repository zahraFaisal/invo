import 'dart:convert';

import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuModifier.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class MenuModifiersService implements IMenuModifierService {
  Future<List<ModifierList>> getActiveList() async {
    List<ModifierList> modifiers = List<ModifierList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,additional_price from Menu_modifiers where in_active=0");
    for (var item in result) {
      modifiers.add(ModifierList.fromMap(item));
    }
    return modifiers;
  }

  Future<List<MenuModifier>> getUpdatedMenuModifiers(DateTime? lastUpdateTime) async {
    List<MenuModifier> modifiers = List<MenuModifier>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
    if (lastUpdateTime != null) {
      int _date = lastUpdateTime.toUtc().millisecondsSinceEpoch;
      result = await database!.rawQuery("Select * from Menu_modifiers where in_active=0 AND (update_time IS null || update_time > $_date)");
    } else {
      result = await database!.rawQuery("Select * from Menu_modifiers where in_active=0");
    }

    for (var item in result) {
      modifiers.add(MenuModifier.fromMap(item));
    }

    return modifiers;
  }

  UpdateMenuModifierNullUpdateTime() async {
    final Database? database = await SqliteRepository().db;
    var date = DateTime.now().toUtc().millisecondsSinceEpoch;
    var result = await database!.rawQuery("Update Menu_modifiers Set [update_time] = $date Where [update_time] IS NULL");
  }

  Future<List<ModifierList>> getList() async {
    List<ModifierList> modifiers = List<ModifierList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,additional_price from Menu_modifiers");
    for (var item in result) {
      modifiers.add(new ModifierList.fromMap(item));
    }
    return modifiers;
  }

  @override
  Future<List<MenuModifier>> getAll() async {
    Database? database = await SqliteRepository().db;
    List<MenuModifier> menuModifiers = List<MenuModifier>.empty(growable: true);
    List<Map<String, dynamic>> items = (await database!.query("Menu_modifiers"));

    MenuModifier temp;
    for (var item in items) {
      temp = MenuModifier.fromMap(item);
      menuModifiers.add(temp);
    }
    return menuModifiers;
  }

  Future<MenuModifier> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("Menu_modifiers", where: "id = ?", whereArgs: [id])).first;
    MenuModifier temp = MenuModifier.fromMap(item);

    // List<Map<String, dynamic>> tempPrices = (await database.query(
    //         "modifier_prices",
    //         where: "menu_modifier_id = ?",
    //         whereArgs: [id]))
    //     .toList();

    List<Map<String, dynamic>> tempPrices = await database.rawQuery(
        "Select m.* , p.name, p.in_active, p.id as price_id From modifier_prices m left Join price_labels p On p.id = m.label_id Where m.menu_modifier_id =" +
            id.toString());

    temp.prices = List<ModifierPrice>.empty(growable: true);
    for (var item in tempPrices) {
      temp.prices!.add(ModifierPrice(
          id: item['id'],
          item_id: id,
          label_id: item['label_id'],
          price: item['price'],
          menu_modifier_id: item['menu_modifier_id'],
          label:
              PriceLabel(id: item['price_id'], in_active: (item['in_active'] == 0 || item['in_active'] == null) ? false : true, name: item['name'])));
    }

    return temp;
  }

  @override
  Future<int> save(MenuModifier modifier) async {
    final Database? database = await SqliteRepository().db;
    int modifierId;

    if (modifier.id == 0 || modifier.id == null)
      modifierId = await database!.insert('Menu_modifiers', modifier.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      modifierId = modifier.id;
      modifier.update_time = null;
      await database!
          .update('Menu_modifiers', modifier.toMap(), where: "id = ?", whereArgs: [modifier.id], conflictAlgorithm: ConflictAlgorithm.replace);
    }

    //Menu Prices
    if (modifier.prices != null) {
      for (var price in modifier.prices!) {
        if (price.id == 0 || price.id == null) {
          //new
          //insert
          if (price.price != null && price.price != -1.0) {
            await database.rawInsert("Insert Into modifier_prices(menu_modifier_id,label_id,price) Values(" +
                modifierId.toString() +
                "," +
                price.label_id.toString() +
                "," +
                price.price.toString() +
                ")");
          }
        } else {
          print("update");
          //old
          if (price.price == null || price.price == -1) {
            //delete
            await database.rawDelete('DELETE FROM modifier_prices WHERE id= ' + price.id.toString());
          } else {
            //update
            print(json.encode(price.toMap()).toString());
            Map<String, dynamic> temp = {
              "id": price.id,
              "label_id": price.label_id,
              "price": price.price,
            };
            await database.update('modifier_prices', temp, where: "id = ? ", whereArgs: [price.id], conflictAlgorithm: ConflictAlgorithm.replace);

            // await database.rawUpdate(
            //     'UPDATE modifier_prices SET price = ? WHERE id =?',
            //     [price.price, price.id]);
          }
        }
      }
    }

    return modifierId;
  }

  void delete(int id) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE Menu_modifiers SET in_Active = ? WHERE id =?', ['1', id]);

    print(result.toString());
  }

  @override
  Future<bool> checkIfNameExists(MenuModifier modifier) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from Menu_modifiers where id != ? and lower(name) = ?",
        [modifier.id == null ? 0 : modifier.id, modifier.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveIfNotExists(List<MenuModifier> modifiers, List<PriceLabel> priceLabels) async {
    try {
      final Database? database = await SqliteRepository().db;

      List<MenuModifier> modifiersList = List<MenuModifier>.empty(growable: true);
      List<ModifierPrice> modifierPrices = List<ModifierPrice>.empty(growable: true);

      PriceLabel tempPriceLabel;
      for (var modifier in modifiers) {
        var length = (await database!.query("Menu_modifiers", where: "name = ?", whereArgs: [modifier.name])).length;
        if (length == 0) {
          modifierPrices = List<ModifierPrice>.empty(growable: true);
          for (var price in modifier.prices!) {
            tempPriceLabel = priceLabels.firstWhere((f) => f.id == price.label_id);
            if (tempPriceLabel != null) {
              Map<String, dynamic> priceLabel = (await database.query("price_labels", where: "name = ?", whereArgs: [tempPriceLabel.name])).first;
              modifierPrices.add(new ModifierPrice(label_id: priceLabel['id'], name: price.name, price: price.price));
            }

            modifier.prices = modifierPrices;
          }
          modifiersList.add(modifier);
        }
      }

      int id = 0;
      for (var modifier in modifiersList) {
        var list = modifier.toMap();
        list["id"] = null;
        id = await database!.insert('Menu_modifiers', list, conflictAlgorithm: ConflictAlgorithm.replace);
        if (modifier.prices != null) {
          for (var price in modifier.prices!) {
            price.menu_modifier_id = id;
            var temp = <String, dynamic>{
              'menu_modifier_id': id,
              'label_id': price.label_id,
              'price': price.price,
            };
            await database.insert('modifier_prices', temp, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
