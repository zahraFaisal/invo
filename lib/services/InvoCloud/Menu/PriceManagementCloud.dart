import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/custom/price_managment_list.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PriceManagementCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getPriceManagements(request, websocket);
        break;
      case "get":
        this.getPriceManagement(request, websocket);
        break;
      case "save":
        this.savePriceManagement(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getPriceManagements(CloudRequest request, Socket websocket) async {
    List<PriceManagementList>? list = await locator.get<ConnectionRepository>().priceManagmentService!.getList();
    if (list!.isNotEmpty) {
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

  Future<bool> getPriceManagement(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    Map<String, dynamic> result = new Map<String, dynamic>();

    if (id == 0) {
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    }
    PriceManagement? list = await locator.get<ConnectionRepository>().priceManagmentService!.get(id);
    if (list != null) {
      result = list.toMapRequest();

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

  Future<bool> savePriceManagement(CloudRequest request, Socket websocket) async {
    Map<String, dynamic> temp = json.decode(request.param);
    PriceManagement priceManagement = new PriceManagement.fromJson(temp);
    locator.get<ConnectionRepository>().priceManagmentService!.save(priceManagement);
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
