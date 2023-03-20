import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MenuCategoryCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getCategories(request, websocket);
        break;
      case "get":
        this.getCategory(request, websocket);
        break;
      case "getUnCategorizedItems":
        this.getUnCategorizedItems(request, websocket);
        break;
      case "save":
        this.saveCategory(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getCategories(CloudRequest request, Socket websocket) async {
    List<MenuCategoryList>? list = await locator.get<ConnectionRepository>().menuCategoryService?.getActiveList();
    if (list!.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      // print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getUnCategorizedItems(CloudRequest request, Socket websocket) async {
    List<MenuItemList>? list = await locator.get<ConnectionRepository>().menuItemService!.getUnCategorizedItems();
    if (list!.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getCategory(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    MenuCategory? list = await locator.get<ConnectionRepository>().menuCategoryService!.get(id);
    if (list != null) {
      Map<String, dynamic> result = Map<String, dynamic>();
      List<Map<String, dynamic>> resultItems = List<Map<String, dynamic>>.empty(growable: true);
      result = list.toMapRequest();

      List<MenuItemList>? menuCategoryItems = await locator.get<ConnectionRepository>().menuCategoryService!.getCetegoriesItems(id);
      menuCategoryItems!.forEach((element) {
        resultItems.add(element.toMap());
      });
      var map = <String, dynamic>{'category': result, 'MenuItems': menuCategoryItems};
      print(jsonEncode(map).toString());

      request.data = jsonEncode(map).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> saveCategory(CloudRequest request, Socket websocket) async {
    print(json.decode(request.param));
    Map temp = json.decode(request.param);
    MenuCategory menuCategory = MenuCategory.fromMap(temp['category']);
    List<dynamic> result = List<dynamic>.empty(growable: true);
    result = temp['MenuItems'];

    List<MenuItemList> menuCategoryItems = List<MenuItemList>.empty(growable: true);
    result.forEach((element) {
      menuCategoryItems.add(MenuItemList.fromMap(element));
    });

    locator
        .get<ConnectionRepository>()
        .menuCategoryService!
        .save(menuCategory, menuCategoryItems.where((element) => (element.isDeleted == false)).toList());
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
