import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/repositories/interface/Settings/IPreferenceService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';
import 'package:invo_mobile/models/custom/messages.dart';

class PreferenceService implements IPreferenceService {
  @override
  Future<Preference> get() async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> item = (await database!.query("preferences")).first;
    return Preference.fromMap(item);
  }

  saveLastUpdateTimeForCloud() async {
    final Database? database = await SqliteRepository().db;
    var date = new DateTime.now().toUtc().millisecondsSinceEpoch;
    var result = await database!.rawQuery("Update preferences Set [update_time] = $date Where [update_time] IS NULL");
  }

  @override
  Future<bool> save(Preference preference) async {
    final Database? database = await SqliteRepository().db;
    int result;
    result = await database!.insert('preferences', preference.toMap()!, conflictAlgorithm: ConflictAlgorithm.replace);

    return result > 0;
  }

  @override
  Future<List<NotificationMessage>?>? getAllNotifications() {
    // TODO: implement getAllNotifications
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteAllNotification() {
    // TODO: implement deleteAllNotification
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteNotification(id) {
    // TODO: implement deleteNotification
    throw UnimplementedError();
  }
}
