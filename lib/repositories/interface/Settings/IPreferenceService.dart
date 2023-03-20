import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/custom/messages.dart';

class IPreferenceService {
  Future<Preference>? get() {}
  Future<bool>? save(Preference preference) {}
  Future<List<NotificationMessage>?>? getAllNotifications() {}
  Future<bool>? deleteAllNotification() {}
  Future<bool>? deleteNotification(id) {}
  saveLastUpdateTimeForCloud() {}
}
