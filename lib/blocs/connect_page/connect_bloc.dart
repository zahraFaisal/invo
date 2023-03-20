import 'dart:async';
import 'dart:convert';

import 'package:invo_mobile/blocs/connect_page/connect_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/models/activation/certification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blockBase.dart';
import '../custom/decrypt.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ConnectBloc implements BlocBase {
  final NavigatorBloc _navigationBloc;

  final _eventController = StreamController<ConnectPageEvent>.broadcast();
  Sink<ConnectPageEvent> get eventSink => _eventController.sink;

  ConnectBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ConnectPageEvent event) {
    if (event is ConnectToInvoPos) {
      _navigationBloc.navigatorSink.add(NavigateToInvoConnectionPage());
    } else if (event is ConnectToDatabase) {
      connectToDatabase();
    } else if (event is ConnectToDemoDatabase) {
    } else if (event is Restart) {
      _navigationBloc.navigatorSink.add(NavigateToConnectionPage());
    }
  }

  connectToDatabase() async {
    bool isFileValid = false;
    // bool isFileValid = true; //for testing

    //check file is valid ============
    Certification? certification = await getCertification();
    if (certification != null) isFileValid = await isValidLicence(certification);

    if (isFileValid) {
      _navigationBloc.navigatorSink.add(NavigateToDatabaseConnection());
    } else {
      _navigationBloc.navigatorSink.add(NavigateToActivationHomePage());
    }
  }

  getCertification() async {
    // String? value = await readFile();
    // if (value != null) {
    //   Certification? certification;
    //   final splitted = value.split(',');
    //   Decrypt decrypt = Decrypt(value: splitted[1], iv: splitted[0]);
    //   String data = (decrypt.decryptData()).toString();
    //   if (data.contains('{') && data.contains('}')) {
    //     data = data.substring(data.indexOf('{'), data.lastIndexOf('}') + 1);
    //     certification = Certification.fromMap(json.decode(data));
    //   }
    //   return certification;
    // } else
    //   return null;
  }

  Future<bool> isValidLicence(Certification certification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString("deviceId");
    deviceId = "${deviceId}";

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
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/licence.txt';

    return filePath;
  }

  Future<String?> readFile() async {
    final filePath = await getFilePath();
    final found = await File(filePath).exists();
    if (found) {
      File file = File(filePath); // 1
      String fileContent = await file.readAsString(); // 2
      return fileContent;
    }
    return null;
  }

  @override
  void dispose() {
    _eventController.close();
    // TODO: implement dispose
  }
}
