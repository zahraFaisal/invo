import 'dart:convert';

import 'package:invo_mobile/models/cashier.dart';
import 'package:invo_mobile/repositories/interface/Cashier/ICashierService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CashierInvoService implements ICashierService {
  String? ip;
  String? deviceId;
  late Map<String, String> headers;

  loadPerf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("Invo_IP");
    deviceId = prefs.getString("DeviceID");
    baseUrl = "http://$ip:8081";
    headers = Map<String, String>();
    headers["DeviceID"] = deviceId ?? ""; // this.device.uuid
    headers["Device-Type"] = "1";
    headers["Content-Type"] = "application/json";
  }

  String baseUrl = "";
  //Get /Cashier/Get_Cashier/{cashier_id}
  @override
  Future<Cashier?> get(int id) async {
    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/Cashier/Get_Cashier/" + id.toString()), headers: headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      return Cashier.fromJson(json.decode(response.body));
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  //GetCashierReference/{employee_id}
  @override
  Future<Cashier?> getCashierReference(int empId) async {
    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/Cashier/GetCashierReference/" + empId.toString()), headers: headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      return Cashier.fromJson(json.decode(response.body));
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  //GET  /Cashier/GetTerminalCashier/{terminal_id}
  @override
  Future<Cashier?> getTerminalCashier(int terminalId) async {
    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/Cashier/GetTerminalCashier/" + terminalId.toString()), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      return Cashier.fromJson(json.decode(response.body));
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

//POST /Cashier/Save
  @override
  Future<Cashier?> save(Cashier cashier) async {
    await loadPerf();

    final response = await http.post(Uri.parse("$baseUrl/Cashier/Save"), body: jsonEncode(cashier.toJson()), headers: headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      return Cashier.fromJson(json.decode(response.body));
      // return true;
    } else {
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }
}
