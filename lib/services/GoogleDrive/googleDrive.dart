import 'dart:io';

import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/custom/database_list.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/GoogleDrive/secureStorage.dart';
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

const _clientId = "457942643289-t60sf2fth6obphbqi1mt6e29hbhq9t10.apps.googleusercontent.com";
const _clientSecret = "yTiRjmtCxE49WjGg9UxhYnb4";
// const _scopes = [ga.DriveApi.DriveFileScope];

class GoogleDrive {
  // final storage = SecureStorage();
  // //Get Authenticated Http Client
  // Future<http.Client> getHttpClient() async {
  //   //Get Credentials

  //   var credentials = await storage.getCredentials();
  //   if (credentials == null) {
  //     //Needs user authentication
  //     var authClient = await clientViaUserConsent(
  //         ClientId(_clientId, _clientSecret), _scopes, (url) {
  //       //Open Url in Browser
  //       launch(url);
  //     });
  //     //Save Credentials
  //     await storage.saveCredentials(authClient.credentials.accessToken,
  //         authClient.credentials.refreshToken);
  //     return authClient;
  //   } else {
  //     //print(credentials["expiry"]);
  //     //Already authenticated
  //     return authenticatedClient(
  //         http.Client(),
  //         AccessCredentials(
  //             AccessToken(credentials["type"], credentials["data"],
  //                 DateTime.tryParse(credentials["expiry"])),
  //             credentials["refreshToken"],
  //             _scopes));
  //   }
  // }

  // //Upload File
  // Future upload(File file) async {
  //   //await storage.clear();
  //   var client = await getHttpClient();
  //   var drive = ga.DriveApi(client);
  //   print("Uploading file");
  //   var response = await drive.files.create(
  //       ga.File()..name = p.basename(file.absolute.path),
  //       uploadMedia: ga.Media(file.openRead(), file.lengthSync()));

  //   print("Result ${response.toJson()}");
  // }

  // clearCredentials() async {
  //   await storage.clear();
  // }

  // Future<void> download(String fName, String gdID, String directoryPath) async {
  //   var client = await getHttpClient();
  //   var drive = ga.DriveApi(client);
  //   ga.Media file = await drive.files
  //       .get(gdID, downloadOptions: ga.DownloadOptions.FullMedia);

  //   final saveFile = File(p.join(directoryPath, fName));
  //   List<int> dataStore = [];
  //   file.stream.listen((data) {
  //     dataStore.insertAll(dataStore.length, data);
  //   }, onDone: () async {
  //     print("Task Done");
  //     await saveFile.writeAsBytes(dataStore);
  //     print("File saved at ${saveFile.path}");
  //   }, onError: (error) {
  //     print("Some Error");
  //   });
  // }

  // Future<bool> dailyBackupUpdate() async {
  //   clearCredentials();
  //   bool isUpdated = false;
  //   bool isDone = false;
  //   var client = await getHttpClient();
  //   var drive = ga.DriveApi(client);

  //   var date = DateTime.now().month.toString() + DateTime.now().day.toString();

  //   var databasesFolderPath = await getDatabasesPath();

  //   var dbPath =
  //       p.join(databasesFolderPath, 'invopos_database_backup_' + date + '.db');
  //   locator.get<DialogService>().showLoadingProgressDialog();
  //   await drive.files.list(orderBy: "createdTime").then((value) async {
  //     if (value.files.length != 0) {
  //       for (var i = 0; i < value.files.length; i++) {
  //         var file = await drive.files
  //             .get(value.files[i].id, $fields: "id, name, createdTime");

  //         DateTime localDateTime = file.createdTime.toLocal();
  //         print(DateTime.now().difference(localDateTime).inDays);
  //         if (DateTime.now().difference(localDateTime).inDays >= 5) {
  //           if (value.files.length == 1) break;
  //           await drive.files.delete(file.id);
  //         }
  //         if (DateTime.now().difference(localDateTime).inDays >= 1) {
  //           if (isUpdated) break;

  //           // upload a copy
  //           await upload(await new File(
  //                   p.join(databasesFolderPath, "invopos_database.db"))
  //               .copy(dbPath));

  //           isUpdated = true;
  //           isDone = true;
  //         }

  //         print(
  //             "File ID:${file.id} File Name:${file.name} File Date: ${file.createdTime}");
  //       }
  //       isDone = true;
  //     } else {
  //       await upload(
  //           await new File(p.join(databasesFolderPath, "invopos_database.db"))
  //               .copy(dbPath));
  //       isDone = true;
  //     }
  //   }, onError: (e) {
  //     print(e);
  //     isDone = false;
  //   });
  //   locator.get<DialogService>().closeDialog();
  //   return isDone;
  // }

  // Future<List<DatabaseList>> listAllDB() async {
  //   clearCredentials();
  //   List<DatabaseList> list = [];
  //   var client = await getHttpClient();
  //   var drive = ga.DriveApi(client);
  //   try {
  //     drive.files.list(orderBy: "createdTime").then((value) async {
  //       if (value.files.length != 0) {
  //         for (var i = 0; i < value.files.length; i++) {
  //           var file = await drive.files
  //               .get(value.files[i].id, $fields: "id, name, createdTime");

  //           DateTime localDateTime = file.createdTime.toLocal();

  //           DatabaseList temp = new DatabaseList();
  //           temp.id = file.id;
  //           temp.name = file.name;
  //           temp.createdTime = localDateTime.toString();
  //           list.add(temp);
  //           print(
  //               "File ID:${file.id} File Name:${file.name} File Date: ${file.createdTime}");
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //   return list;
  // }
}
