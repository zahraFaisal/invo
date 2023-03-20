import 'dart:convert';
import 'dart:io';

import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/interface/Settings/ITerminalService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TerminalInvoService implements ITerminalService {
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
  Future<Terminal?> save(Terminal terminal) async {
    print("save terminal");
    try {
      await loadPerf();
      final response = await http
          .post(Uri.parse("$baseUrl/Terminal/Save"), body: jsonEncode(terminal.toJson()), headers: this.headers)
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

        terminal = Terminal.fromJson(json.decode(response.body));
        return terminal;
      } else {
        print("error");
        return null;
      }
    } on SocketException {
      return null;
    }
  }
}
