import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class RoleCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getRoles(request, websocket);
        break;
      case "get":
        this.getRole(request, websocket);
        break;
      case "save":
        this.saveRole(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getRoles(CloudRequest request, Socket websocket) async {
    List<dynamic> list = await locator.get<ConnectionRepository>().roleService!.getActiveList()!;
    if (list.length > 0) {
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

  Future<bool> getRole(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    Map<String, dynamic> result = Map<String, dynamic>();

    if (id == 0) {
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    }
    Role list = await locator.get<ConnectionRepository>().roleService!.get(id)!;
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

  Future<bool> saveRole(CloudRequest request, Socket websocket) async {
    print(json.decode(request.param));
    Map<String, dynamic> temp = json.decode(request.param);
    Role role = new Role.fromMap(temp);
    locator.get<ConnectionRepository>().roleService!.save(role);
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
