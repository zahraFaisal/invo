import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MenuBilderCloud {
  processRequest(CloudRequest request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getMenuTypes(request, websocket);
        break;
      case "get":
        this.getMenuGroups(request, websocket);
        break;
      case "getItems":
        this.getItems(request, websocket);
        break;
      case "getAllGroups":
        this.getAllGroups(request, websocket);
        break;
      case "saveMenuGroup":
        this.saveMenuGroup(request, websocket);
        break;
      case "saveMenuGroups":
        this.saveMenuGroups(request, websocket);
        break;
      case "saveMenuBuilder":
        this.saveMenuBuilder(request, websocket);
        break;
      case "removeGroup":
        this.removeGroup(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getMenuTypes(CloudRequest request, Socket websocket) async {
    List<MenuType>? list = await locator.get<ConnectionRepository>().menuTypeService!.getActiveList();
    if (list!.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMap());
      });

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getAllGroups(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    List<MenuGroup>? list = await locator.get<ConnectionRepository>().menuGroupService!.getListwithUnassigned(id);
    if (list!.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMap());
      });

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getMenuGroups(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    List<MenuGroup> list;
    if (id == 0) {
      list = List<MenuGroup>.empty(growable: true);
    } else {
      list = (await locator.get<ConnectionRepository>().menuGroupService!.getList(id))!;

      if (list.length > 0) {
        List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
        list.forEach((element) {
          result.add(element.toMap());
        });
        request.data = jsonEncode(result).toString();
        websocket.emit("response", jsonEncode(request.toJson()));
        return true;
      } else {
        request.data = '[]';
        websocket.emit("response", jsonEncode(request.toJson()));
        return false;
      }
    }
    return false;
  }

  Future<bool> saveMenuGroup(CloudRequest request, Socket websocket) async {
    try {
      Map<String, dynamic> temp = json.decode(request.param);
      MenuGroup menuGroup = MenuGroup.fromMap(temp);
      ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();

      bool exist = await connectionRepository.menuGroupService?.checkIfNameExists(menuGroup);

      if (exist) {
        sendErrorResopnse(request, websocket, "Group with the same name already exists");
        return false;
      }

      locator.get<ConnectionRepository>().menuGroupService!.save(menuGroup);
      request.data = '{"status":"Success","msg":"Successfully saved"}';
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> saveMenuGroups(CloudRequest request, Socket websocket) async {
    try {
      List temp = json.decode(request.param);
      ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
      MenuGroup menuGroup;
      temp.forEach((element) {
        menuGroup = MenuGroup.fromMap(element);
        locator.get<ConnectionRepository>().menuGroupService!.save(menuGroup);
      });

      request.data = '{"status":"Success","msg":"Successfully saved"}';
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } catch (e) {
      print(e.toString());
      request.data = '{"status":"Faild","msg":"Faild"}';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> saveMenuBuilder(CloudRequest request, Socket websocket) async {
    try {
      ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
      var temp = json.decode(request.param);
      var groupitems = json.decode(temp['list']);
      var removedIds = json.decode(temp['removedIds']);

      //delete the removed items
      removedIds.forEach((item) async {
        print(item);
        await connectionRepository.menuItemService!.deleteItemGroup(MenuItemGroup(id: item));
      });

      //save items
      List<MenuItemGroup> menuItems = List<MenuItemGroup>.empty(growable: true);
      groupitems.forEach((item) {
        menuItems.add(MenuItemGroup.fromMap(item));
      });
      if (menuItems.length > 0) {
        connectionRepository.menuItemService!.saveMenuItemGroups(menuItems);
      }

      request.data = '{"status":"Success","msg":"Successfully saved"}';
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getItems(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param.toString());
    List<MenuItemGroup> items = await locator.get<ConnectionRepository>().menuItemService!.getMenuItemGroupList(id);

    if (items.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      items.forEach((element) async {
        result.add(element.toMapRequest());
      });
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> removeGroup(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param.toString());
    MenuGroup menuGroup = MenuGroup(id: id);
    ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
    connectionRepository.menuGroupService!.delete(menuGroup);
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }

  void sendSuccessResopnse(request, websocket, msg) {
    request.data = '{"status":"Success","msg":"' + msg + '"}';
    websocket.emit("response", jsonEncode(request.toJson()));
  }

  void sendErrorResopnse(request, websocket, msg) {
    request.data = '{"status":"Faild","msg":"' + msg + '"}';
    websocket.emit("response", jsonEncode(request.toJson()));
  }
}
