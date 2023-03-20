import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SurchargeCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getSurcharges(request, websocket);
        break;
      case "get":
        this.getSurcharge(request, websocket);
        break;
      case "save":
        this.saveSurcharge(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getSurcharges(CloudRequest request, Socket websocket) async {
    List<SurchargeList>? list = await locator.get<ConnectionRepository>().surchargeService!.getActiveList();
    if (list!.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      for (var element in list) {
        result.add(element.toMapRequest());
      }

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getSurcharge(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    Surcharge? list = await locator.get<ConnectionRepository>().surchargeService!.get(id);
    if (list != null) {
      Map<String, dynamic> result = Map<String, dynamic>();
      result = list.toMap();

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> saveSurcharge(CloudRequest request, Socket websocket) async {
    Map<String, dynamic> temp = json.decode(request.param);
    Surcharge surcharge = Surcharge.fromMap(temp);
    locator.get<ConnectionRepository>().surchargeService!.save(surcharge);
    // request.data = '{"status":"Success","msg":"Successfully saved"}';
    request.data = 'Success';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
