import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class EmployeeCloud {
  processRequest(request, websocket) {
    List<String> list = request.request.split(':');
    switch (list[1]) {
      case "list":
        this.getEmployees(request, websocket);
        break;
      case "get":
        this.getEmployee(request, websocket);
        break;
      case "save":
        this.saveEmployee(request, websocket);
        break;
      default:
        break;
    }
  }

  Future<bool> getEmployees(CloudRequest request, Socket websocket) async {
    List<dynamic> list = await locator.get<ConnectionRepository>().employeeService!.getActiveList()!;
    if (list.length > 0) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMap());
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

  Future<bool> getEmployee(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param);
    Employee list = await locator.get<ConnectionRepository>().employeeService!.get(id)!;
    if (list != null) {
      Map<String, dynamic> result = new Map<String, dynamic>();
      result = list.toMap();

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

  Future<bool> saveEmployee(CloudRequest request, Socket websocket) async {
    Map<String, dynamic> temp = json.decode(request.param);
    Employee employee = new Employee.fromMap(temp);
    locator.get<ConnectionRepository>().employeeService!.save(employee);
    request.data = '{"status":"Success","msg":"Successfully saved"}';
    websocket.emit("response", jsonEncode(request.toJson()));
    return true;
  }
}
