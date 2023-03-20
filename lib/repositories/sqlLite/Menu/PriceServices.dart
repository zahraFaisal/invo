import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/interface/Menu/IPriceService.dart';

import 'package:sqflite/sqflite.dart';
import '../sqlite_repository.dart';

import 'dart:convert';

class PriceService implements IPriceService {
  Future<List<PriceLabel>> getActiveList() async {
    List<PriceLabel> prices = List<PriceLabel>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.query("price_labels", where: "in_active = ?", whereArgs: [0]);
    for (var item in result) {
      prices.add(new PriceLabel.fromMap(item));
    }
    return prices;
  }

  Future<List<PriceLabel>> getList() async {
    List<PriceLabel> prices = List<PriceLabel>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.query("price_labels");
    for (var price in result) {
      prices.add(PriceLabel.fromMap(price));
    }

    return prices;
  }

  Future<List<MenuPrice>> joinPrices() async {
    List<MenuPrice> items = List<MenuPrice>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result =
        await database!.query("SELECT id,id from Menu_items INNER JOIN menu_categories on menu_categories.id=menu_items.id");
    for (var item in result) {
      items.add(MenuPrice.fromMap(item));
    }
    return items;
  }

  Future<PriceLabel> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> price = (await database!.query("price_labels", where: "id = ?", whereArgs: [id])).first;
    return PriceLabel.fromMap(price);
  }

  @override
  void save(PriceLabel price) async {
    final Database? database = await SqliteRepository().db;
    int result;
    result = await database!.insert('price_labels', price.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print(result.toString());
  }

  void savePrices(PriceLabel price, List<ModifierPrice> modifiers, List<MenuPrice> menuItems) async {
    final Database? database = await SqliteRepository().db;
    int result;

    result = await database!.insert('price_labels', price.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print(result.toString());

    //delete Menu Item Price
    List<int> ids = List<int>.empty(growable: true);
    for (var item in menuItems.where((f) => f.id != null && f.price != null && f.price! < 0).toList()) {
      ids.add(item.id);
    }
    if (ids.length > 0) {
      int effectedRows = await database.delete('Menu_prices', where: "id In(" + ids.join(',') + ")");
    }
    ids.clear();
    //delete Menu Modifier Price
    for (var item in modifiers.where((f) => f.id != null && f.price != null && f.price! < 0).toList()) {
      ids.add(item.id);
    }
    if (ids.length > 0) int effectedRows = await database.delete('Modifier_prices', where: "id In(" + ids.join(',') + ")");

    //modifiy Menu Item Price
    String sql = "";
    List<MenuPrice> prices = menuItems.where((f) => f.id != null && f.price != null && f.price! >= 0).toList();
    for (var item in prices) {
      sql += "Update Menu_prices Set price = " + item.price.toString() + " Where id = " + item.id.toString() + ";";
    }
    if (sql != "") await database.rawQuery(sql);
    sql = "";
    //modifiy Menu Modifier Price
    List<ModifierPrice> modifierPrices = modifiers.where((f) => f.id != null && f.price != null && f.price! >= 0).toList();
    for (var item in modifierPrices) {
      sql += "Update Modifier_prices Set price = " + item.price.toString() + " Where id = " + item.id.toString() + ";";
    }
    if (sql != "") await database.rawQuery(sql);

    //insert Menu Item Price
    sql = "";

    prices = menuItems.where((f) => (f.id == null || f.id == 0) && f.price != null && f.price! >= 0).toList();

    for (var item in prices) {
      sql += "Insert Into Menu_prices(price,label_id,menu_item_id)"
              " Values(" +
          item.price.toString() +
          "," +
          price.id.toString() +
          "," +
          item.item_id.toString() +
          ");";
    }

    //insert Menu Modifier Price
    modifierPrices = modifiers.where((f) => (f.id == null || f.id == 0) && f.price != null && f.price! >= 0).toList();
    for (var item in modifierPrices) {
      sql += "Insert Into Modifier_prices(price,label_id,menu_modifier_id)"
              "Values(" +
          item.price.toString() +
          "," +
          price.id.toString() +
          "," +
          item.item_id.toString() +
          ");";
    }

    if (sql != "") await database.rawQuery(sql);
  }

  void delete(int id) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE price_labels SET in_Active = ? WHERE id =?', ['1', id]);

    print(result.toString());
  }

  @override
  checkIfNameExists(PriceLabel price) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery(
        "Select Count(*) as count from price_labels where id != ? and lower(name) = ?", [price.id == null ? 0 : price.id, price.name!.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MenuPrice>> getMenuPrice(int id) async {
    Database? database = await SqliteRepository().db;
    List<MenuPrice> menuPrices = List<MenuPrice>.empty(growable: true);
    String sql = """Select MP.id, MI.id as item_id ,MI.name,MP.price, MI.default_price ,Menu_categories.name as category_name
                    From Menu_items As MI
                    LEFT join Menu_categories on Menu_categories.id = MI.menu_category_id
                    LEFT Outer join Menu_prices As MP ON MI.id = MP.menu_item_id and MP.label_id =  ?
                    Where MI.in_active = 0""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [id]);
    for (var price in result) {
      menuPrices.add(MenuPrice.fromMap(price));
    }
    return menuPrices;
  }

  Future<List<ModifierPrice>> getModifierPrice(int id) async {
    Database? database = await SqliteRepository().db;
    List<ModifierPrice> modifierPrices = List<ModifierPrice>.empty(growable: true);
    String sql = """Select MP.id, MI.id as item_id ,MI.name,MP.price, MI.additional_price as default_price
                    From Menu_modifiers As MI
                    LEFT Outer join Modifier_prices As MP ON MI.id = MP.menu_modifier_id and MP.label_id =  ?
                    Where MI.in_active = 0""";
    List<Map<String, dynamic>> result = await database!.rawQuery(sql, [id]);
    for (var price in result) {
      modifierPrices.add(new ModifierPrice.fromMap(price));
    }
    return modifierPrices;
  }

  @override
  Future<bool> saveIfNotExists(List<PriceLabel> prices) async {
    final Database? database = await SqliteRepository().db;
    try {
      for (var price in prices) {
        var list = await database!.rawQuery("Select * from price_labels where name = ?", [price.name]);
        if (list.length == 0) {
          var list = price.toMap();
          list["id"] = null;
          await database.insert('price_labels', list, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      return true;
    } catch (e) {
      return false;
      print(e);
    }
  }
}
