import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:invo_mobile/blocs/connect_page/connect_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/activation/certification.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './activation_register_event.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../blockBase.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import '../custom/decrypt.dart';

import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;

import 'package:cryptography/cryptography.dart' as CryptographyPack;

class ActivationRegisterBloc implements BlocBase {
  final baseUrl = "https://licence.invopos.com/api";
  final _eventController = StreamController<ActivationRegisterEvent>.broadcast();
  NavigatorBloc _navigationBloc;

  Sink<ActivationRegisterEvent> get eventSink => _eventController.sink;

  ActivationRegisterBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ActivationRegisterEvent event) {}

  Future<void> save(sKey) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final deviceId = prefs.getString("deviceId");
    // // Certification certification =
    // //     new Certification(HWID: deviceId, licence: sKey);
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String version = packageInfo.version;

    // Map<String, String> headers = new Map<String, String>();
    // headers["Content-Type"] = "application/json";

    // final response = await http.post(
    //   Uri.parse('${baseUrl}/checkLiteLicense'),
    //   headers: headers,
    //   body: jsonEncode({'SN': sKey, 'HWID': deviceId, 'Version': version}),
    // );

    // if (response.body == "") {
    //   //invalid code
    //   await locator.get<DialogService>().showDialog("Error", "Invalid code", okButton: "ok");
    // }
    // RegExp regExp = new RegExp(r"^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$");
    // if (regExp.hasMatch(response.body)) {
    //   var obj = utf8.decode(base64.decode(response.body));
    //   var temp = json.decode(obj);
    //   // Decrypt decrypt = Decrypt(value: temp['value'], iv: temp['iv']);
    //   // var data = decrypt.decryptData();
    //   var data = null;
    //   // var data = decrypt(temp['value'], temp['iv']);
    //   if (data == null) {
    //     await locator.get<DialogService>().showDialog("Error", "Invalid code", okButton: "ok");
    //   } else if (data.contains('{') && data.contains('}')) {
    //     decrypt.saveFile();
    //     data = data.substring(data.indexOf('{'), data.lastIndexOf('}') + 1);
    //     Certification certification = Certification.fromMap(json.decode(data));
    //     if (certification.restaurant == null) {
    //       //show resturant form
    //       _navigationBloc.navigatorSink.add(NavigateToActivationHomePage());
    //     } else {
    //       if (!await isValidLicence(certification)) {
    //         //show msg invalid serial number
    //         bool resault = await locator.get<DialogService>().showDialog("Error", "Invalid serial number", okButton: "ok");
    //       } else {
    //         //show the licence information
    //         bool resault = await locator.get<DialogService>().showDialog("licence information", "Device ID: ${certification.HWID} , licence: ${certification.licence}", okButton: "Done");

    //         locator.registerSingleton<ConnectionRepository>(new SqliteRepository());
    //         ConnectionRepository connection = locator.get<ConnectionRepository>();
    //         if (await connection.checkDatabaseIfExist()!) {
    //           _navigationBloc.navigatorSink.add(NavigateToActivationHomePage());
    //         } else {
    //           _navigationBloc.navigatorSink.add(NavigateToWizardPage());
    //         }
    //       }
    //     }
    //   } else {
    //     await locator.get<DialogService>().showDialog("Error", "Invalid code", okButton: "ok");
    //   }
    // } else {
    //   bool resault = await locator.get<DialogService>().showDialog("Error", response.body.toString(), okButton: "ok");
    //   // show response body as error msg
    // }
  }

  Future<bool> isValidLicence(Certification certification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString("deviceId");

    if (certification.HWID == deviceId) {
      if (certification.expire_at == null) {
        //"Licence is Active"
        return true;
      } else if (certification.expire_at!.compareTo(DateTime.now()) < 0) {
        //"Your licence has expired"
        return false;
      } else {
        //"Licence is Active"
        return true;
      }
    }

    return false;
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

// CBCBlockCipher cipher = new CBCBlockCipher(new AESFastEngine());
// ParametersWithIV<KeyParameter> params =
//     new ParametersWithIV<KeyParameter>(new KeyParameter(key), iv);
// PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>
//     paddingParams =
//     new PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
//         params, null);
// PaddedBlockCipherImpl paddingCipher =
//     new PaddedBlockCipherImpl(new PKCS7Padding(), cipher);
// paddingCipher.init(false, paddingParams);
// return paddingCipher.process(ciphertext);
