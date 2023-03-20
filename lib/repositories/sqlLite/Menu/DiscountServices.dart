import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/interface/Menu/IDiscountService.dart';
import 'package:collection/collection.dart';

import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class DiscountService implements IDiscountService {
  Future<List<DiscountList>> getActiveList() async {
    List<DiscountList> discount = List<DiscountList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,amount, is_percentage from Discounts where in_active=0");
    for (var item in result) {
      discount.add(DiscountList.fromMap(item));
    }
    return discount;
  }

  Future<List<DiscountList>> getList() async {
    List<DiscountList> discounts = List<DiscountList>.empty(growable: true);

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select id,name,amount from Discounts where in_active=0");
    for (var item in result) {
      discounts.add(DiscountList.fromMap(item));
    }
    return discounts;
  }

  Future<Discount?>? get(int id) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = (await database!.query("Discounts", where: "id = ?", whereArgs: [id]));

    if (list == null || list.length == 0) return null;
    var item = list[0];
    Discount temp = Discount.fromMap(item);
    //load discount items
    List<Map<String, dynamic>> tempDiscount = (await database.rawQuery("""Select discount_items.* ,menu_items.name as menu_item_name  
                              from discount_items inner join menu_items on menu_items.id = menu_item_id where discount_id =""" +
            id.toString()))
        .toList();

    temp.items = List<DiscountItem>.empty(growable: true);
    for (var item in tempDiscount) {
      temp.items!.add(DiscountItem.fromMap(item));
    }
    //load roles
    List<Map<String, dynamic>> tempRoles =
        (await database.rawQuery("Select Roles.* From Roles Inner Join discount_roles on discount_roles.Role_id_number = Roles.id where discount_id="
                    "" +
                id.toString()))
            .toList();
    temp.Roles = List<Role>.empty(growable: true);
    for (var item in tempRoles) {
      temp.Roles?.add(Role.fromMap(item));
    }
    return temp;
  }

  @override
  Future<List<Discount>> getAll() async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> list = (await database!.query("Discounts"));

    List<Discount> discounts = List<Discount>.empty(growable: true);
    for (var item in list) {
      discounts.add(Discount.fromMap(item));
    }

    //load discount items
    List<Map<String, dynamic>> tempDiscount = (await database.rawQuery("""Select discount_items.* ,menu_items.name as menu_item_name  
                              from discount_items inner join menu_items on menu_items.id = menu_item_id""")).toList();

    List<DiscountItem> discountItems = List<DiscountItem>.empty(growable: true);
    for (var item in tempDiscount) {
      discountItems.add(DiscountItem.fromMap(item));
    }

    Discount? temp;
    for (var item in discounts) {
      item.items = discountItems.where((f) => f.discount_id == item.id).toList();
    }

    //load roles
    List<Map<String, dynamic>> tempRoles = (await database
            .rawQuery("Select Roles.*,discount_roles.discount_id From Roles Inner Join discount_roles on discount_roles.Role_id_number = Roles.id"))
        .toList();

    List<Role> roles = List<Role>.empty(growable: true);
    for (var item in tempRoles) {
      temp = discounts.firstWhereOrNull((f) => f.id == item['discount_id']);

      if (temp != null) temp.Roles!.add(Role.fromMap(item));
    }

    return discounts;
  }

  @override
  void save(Discount discount) async {
    try {
      final Database? database = await SqliteRepository().db;
      int discountId;

      if (discount.id == 0 || discount.id == null) {
        discountId = await database!.insert('Discounts', discount.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } else {
        await database!
            .update('Discounts', discount.toMap(), where: "id = ?", whereArgs: [discount.id], conflictAlgorithm: ConflictAlgorithm.replace);
        discountId = discount.id;
      }

      for (var item in discount.items!) {
        if (item.id == 0 || item.id == null) {
          var temp =
              await database.query("discount_items", where: "menu_item_id = ? and discount_id = ?", whereArgs: [item.menu_item_id, discountId]);
          if (temp.length == 0) {
            await database.rawInsert(
                "Insert Into discount_items(menu_item_id,discount_id) Values(" + item.menu_item_id.toString() + "," + discountId.toString() + ")");
          }
        } else {
          if (item.isDeleted!) {
            await database.rawDelete('DELETE FROM discount_items WHERE id= ' + item.id.toString());
          } else {
            await database.rawUpdate('UPDATE discount_items SET menu_item_id = ? WHERE id =?', [item.menu_item_id, item.id]);
          }
        }
      }

      await database.rawDelete('DELETE FROM discount_roles WHERE Discount_id= ' + discountId.toString());

      for (var role in discount.Roles!) {
        await database.rawInsert(
            "Insert Into discount_roles(Discount_id,Role_id_number) Values(" + discountId.toString() + "," + role.id_number.toString() + ")");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void delete(int id) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE Discounts SET in_Active = ? WHERE id =?', ['1', id]);
  }

  @override
  checkIfNameExists(Discount discount) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from Discounts where id != ? and lower(name) = ?",
        [discount.id == null ? 0 : discount.id, discount.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveIfNotExists(List<Discount> discounts, List<Role> roles, List<MenuItem> menuItems) async {
    try {
      final Database? database = await SqliteRepository().db;

      var found;
      int discountId = 0;
      List<Discount> discountsList = List<Discount>.empty(growable: true);
      List<Role> dRoles = List<Role>.empty(growable: true);
      List<DiscountItem> dItems = List<DiscountItem>.empty(growable: true);
      // await database.delete("Discounts");
      // await database.delete("discount_items");
      // await database.delete("Roles");

      for (var discount in discounts) {
        found = await checkIfNameExists(discount);
        if (!found) {
          discount.id = 0;
          dRoles = List<Role>.empty(growable: true);
          dItems = List<DiscountItem>.empty(growable: true);
          MenuItem? itemTemp;
          for (var item in discount.items!) {
            itemTemp = menuItems.firstWhereOrNull((f) => f.id == item.menu_item_id);
            if (itemTemp != null) {
              List<Map<String, dynamic>> temp = await database!.query("Menu_items", where: "name = ?", whereArgs: [itemTemp.name]);
              if (temp.length > 0) {
                item.menu_item_id = temp[0]['id'];
                item.discount_id = null;
                item.id = null;
                dItems.add(item);
              }
            }
          }

          Role? roleTemp;
          for (var role in discount.Roles!) {
            roleTemp = roles.firstWhereOrNull((f) => f.id_number == role.id_number);
            if (roleTemp != null) {
              List<Map<String, dynamic>> temp_ = await database!.query("Roles", where: "name = ?", whereArgs: [roleTemp.name]);
              if (temp_.length > 0) {
                role.id_number = temp_[0]['id'];
                dRoles.add(role);
              }
            }
          }

          discount.Roles = dRoles;
          discount.items = dItems;
          discountsList.add(discount);
        }
      }

      for (var discount in discountsList) {
        save(discount);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
