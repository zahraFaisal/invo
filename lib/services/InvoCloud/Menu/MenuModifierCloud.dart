import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:collection/collection.dart';

class MenuModifierCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getModifiers(request, websocket);
        break;
      case "get":
        this.getModifier(request, websocket);
        break;
      case "save":
        this.saveModifier(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getModifiers(CloudRequest request, Socket websocket) async {
    List<ModifierList>? list = await locator.get<ConnectionRepository>().menuModifierService!.getActiveList();
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

  Future<bool> getModifier(CloudRequest request, Socket websocket) async {
    var connectionRepository = locator.get<ConnectionRepository>();
    int id = int.parse(request.param);
    MenuModifier? menuModifier = await locator.get<ConnectionRepository>().menuModifierService!.get(id);

    List<PriceLabel>? prices = await connectionRepository.priceService!.getActiveList();

    for (var price in prices!) {
      if (menuModifier!.prices!.where((f) => f.label_id == price.id).length == 0) {
        menuModifier.prices!.add(ModifierPrice(id: 0, label_id: price.id!, label: price));
      } else {
        ModifierPrice? modifierPrice = menuModifier.prices!.firstWhereOrNull((f) => f.label_id == price.id);
        if (modifierPrice != null) modifierPrice.label = price;
      }
    }

    if (menuModifier != null) {
      Map<String, dynamic> result = new Map<String, dynamic>();
      result = menuModifier.toMapRequest();

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> saveModifier(CloudRequest request, Socket websocket) async {
    Map<String, dynamic> temp = json.decode(request.param);
    MenuModifier menuModifier = MenuModifier.fromMap(temp);
    locator.get<ConnectionRepository>().menuModifierService!.save(menuModifier);
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
