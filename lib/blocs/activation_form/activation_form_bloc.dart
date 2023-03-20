import 'dart:async';
import 'dart:convert';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/activation/certification.dart';
import 'package:invo_mobile/models/activation/restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:invo_mobile/models/wizard.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';

import '../blockBase.dart';
import './activation_form_event.dart';

import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;
import '../custom/decrypt.dart';
import 'package:cryptography/cryptography.dart' as CryptographyPack;
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ActivationFormBloc implements BlocBase {
  NavigatorBloc _navigationBloc;
  final _eventController = StreamController<ActivationFormEvent>.broadcast();
  Sink<ActivationFormEvent> get eventSink => _eventController.sink;
  final baseUrl = "https://licence.invopos.com/api";

  ActivationFormBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ActivationFormEvent event) {}

  Future<void> saveActivation(Restaurant restaurant) async {
    // try {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var deviceId = prefs.getString("deviceId");
    //   deviceId = "${deviceId}";
    //   Certification certification = new Certification();
    //   certification.restaurant = restaurant;
    //   certification.HWID = deviceId;
    //   Map<String, String> headers = new Map<String, String>();
    //   headers["Content-Type"] = "application/json";

    //   final response = await http.post(
    //     Uri.parse('${baseUrl}/registerDemoLiteLicense'),
    //     headers: headers,
    //     body: jsonEncode(certification.toMap()),
    //   );

    //   RegExp regExp = new RegExp(r"^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$");
    //   if (regExp.hasMatch(response.body)) {
    //     var obj = utf8.decode(base64.decode(response.body));
    //     var temp = json.decode(obj);
    //     Decrypt decrypt = Decrypt(value: temp['value'], iv: temp['iv']);
    //     var data = decrypt.decryptData();
    //     decrypt.saveFile();
    //     if (data.contains('{') && data.contains('}')) {
    //       data = data.substring(data.indexOf('{'), data.lastIndexOf('}') + 1);
    //       locator.registerSingleton<ConnectionRepository>(new SqliteRepository());
    //       ConnectionRepository connection = locator.get<ConnectionRepository>();
    //       if (await connection.checkDatabaseIfExist()!) {
    //         _navigationBloc.navigatorSink.add(NavigateToActivationHomePage());
    //       } else {
    //         _navigationBloc.navigatorSink.add(NavigateToWizardPage());
    //       }
    //     }
    //   } else {
    //     bool resault = await locator.get<DialogService>().showDialog("Error", response.body.toString(), okButton: "ok");
    //   }
    // } catch (e) {
    //   bool resault = await locator.get<DialogService>().showDialog("Error", e.toString(), okButton: "ok");
    // }
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/licence.txt'; // 3

    return filePath;
  }

  @override
  void dispose() {
    _eventController.close();
    // TODO: implement dispose
  }
}
