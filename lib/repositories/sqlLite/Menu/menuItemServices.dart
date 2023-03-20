import 'package:invo_mobile/models/Menu_popup_mod.dart';
import 'package:invo_mobile/models/Selection.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/models/menu_combo.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/menu_selection.dart';
import 'package:invo_mobile/models/quick_modifier.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuItemService.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:collection/collection.dart';

class MenuItemService implements IMenuItemService {
  Future<List<MenuItemList>> getActiveList({List<int>? except}) async {
    List<MenuItemList> items = List<MenuItemList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result;
    if (except == null || except.length == 0) {
      result = await database!.rawQuery("Select id,name,default_price,barcode,description,type from Menu_items where in_active=0");
    } else {
      String temp = "";
      for (var item in except) {
        temp += item.toString() + ",";
      }
      temp = temp.substring(0, temp.length - 1);
      result = await database!
          .rawQuery("Select id,name,default_price,barcode,description,type from Menu_items where in_active=0 and id Not IN (" + temp + ")");
    }

    for (var item in result) {
      items.add(MenuItemList.fromMap(item));
    }
    return items;
  }

  Future<MenuItem>? getIcon(int id) async {
    MenuItem itemIcon = MenuItem();
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result;

    result = await database!.rawQuery("Select id, icon from Menu_items where in_active=0 and id = ?", [id]);

    for (var item in result) {
      itemIcon = MenuItem.fromMap(item);
    }

    return itemIcon;
  }

  Future<List<MenuItemList>> getActiveListBarcodes() async {
    List<MenuItemList> items = List<MenuItemList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result;
    result = await database!.rawQuery("Select id,name,barcode from Menu_items where in_active=0");

    for (var item in result) {
      items.add(MenuItemList.fromMap(item));
    }
    return items;
  }

  getImages(List ids) async {
    List items = List.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result;

    String temp = "";
    for (var item in ids) {
      temp += item.toString() + ",";
    }
    temp = temp.substring(0, temp.length - 1);
    result = await database!.rawQuery("Select id, icon from Menu_items where in_active=0 and id IN (" + temp + ")");

    for (var item in result) {
      items.add(MenuItemIcon.fromMap(item));
    }
    return items;
  }

  Future<List<MenuItemList>> getList() async {
    List<MenuItemList> items = List<MenuItemList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,default_price,barcode, description from Menu_items");
    for (var item in result) {
      items.add(new MenuItemList.fromMap(item));
    }
    return items;
  }

  Future<List<MenuItemList>> getUnCategorizedItems() async {
    List<MenuItemList> items = List<MenuItemList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result =
        await database!.rawQuery("Select id,name,default_price,barcode,description from Menu_items where menu_category_id IS NULL");
    for (var item in result) {
      items.add(MenuItemList.fromMap(item));
    }
    return items;
  }

  @override
  Future<List<MenuItem>> getAll() async {
    Database? database = await SqliteRepository().db;

    List<MenuItem> menuItems = List<MenuItem>.empty(growable: true);

    List<Map<String, dynamic>> items = (await database!.query("Menu_items"));

    MenuItem temp;
    for (var item in items) {
      temp = MenuItem.fromMap(item);
      menuItems.add(temp);
    }

    //LoadPrices
    List<MenuPrice> prices = await getAllPrices();
    for (var item in menuItems) {
      item.prices = prices.where((f) => f.menu_item_id == item.id).toList();
    }

    //Load Quick Modifiers
    List<QuickModifier> quick = await getAllQuickModifiers();
    for (var item in menuItems) {
      item.quick_mod = quick.where((f) => f.menu_item_id == item.id).toList();
    }

    //Load PopUp Modifiers
    List<MenuPopupMod> popup = await getAllPopUpModifiers();
    for (var item in menuItems) {
      item.popup_mod = popup.where((f) => f.menu_item_id == item.id).toList();
    }

    return menuItems;
  }

  @override
  Future<List<MenuItem>> getAllActive() async {
    Database? database = await SqliteRepository().db;

    List<MenuItem> menuItems = List<MenuItem>.empty(growable: true);

    List<Map<String, dynamic>> items = (await database!.query("Menu_items", where: "in_active = ?", whereArgs: [0]));

    MenuItem temp;
    for (var item in items) {
      temp = MenuItem.fromMap(item);
      menuItems.add(temp);
    }

    //LoadPrices
    List<MenuPrice> prices = await getAllPrices();
    for (var item in menuItems) {
      item.prices = prices.where((f) => f.menu_item_id == item.id).toList();
    }

    //Load Quick Modifiers
    List<QuickModifier> quick = await getAllQuickModifiers();
    for (var item in menuItems) {
      item.quick_mod = quick.where((f) => f.menu_item_id == item.id).toList();
    }

    //Load PopUp Modifiers
    List<MenuPopupMod> popup = await getAllPopUpModifiers();
    for (var item in menuItems) {
      item.popup_mod = popup.where((f) => f.menu_item_id == item.id).toList();
    }

    return menuItems;
  }

  Future<List<MenuItem>> getUpdatedMenuItems(DateTime? lastUpdateTime) async {
    try {
      if (lastUpdateTime == null) return getAllActive();
      Database? database = await SqliteRepository().db;
      int _date = 0;
      List<MenuItem> menuItems = List<MenuItem>.empty(growable: true);

      List<Map<String, dynamic>> items = (await database!.rawQuery("SELECT * FROM Menu_items "
          "WHERE in_active = 0 AND  (update_time IS NULL || update_time > $_date)"));

      MenuItem temp;
      for (var item in items) {
        temp = MenuItem.fromMap(item);
        menuItems.add(temp);
      }

      //LoadPrices
      List<MenuPrice> prices = await getAllPrices();
      for (var item in menuItems) {
        item.prices = prices.where((f) => f.menu_item_id == item.id).toList();
      }

      //Load Quick Modifiers
      List<QuickModifier> quick = await getAllQuickModifiers();
      for (var item in menuItems) {
        item.quick_mod = quick.where((f) => f.menu_item_id == item.id).toList();
      }

      //Load PopUp Modifiers
      //List<MenuPopupMod> popup = await getAllPopUpModifiers();
      for (var item in menuItems) {
        item.popup_mod = await getPopUpModifiers(item.id);
      }

      return menuItems;
    } catch (e) {
      return List<MenuItem>.empty(growable: true);
    }
  }

  UpdateMenuItemNullUpdateTime() async {
    final Database? database = await SqliteRepository().db;
    var date = new DateTime.now().toUtc().millisecondsSinceEpoch;
    var result = await database!.rawQuery("Update Menu_items Set [update_time] = $date Where [update_time] IS NULL");
  }

  Future<MenuItem> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("Menu_items", where: "id = ?", whereArgs: [id])).first;
    MenuItem temp = MenuItem.fromMap(item);

    //LoadPrices
    List<Map<String, dynamic>> tempPrices = (await database.query("Menu_prices", where: "menu_item_id = ?", whereArgs: [id])).toList();
    temp.prices = List<MenuPrice>.empty(growable: true);

    for (var item in tempPrices) {
      temp.prices!.add(MenuPrice.fromMap(item));
    }

    //Load Quick Modifiers
    temp.quick_mod = await getQuickModifiers(id);

    //LoadPrices
    temp.popup_mod = await getPopUpModifiers(id);
    //combo items
    //temp.menu_item_combo = await getCompoItems(id);

    //selections
    //temp.selections = await getMenuSelection(id);

    return temp;
  }

  @override
  updateBarcode(MenuItem item) async {
    final Database? database = await SqliteRepository().db;
    String? barcode = item.barcode;
    int? id = item.id;
    await database!.rawUpdate('UPDATE Menu_items SET barcode = ? WHERE id =?', [barcode, id]);
  }

  @override
  Future<int> save(MenuItem item) async {
    final Database? database = await SqliteRepository().db;
    int menuItemId;
    if (item.id == 0 || item.id == null) {
      menuItemId = await database!.insert('Menu_items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      menuItemId = item.id;
      item.update_time = null;
      await database!.update('Menu_items', item.toMap(), where: "id = ?", whereArgs: [item.id], conflictAlgorithm: ConflictAlgorithm.replace);
    }

    //Menu Prices
    for (var price in item.prices!) {
      if (price.id == 0) {
        //new
        //insert
        if (price.price != null && price.price != -1)
          await database.rawInsert("Insert Into Menu_prices(menu_item_id,label_id,price) Values(" +
              menuItemId.toString() +
              "," +
              price.label_id.toString() +
              "," +
              price.price.toString() +
              ")");
      } else {
        //old
        if (price.price == null || price.price == -1) {
          //delete
          await database.rawDelete('DELETE FROM Menu_prices WHERE id= ' + price.id.toString());
        } else {
          //update
          await database.update('Menu_prices', price.toMap(),
              where: "label_id = ? and menu_item_id = ?", whereArgs: [price.label_id, menuItemId], conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }
    //=============================================

    //Quick Modifiers
    await database.rawDelete('DELETE FROM Menu_quick_modifiers WHERE menu_item_id= ' + item.id.toString());
    for (var item in item.quick_mod!) {
      await database.rawInsert(
          "Insert Into Menu_quick_modifiers(menu_item_id,modifier_id) Values(" + menuItemId.toString() + "," + item.modifier_id.toString() + ")");
    }
    //=============================================

    //popup Modifiers
    for (var item in item.popup_mod!) {
      item.menu_item_id = menuItemId;
      if (item.Is_Deleted) {
        await database.rawDelete('DELETE FROM Popup_level_modifiers WHERE menu_popup_mod_id= ' + item.id.toString());

        await database.rawDelete('DELETE FROM Menu_popup_modifiers WHERE id = ' + item.id.toString());

        continue;
      } else {
        if (item.id == 0 || item.id == null) {
          Map<String, dynamic> temp = {
            "menu_item_id": item.menu_item_id,
            "level": item.level,
            "is_forced": item.is_forced == true ? 1 : 0,
            "repeat": item.repeat,
            "description": item.description,
            "secondary_description": item.secondary_description,
            "local": item.local == true ? 1 : 0,
            "online": item.online == true ? 1 : 0,
          };
          item.id = await database.insert('Menu_popup_modifiers', temp, conflictAlgorithm: ConflictAlgorithm.replace);
        } else {
          Map<String, dynamic> temp = {
            "id": item.id,
            "menu_item_id": item.menu_item_id,
            "level": item.level,
            "is_forced": item.is_forced == true ? 1 : 0,
            "repeat": item.repeat,
            "description": item.description,
            "secondary_description": item.secondary_description,
            "online": item.online == true ? 1 : 0,
            "local": item.local == true ? 1 : 0,
          };
          await database.update('Menu_popup_modifiers', temp,
              where: "id = ? and menu_item_id = ?", whereArgs: [item.id, item.menu_item_id], conflictAlgorithm: ConflictAlgorithm.replace);
        }

        for (var modifier in item.modifiers) {
          modifier.menu_popup_mod_id = item.id;
          if (modifier.Is_Deleted) {
            await database.rawDelete('DELETE FROM Popup_level_modifiers WHERE id= ' + modifier.id.toString());
          } else {
            if (modifier.id == 0) {
              Map<String, dynamic> temp = {"modifier_id": modifier.modifier_id, "menu_popup_mod_id": modifier.menu_popup_mod_id};
              modifier.id = await database.insert('Popup_level_modifiers', temp, conflictAlgorithm: ConflictAlgorithm.replace);
            } else {
              Map<String, dynamic> temp = {"id": modifier.id, "modifier_id": modifier.modifier_id, "menu_popup_mod_id": modifier.menu_popup_mod_id};
              await database.update('Popup_level_modifiers', temp,
                  where: "id = ?", whereArgs: [modifier.id], conflictAlgorithm: ConflictAlgorithm.replace);
            }
          }
        }
      }
    }

    //menu item combo ==================================
    // for (var item in item.menu_item_combo) {
    //   item.parent_menu_item_id = menuItemId;
    //   if (item.Is_Deleted) {
    //     await database.rawDelete(
    //         'DELETE FROM Menu_combos WHERE id= ' + item.id.toString());
    //     continue;
    //   } else {
    //     Map<String, int> temp = {
    //       'sub_menu_item_id': item.sub_menu_item_id,
    //       'parent_menu_item_id': item.parent_menu_item_id,
    //       'qty': item.qty
    //     };

    //     if (item.id == 0) {
    //       item.id = await database.insert('Menu_combos', temp,
    //           conflictAlgorithm: ConflictAlgorithm.replace);
    //     } else {
    //       await database.update('Menu_combos', temp,
    //           where: "id = ? and parent_menu_item_id = ?",
    //           whereArgs: [item.id, menuItemId],
    //           conflictAlgorithm: ConflictAlgorithm.replace);
    //     }
    //   }
    // }

    //menu Selections ==================================
    // for (var item in item.selections) {
    //   item.menu_item_id = menuItemId;

    //   Map<String, int> temp = {
    //     'menu_item_id': item.menu_item_id,
    //     'level': item.level,
    //     'no_of_selection': item.no_of_selection,
    //   };

    //   if (item.id == 0) {
    //     print("insert");
    //     item.id = await database.insert('Menu_selections', temp,
    //         conflictAlgorithm: ConflictAlgorithm.replace);
    //     print("item id : ${item.id}");

    //     Map<String, int> selectionsTemp = {
    //       'menu_item_id': item.Selections.menu_item_id,
    //       'name': item.Selections.menu_item.name,
    //       'menu_selection_id': item.id,
    //       'level': item.level,
    //       'no_of_selection': item.no_of_selection,
    //     };

    //     await database.insert('Selections', selectionsTemp,
    //         conflictAlgorithm: ConflictAlgorithm.replace);
    //   } else {
    //     print("update");
    //     Map<String, int> selectionsTemp = {
    //       'menu_item_id': item.Selections.menu_item_id,
    //       'name': item.Selections.menu_item.name,
    //       'menu_selection_id': item.id,
    //       'level': item.level,
    //       'no_of_selection': item.no_of_selection,
    //     };
    //     await database.update('Menu_selections', temp,
    //         where: "id = ?",
    //         whereArgs: [item.id],
    //         conflictAlgorithm: ConflictAlgorithm.replace);
    //     await database.update('Selections', selectionsTemp,
    //         where: "menu_selection_id = ?",
    //         whereArgs: [item.id],
    //         conflictAlgorithm: ConflictAlgorithm.replace);
    //   }
    // }

    return menuItemId;
  }

  void delete(int id) async {
    final Database? database = await SqliteRepository().db;
    await database!.rawUpdate('UPDATE Menu_items SET in_Active = ? WHERE id =?', ['1', id]);
  }

  Future<int> deleteitem(int id) async {
    final Database? database = await SqliteRepository().db;
    int result = await database!.rawDelete('DELETE FROM Menu_items WHERE id= $id');
    return result;
  }

  @override
  Future<List<MenuPrice>> getPrices(int id) async {
    final Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> tempPrices = (await database!.query("Menu_prices", where: "menu_item_id = ?", whereArgs: [id])).toList();
    List<MenuPrice> prices = List<MenuPrice>.empty(growable: true);
    for (var item in tempPrices) {
      prices.add(MenuPrice.fromMap(item));
    }
    return prices;
  }

  @override
  Future<List<MenuPrice>> getAllPrices() async {
    final Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> tempPrices = (await database!.query("Menu_prices")).toList();
    List<MenuPrice> prices = List<MenuPrice>.empty(growable: true);
    for (var item in tempPrices) {
      prices.add(MenuPrice.fromMap(item));
    }
    return prices;
  }

  @override
  Future<List<QuickModifier>> getQuickModifiers(int id) async {
    final Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = await database!.rawQuery(
        "Select Menu_quick_modifiers.*,Menu_modifiers.id As Menu_modifiers_id,Menu_modifiers.name As Menu_modifiers_name From Menu_quick_modifiers Join Menu_modifiers On modifier_id = Menu_modifiers.id Where menu_item_id =" +
            id.toString());

    List<QuickModifier> quickModifiers = List<QuickModifier>.empty(growable: true);
    for (var item in list) {
      quickModifiers.add(QuickModifier(
          id: item['id'], modifier_id: item['modifier_id'], modifier: ModifierList(id: item['modifier_id'], name: item['Menu_modifiers_name'])));
    }
    return quickModifiers;
  }

  // @override
  // Future<List<MenuCombo>> getCompoItems(int id) async {
  //   final Database database = await SqliteRepository().db;
  //   List<Map<String, dynamic>> list = await database.rawQuery(
  //       "Select m.* , m.id as combo_item_id , i.* from Menu_combos m left Join Menu_items i On m.sub_menu_item_id = i.id Where parent_menu_item_id =" +
  //           id.toString());

  //   List<MenuCombo> comboItems = new List<MenuCombo>();
  //   print("combo items from get");
  //   print(json.encode(list).toString());
  //   for (var item in list) {
  //     print("name : ${item['name']}");
  //     comboItems.add(MenuCombo(
  //         id: item['combo_item_id'],
  //         parent_menu_item_id: item['parent_menu_item_id'],
  //         sub_menu_item_id: item['sub_menu_item_id'],
  //         qty: item['qty'],
  //         sub_menu_item: MenuItem(
  //             id: item['sub_menu_item_id'],
  //             name: item['name'],
  //             type: item['type'],
  //             barcode: item['barcode'],
  //             default_price: item['default_price'])));
  //   }
  //   return comboItems;
  // }

  // @override
  // Future<List<MenuSelection>> getMenuSelection(int id) async {
  //   //Selections
  //   final Database database = await SqliteRepository().db;
  //   List<Map<String, dynamic>> list = await database.rawQuery(
  //       "Select * , m.id as menu_id , s.id as selections_id from Menu_selections m jeft join Selections s on m.id = s.menu_selection_id left join Menu_items i on s.menu_item_id = i.id Where m.menu_item_id =" +
  //           id.toString());

  //   List<MenuSelection> menuSelection = new List<MenuSelection>();
  //   for (var item in list) {
  //     menuSelection.add(MenuSelection(
  //         id: item['id'],
  //         level: item['level'],
  //         no_of_selection: item['no_of_selection'],
  //         Selections: Selection(
  //             id: item['selections_id'],
  //             menu_item_id: item['menu_item_id'],
  //             menu_selection_id: item['menu_selection_id'],
  //             menuItem: MenuItem(
  //               id: item['menu_item_id'],
  //               barcode: item['barcode'],
  //               default_price: item['default_price'],
  //             )),
  //         menu_item_id: id));
  //   }
  //   return menuSelection;
  // }

  Future<List<QuickModifier>> getAllQuickModifiers() async {
    final Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = await database!.rawQuery(
        "Select Menu_quick_modifiers.*,Menu_modifiers.id As Menu_modifiers_id,Menu_modifiers.name As Menu_modifiers_name From Menu_quick_modifiers Join Menu_modifiers On modifier_id = Menu_modifiers.id");

    List<QuickModifier> quickModifiers = List<QuickModifier>.empty(growable: true);
    for (var item in list) {
      quickModifiers.add(QuickModifier(
          id: item['id'],
          modifier_id: item['modifier_id'],
          menu_item_id: item['menu_item_id'],
          modifier: ModifierList(id: item['modifier_id'], name: item['Menu_modifiers_name'])));
    }
    return quickModifiers;
  }

  Future<List<MenuPopupMod>> getPopUpModifiers(int id) async {
    final Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = await database!.rawQuery(
        """Select Menu_popup_modifiers.*,Popup_level_modifiers.id As level_modifiers_id, Popup_level_modifiers.modifier_id As menu_modifiers_id, Menu_modifiers.name As modifier_name 
            From Menu_popup_modifiers 
            Inner Join Popup_level_modifiers On Menu_popup_modifiers.id = Popup_level_modifiers.menu_popup_mod_id 
            Inner Join Menu_modifiers On Menu_modifiers.id = Popup_level_modifiers.modifier_id 
            Where menu_item_id =""" +
            id.toString());

    List<MenuPopupMod> popupModifiers = List<MenuPopupMod>.empty(growable: true);
    MenuPopupMod? temp;
    for (var item in list) {
      temp = popupModifiers.firstWhereOrNull((f) => f.id == item['id']);
      if (temp == null) {
        temp = MenuPopupMod(
          id: item['id'],
          menu_item_id: item['menu_item_id'],
          level: item['level'],
          local: item['local'] == 1 ? true : false,
          online: item['online'] == 1 ? true : false,
          is_forced: item['is_forced'] == 1 ? true : false,
          repeat: item['repeat'],
          description: item['description'],
          secondary_description: item['secondary_description'],
          modifiers: List<LevelModifier>.empty(growable: true),
        );
        popupModifiers.add(temp);
      }

      temp.modifiers.add(LevelModifier(
          id: item['level_modifiers_id'],
          menu_popup_mod_id: item['id'],
          modifier: MenuModifier(id: item['menu_modifiers_id'], name: item['modifier_name'], display_name: item['display_name']),
          modifier_id: item['menu_modifiers_id']));
    }
    return popupModifiers;
  }

  Future<List<MenuPopupMod>> getAllPopUpModifiers() async {
    final Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = await database!.rawQuery(
        """Select Menu_popup_modifiers.*,Popup_level_modifiers.id As level_modifiers_id, Popup_level_modifiers.modifier_id As menu_modifiers_id, Menu_modifiers.name As modifier_name, Menu_modifiers.additional_price As modifier_price  
            From Menu_popup_modifiers 
            Inner Join Popup_level_modifiers On Menu_popup_modifiers.id = Popup_level_modifiers.menu_popup_mod_id 
            Inner Join Menu_modifiers On Menu_modifiers.id = Popup_level_modifiers.modifier_id""");

    List<MenuPopupMod> popupModifiers = List<MenuPopupMod>.empty(growable: true);
    MenuPopupMod? temp;
    for (var item in list) {
      temp = popupModifiers.firstWhereOrNull((f) => f.id == item['id']);
      if (temp == null) {
        temp = MenuPopupMod(
          id: item['id'],
          menu_item_id: item['menu_item_id'],
          level: item['level'],
          local: item['local'] == 1 ? true : false,
          online: item['online'] == 1 ? true : false,
          is_forced: item['is_forced'] == 1 ? true : false,
          repeat: item['repeat'],
          description: item['description'],
          modifiers: List<LevelModifier>.empty(growable: true),
        );
        popupModifiers.add(temp);
      }

      temp.modifiers.add(LevelModifier(
          id: item['level_modifiers_id'],
          menu_popup_mod_id: item['id'],
          modifier: MenuModifier(
              id: item['menu_modifiers_id'],
              name: item['modifier_name'],
              display_name: item['display_name'],
              additional_price: item['modifier_price']),
          modifier_id: item['menu_modifiers_id']));
    }
    return popupModifiers;
  }

  @override
  checkIfBarcodeExists(MenuItem item) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from Menu_items where id != ? and lower(barcode) = ?",
        [item.id == null ? 0 : item.id, item.barcode?.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  checkIfNameExists(MenuItem item) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery(
        "Select Count(*) as count from Menu_items where id != ? and lower(name) = ?", [item.id == null ? 0 : item.id, item.name!.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  getMenuItemGroupList(int groupId) async {
    List<MenuItemGroup> itemGroups = List<MenuItemGroup>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("""Select item_group.id as group_id,
            item_group.menu_group_id,
            item_group.menu_item_id,
            item_group.[index] As group_index, 
            item_group.double_height,
            item_group.double_width,
            Menu_items.*
            from Menu_item_groups AS item_group Inner Join Menu_items On Menu_items.id = item_group.menu_item_id
            Where menu_group_id = ?""", [
      groupId,
    ]);

    for (var item in result) {
      print("item index:" + item['group_index'].toString());
      MenuItemGroup itemGroup = new MenuItemGroup(
          id: item['group_id'],
          menu_group_id: item['menu_group_id'],
          menu_item_id: item['menu_item_id'],
          index: item['group_index'],
          double_height: item['double_height'] == 1 ? true : false,
          double_width: item['double_width'] == 1 ? true : false);
      itemGroup.menu_item = new MenuItem.fromMap(item);

      itemGroups.add(itemGroup);
    }
    return itemGroups;
  }

  getUpdatedMenuItemGroups(DateTime? lastUpdateTime) async {
    if (lastUpdateTime == null) return getMenuItemGroupAll();
    List<MenuItemGroup> itemGroups = List<MenuItemGroup>.empty(growable: true);
    Database? database = await SqliteRepository().db;
    int _date = lastUpdateTime.toUtc().millisecondsSinceEpoch;

    List<Map<String, dynamic>> result =
        await database!.rawQuery("""Select * from Menu_item_groups WHERE (update_time IS NULL || update_time > $_date)""");

    for (var item in result) {
      itemGroups.add(MenuItemGroup.fromMap(item));
    }
    return itemGroups;
  }

  UpdateMenuItemGroupNullUpdateTime() async {
    final Database? database = await SqliteRepository().db;
    var date = new DateTime.now().toUtc().millisecondsSinceEpoch;
    var result = await database!.rawQuery("Update Menu_item_groups Set [update_time] = $date Where [update_time] IS NULL");
  }

  @override
  Future<List<MenuItemGroup>> getMenuItemGroupAll() async {
    List<MenuItemGroup> itemGroups = List<MenuItemGroup>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("""Select * from Menu_item_groups""");

    for (var item in result) {
      itemGroups.add(MenuItemGroup.fromMap(item));
    }
    return itemGroups;
  }

  @override
  Future<int> saveMenuItemGroup(MenuItemGroup item) async {
    final Database? database = await SqliteRepository().db;
    int id = await database!.insert('Menu_item_groups', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  @override
  Future<bool> deleteItemGroup(MenuItemGroup selectedItemGroup) async {
    final Database? database = await SqliteRepository().db;
    int effectedRows = await database!.delete('Menu_item_groups', where: "id = " + selectedItemGroup.id.toString());
    return effectedRows > 0;
  }

  @override
  Future<bool> saveIfNotExists(
      List<MenuItem> menuItems, List<PriceLabel> priceLabels, List<MenuCategory> menuCategories, List<MenuModifier> menuModifiers) async {
    final Database? database = await SqliteRepository().db;
    try {
      // await database.delete("Menu_items");
      // await database.delete("Menu_quick_modifiers");
      // await database.delete("Popup_level_modifiers");
      // await database.delete("Menu_popup_modifiers");

      MenuItem? itemTemp;
      MenuCategory? categoryTemp;
      PriceLabel? tempPriceLabel;
      MenuModifier? tempModifier;

      List<MenuPrice> menuItemPrices = List<MenuPrice>.empty(growable: true);
      List<QuickModifier> menuItemQuickModifiers = List<QuickModifier>.empty(growable: true);
      List<MenuPopupMod> menuPopUpModifier = List<MenuPopupMod>.empty(growable: true);
      List<LevelModifier> menuItemPoplvlModifier = List<LevelModifier>.empty(growable: true);
      List<MenuItem> menuItemsList = List<MenuItem>.empty(growable: true);

      var temp;
      for (var item in menuItems) {
        menuItemPrices = List<MenuPrice>.empty(growable: true);
        menuItemQuickModifiers = List<QuickModifier>.empty(growable: true);
        menuPopUpModifier = List<MenuPopupMod>.empty(growable: true);
        menuItemPoplvlModifier = List<LevelModifier>.empty(growable: true);

        categoryTemp = menuCategories.firstWhereOrNull((f) => f.id == item.menu_category_id);
        if (categoryTemp != null) {
          temp = await database!.query("Menu_categories", where: "name = ?", whereArgs: [categoryTemp.name]);
          if (temp.length > 0) item.menu_category_id = temp[0]['id'];
        }

        for (var price in item.prices!) {
          tempPriceLabel = priceLabels.firstWhereOrNull((f) => f.id == price.label_id);
          if (tempPriceLabel != null) {
            price.id = 0;
            temp = await database!.query("price_labels", where: "name = ?", whereArgs: [tempPriceLabel.name]);
            if (temp.length > 0) {
              price.label_id = temp[0]['id'];
              menuItemPrices.add(price);
            }
          }
        }

        for (var quickModifier in item.quick_mod!) {
          tempModifier = menuModifiers.firstWhereOrNull((f) => f.id == quickModifier.modifier_id);
          if (tempModifier != null) {
            quickModifier.id = quickModifier.id;
            temp = await database!.query("Menu_modifiers", where: "name = ?", whereArgs: [tempModifier.name]);
            if (temp.length > 0) {
              quickModifier.modifier_id = temp[0]['id'];
              menuItemQuickModifiers.add(quickModifier);
            }
          }
        }

        for (var popup in item.popup_mod!) {
          popup.menu_item_id = 0;
          for (var level in popup.modifiers) {
            tempModifier = menuModifiers.firstWhereOrNull((f) => f.id == level.modifier_id);
            if (tempModifier != null) {
              temp = await database!.query("Menu_modifiers", where: "name = ?", whereArgs: [tempModifier.name]);
              if (temp.length > 0) {
                level.id = 0;
                level.modifier_id = temp[0]['id'];
                menuItemPoplvlModifier.add(level);
              }
            }
          }
          popup.modifiers = menuItemPoplvlModifier;
          menuPopUpModifier.add(popup);
        }

        item.prices = menuItemPrices;
        item.quick_mod = menuItemQuickModifiers;
        item.popup_mod = menuPopUpModifier;

        temp = await database!.query("Menu_items", where: "name = ?", whereArgs: [item.name]);
        if (temp.length == 0) {
          menuItemsList.add(item);
          // await importMenuItem(item);
        }
      }
      await importMenuItem(menuItemsList);
      return true;
    } catch (ex) {
      return false;
    }
  }

  importMenuItem(menuItems) async {
    try {
      for (var menuItem in menuItems) {
        final Database? database = await SqliteRepository().db;
        var list = menuItem.toMap();
        list["id"] = null;
        int menuItemId = await database!.insert('Menu_items', list, conflictAlgorithm: ConflictAlgorithm.replace);
        //Menu Prices
        for (var price in menuItem.prices) {
          await database.rawInsert("Insert Into Menu_prices(menu_item_id,label_id,price) Values(" +
              menuItemId.toString() +
              "," +
              price.label_id.toString() +
              "," +
              price.price.toString() +
              ")");
        }
        //=============================================

        //Quick Modifiers
        for (var item in menuItem.quick_mod) {
          await database.rawInsert(
              "Insert Into Menu_quick_modifiers(menu_item_id,modifier_id) Values(" + menuItemId.toString() + "," + item.modifier_id.toString() + ")");
        }
        //=============================================

        //popup Modifiers
        for (var item in menuItem.popup_mod) {
          item.menu_item_id = menuItemId;
          Map<String, dynamic> temp = {
            "menu_item_id": item.menu_item_id,
            "level": item.level,
            "is_forced": item.is_forced == true ? 1 : 0,
            "repeat": item.repeat,
            "description": item.description,
            "secondary_description": item.secondary_description,
            "local": item.local == true ? 1 : 0,
            "online": item.online == true ? 1 : 0,
          };
          item.id = await database.insert('Menu_popup_modifiers', temp, conflictAlgorithm: ConflictAlgorithm.replace);

          for (var modifier in item.modifiers) {
            modifier.menu_popup_mod_id = item.id;
            Map<String, dynamic> temp = {"modifier_id": modifier.modifier_id, "menu_popup_mod_id": modifier.menu_popup_mod_id};
            modifier.id = await database.insert('Popup_level_modifiers', temp, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  saveMenuItemGroups(List<MenuItemGroup> value) async {
    final Database? database = await SqliteRepository().db;
    Batch batch = database!.batch();
    for (var item in value) {
      if (item.id != 0 && item.id != null) {
        batch.update("Menu_item_groups", item.toMap(), where: "id = " + item.id.toString());
      } else {
        item.id = 0;
        batch.insert("Menu_item_groups", item.toMap());
      }
    }
    await batch.commit();
  }

  @override
  Future<bool> saveItemGroupIfNotExists(List<MenuItemGroup> menuItemGroups, List<MenuItem> menuItems, List<MenuGroup> menuGroups) async {
    try {
      final Database? database = await SqliteRepository().db;
      MenuGroup? groupTemp;
      MenuItem? itemTemp;
      for (var item in menuItemGroups) {
        groupTemp = menuGroups.firstWhereOrNull((f) => f.id == item.menu_group_id);
        itemTemp = menuItems.firstWhereOrNull((f) => f.id == item.menu_item_id);
        if (itemTemp != null && groupTemp != null) {
          var temp = await database!.rawQuery(
              "SELECT * FROM Menu_item_groups WHERE menu_item_id = (select id from Menu_items where name = ?) and menu_group_id = (select id from Menu_groups where name = ?)",
              [itemTemp.name, groupTemp.name]);
          if (temp.length == 0) {
            Map<String, dynamic> itemDBTemp = (await database.query("Menu_items", where: "name = ?", whereArgs: [itemTemp.name])).first;

            Map<String, dynamic> groupDBTemp = (await database.query("Menu_groups", where: "name = ?", whereArgs: [groupTemp.name])).first;

            if (itemDBTemp != null && groupDBTemp != null) {
              item.menu_group_id = groupDBTemp['id'];
              item.menu_item_id = itemDBTemp['id'];
              var list_ = item.toMap();
              list_['id'] = null;
              await database.insert('Menu_item_groups', list_, conflictAlgorithm: ConflictAlgorithm.replace);
            }
          }
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
