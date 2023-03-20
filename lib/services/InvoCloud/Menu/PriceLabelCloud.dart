import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PriceLabelCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getPrices(request, websocket);
        break;
      case "get":
        this.getPrice(request, websocket);
        break;

      case "save":
        this.savePrice(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getPrices(CloudRequest request, Socket websocket) async {
    List<PriceLabel>? list = await locator.get<ConnectionRepository>().priceService!.getActiveList();
    if (list!.isNotEmpty) {
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

  Future<bool> getPrice(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    PriceLabel list = PriceLabel();
    if (id != 0) {
      list = (await locator.get<ConnectionRepository>().priceService!.get(id))!;
    }
    if (list != null) {
      Map<String, dynamic> result = Map<String, dynamic>();
      result = list.toMapRequest();

      List<MenuPrice>? menuList = await locator.get<ConnectionRepository>().priceService!.getMenuPrice(id);

      if (menuList!.isNotEmpty) {
        List<Map<String, dynamic>> menuResult = List<Map<String, dynamic>>.empty(growable: true);
        menuList.forEach((element) {
          menuResult.add(element.toMapRequest());
        });

        List<ModifierPrice>? modifierList = await locator.get<ConnectionRepository>().priceService!.getModifierPrice(id);
        if (modifierList!.isNotEmpty) {
          List<Map<String, dynamic>> modifierResult = List<Map<String, dynamic>>.empty(growable: true);
          modifierList.forEach((element) {
            modifierResult.add(element.toMapRequest());
          });
          var map = <String, dynamic>{'price_label': result, 'MenuItems': menuResult, 'MenuModifiers': modifierResult};
          request.data = jsonEncode(map).toString();
          websocket.emit("response", jsonEncode(request.toJson()));
        }
      }
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> savePrice(CloudRequest request, Socket websocket) async {
    Map temp = json.decode(request.param);
    PriceLabel price = new PriceLabel.fromMap(temp['price_label']);

    List<dynamic> menuItemResult = List<dynamic>.empty(growable: true);
    menuItemResult = temp['MenuItems'];

    List<MenuPrice> menuItems = List<MenuPrice>.empty(growable: true);
    menuItemResult.forEach((element) {
      menuItems.add(new MenuPrice.fromMap(element));
    });

    List<dynamic> modifierResult = List<dynamic>.empty(growable: true);
    modifierResult = temp['MenuModifiers'];

    List<ModifierPrice> modifiers = List<ModifierPrice>.empty(growable: true);
    modifierResult.forEach((element) {
      modifiers.add(new ModifierPrice.fromMap(element));
    });
    locator.get<ConnectionRepository>().priceService!.savePrices(price, modifiers, menuItems);

    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
