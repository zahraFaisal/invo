import 'package:invo_mobile/models/preference.dart';

abstract class PreferenceFormEvent {}

class SavePreference extends PreferenceFormEvent {
  Preference preference;
  SavePreference(this.preference);
}
