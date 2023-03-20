import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MenuItemCloud {
  processRequest(CloudRequest request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getItems(request, websocket);
        break;
      case "getIcon":
        this.getIcon(request, websocket);
        break;
      case "barcodeList":
        this.getItemsBarcodes(request, websocket);
        break;
      case "priceList":
        this.getItemsPrice(request, websocket);
        break;
      case "savePrices":
        this.savePrices(request, websocket);
        break;
      case "saveBarcodes":
        this.saveBarcodes(request, websocket);
        break;
      case "get":
        this.getItem(request, websocket);
        break;
      case "save":
        this.saveItem(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> saveItem(CloudRequest request, Socket websocket) async {
    Map<String, dynamic> temp = json.decode(request.param);
    MenuItem menuItem = MenuItem.fromMap(temp);
    ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();

    bool exist = await connectionRepository.menuItemService!.checkIfNameExists(menuItem);

    if (exist) {
      sendErrorResopnse(request, websocket, "Item with the same name already exists");
      return false;
    }

    if (menuItem.barcode != null && menuItem.barcode!.isNotEmpty) {
      exist = await connectionRepository.menuItemService!.checkIfBarcodeExists(menuItem);
      if (exist) {
        sendErrorResopnse(request, websocket, "Item with the same barcode already exists");
        return false;
      }
    }

    locator.get<ConnectionRepository>().menuItemService!.save(menuItem);
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

  Future<bool> getIcon(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param.toString());
    MenuItem? item = await locator.get<ConnectionRepository>().menuItemService!.getIcon(id);
    if (item != null) {
      request.data = jsonEncode(item.toMap()).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getItems(CloudRequest request, Socket websocket) async {
    List<MenuItemList>? list = await locator.get<ConnectionRepository>().menuItemService!.getActiveList();
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

  Future<bool> getItemsBarcodes(CloudRequest request, Socket websocket) async {
    List<MenuItemList>? list = await locator.get<ConnectionRepository>().menuItemService!.getActiveListBarcodes();
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

  Future<bool> getItemsPrice(CloudRequest request, Socket websocket) async {
    List<MenuItem>? list = await locator.get<ConnectionRepository>().menuItemService!.getAll();
    if (list!.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
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

  Future<bool> savePrices(CloudRequest request, Socket websocket) async {
    List<dynamic> temp = json.decode(request.param);
    List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
    temp.forEach((element) {
      result.add(element);
    });
    result.forEach((element) {
      MenuItem menuItem = MenuItem.fromMap(element);
      menuItem.default_price = menuItem.new_price!;
      locator.get<ConnectionRepository>().menuItemService!.save(menuItem);
    });
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }

  Future<bool> saveBarcodes(CloudRequest request, Socket websocket) async {
    List<dynamic> temp = json.decode(request.param);
    ConnectionRepository connectionRepository = locator.get<ConnectionRepository>();
    List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
    temp.forEach((element) {
      result.add(element);
    });
    bool exist = false;
    result.forEach((element) async {
      MenuItem menuItem = new MenuItem.fromMap(element);
      menuItem.barcode = menuItem.new_barcode;
      if (menuItem.barcode != null && menuItem.barcode!.isNotEmpty) {
        exist = await connectionRepository.menuItemService!.checkIfBarcodeExists(menuItem);
        if (!exist) {
          locator.get<ConnectionRepository>().menuItemService!.updateBarcode(menuItem);
        }
      }
    });
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }

  Future<bool> getItem(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    MenuItem item;
    if (id == 0) {
      item = new MenuItem();
    } else {
      item = (await locator.get<ConnectionRepository>().menuItemService!.get(id))!;
    }

    if (item != null) {
      Map<String, dynamic> result = new Map<String, dynamic>();
      result = item.toMapRequest();
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }
}
