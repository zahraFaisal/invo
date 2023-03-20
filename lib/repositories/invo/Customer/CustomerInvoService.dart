import 'dart:convert';
import 'dart:io';

import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/interface/Customer/ICustomerService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class CustomerInvoService implements ICustomerService {
  String? ip;
  String? deviceId;
  Map<String, String>? headers;

  loadPerf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("Invo_IP");
    deviceId = prefs.getString("DeviceID");
    baseUrl = "http://" + "$ip:8081";
    headers = new Map<String, String>();
    headers!["DeviceID"] = deviceId!; // this.device.uuid
    headers!["Device-Type"] = "1";
    headers!["Content-Type"] = "application/json";
  }

  String baseUrl = "";

  //Customer/get/{id}
  @override
  Future<Customer?>? get(int id) async {
    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/Customer/get/" + id.toString()), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      return Customer.fromJson(json.decode(response.body));
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  @override
  Future<bool?>? saveIfNotExists(List<Customer> customers, List<PriceLabel> priceLabels) {}

  Future<Customer?> getByPhone(String phone) async {
    await loadPerf();
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/Customer/getByPhone/" + phone.toString()), headers: this.headers)
          .timeout(Duration(seconds: 10))
          .catchError((error) {
        print(error);
      });

      if (response == null) {
        //if (connection != null) connection(false);
        return null;
      }

      if (response.statusCode == 200) {
        if (response.body == "") {
          List<CustomerContact> contacts = List<CustomerContact>.empty(growable: true);
          contacts.add(CustomerContact(type: 1, contact: phone));
          return Customer(contacts: contacts, addresses: [], id_number: 0, name: '');
        }
        return Customer.fromJson(json.decode(response.body));

        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return null;
      }
    } on SocketException {
      return null;
    }
  }

  @override
  Future<Customer?> save(Customer customer) async {
    await loadPerf();
    final response = await http
        .post(Uri.parse("$baseUrl/Customer/Save"), body: jsonEncode(customer.toJson()), headers: this.headers)
        .timeout(Duration(seconds: 10))
        .catchError((error) {
      print(error);
    });

    if (response == null) {
      return null;
    }

    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      return Customer.fromJson(json.decode(response.body));

      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  //getAllCustomers/{filter}
  @override
  Future<List<CustomerList>?>? getAllCustomers(String _filter) async {
    if (_filter == "" || _filter == null) {
      _filter = "0";
    }

    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/Customer/getAllCustomers/" + _filter.toString()), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      List<CustomerList> list = List<CustomerList>.empty(growable: true);
      for (var item in json.decode(response.body)) {
        list.add(CustomerList.fromJson(item));
      }

      return list;
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  @override
  Future<List<Customer>?>? getAll() {}
}
