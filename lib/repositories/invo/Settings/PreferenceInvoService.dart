import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPreferenceService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:invo_mobile/models/custom/messages.dart';

class PreferenceInvoService implements IPreferenceService {
  late String ip;
  late String deviceId;
  late Map<String, String> headers;
  loadPerf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("Invo_IP")!;
    deviceId = prefs.getString("DeviceID")!;
    baseUrl = "http://" + "$ip:8081";
    headers = new Map<String, String>();
    headers["DeviceID"] = deviceId; // this.device.uuid
    headers["Device-Type"] = "1";
    headers["Content-Type"] = "application/json";
  }

  String baseUrl = "";

  @override
  Future<Preference>? get() {
    // TODO: implement get
    return null;
  }

  @override
  Future<bool> save(Preference preference) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationMessage>?>? getAllNotifications() async {
    await loadPerf();

    final response = await http.get(Uri.parse("$baseUrl/Preference/GetAllNotifications"), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      //print(json.decode(response.body));
      // If server returns an OK response, parse the JSON.
      List<NotificationMessage> list = List<NotificationMessage>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(NotificationMessage.fromJson(item));
      }

      return list;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  @override
  Future<bool> deleteAllNotification() async {
    final response = await http
        .post(Uri.parse("$baseUrl/Preference/DeleteAllNotification"), headers: this.headers)
        .timeout(Duration(seconds: 10))
        .catchError((error) {
      print(error);
    });

    if (response == null) {
      return false;
    }

    if (response.statusCode == 200) {
      print(response.body);
      return true;

      // If server returns an OK response, parse the JSON.
    } else {
      print(response.body);
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  @override
  Future<bool> deleteNotification(id) async {
    final response = await http
        .post(Uri.parse("$baseUrl/Preference/DeleteNotification/" + id.toString()), headers: this.headers)
        .timeout(Duration(seconds: 10))
        .catchError((error) {
      print(error);
    });

    if (response == null) {
      return false;
    }

    if (response.statusCode == 200) {
      print(response.body);
      return true;

      // If server returns an OK response, parse the JSON.
    } else {
      print(response.body);
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  @override
  saveLastUpdateTimeForCloud() {
    // TODO: implement saveLastUpdateTimeForCloud
    throw UnimplementedError();
  }
}
