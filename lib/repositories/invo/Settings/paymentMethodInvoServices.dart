import 'dart:convert';

import 'package:invo_mobile/models/custom/payment_method_list.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPaymentMethosService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentMethodInvoService implements IPaymentMethodService {
  late String ip;
  late String deviceId;
  late Map<String, String> headers;
  loadPerf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("Invo_IP")!;
    deviceId = prefs.getString("DeviceID") ?? "";
    baseUrl = "http://" + "$ip:8081";
    headers = new Map<String, String>();
    headers["DeviceID"] = deviceId; // this.device.uuid
    headers["Device-Type"] = "1";
    headers["Content-Type"] = "application/json";
  }

  String baseUrl = "";
  @override
  Future<bool> checkIfNameExists(PaymentMethod method) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }

  @override
  Future<PaymentMethod> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<PaymentMethodList>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  //temp solution
  @override
  Future<List<PaymentMethod>?> getAll() async {
    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/PaymentMethod/GetAll"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      List<PaymentMethod> list = List<PaymentMethod>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(PaymentMethod.fromJson(item));
      }

      // this.cash = list.firstWhere((f) => f.id == 1);

      return list;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  @override
  Future<List<PaymentMethodList>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<bool> save(PaymentMethod method) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<PaymentMethod> insertIfNotPaymentExists(int id, String name) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<PaymentMethod> methods) {
    throw UnimplementedError();
  }

  Future<bool> update(PaymentMethod method) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
