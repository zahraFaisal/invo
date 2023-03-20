import 'package:invo_mobile/models/preference.dart';

abstract class PreferenceLoadState {}

class PreferenceIsLoading extends PreferenceLoadState {}

class PreferenceIsLoaded extends PreferenceLoadState {
  final Preference preference;
  PreferenceIsLoaded(this.preference);
}

class PreferenceIsSaving extends PreferenceLoadState {}

class PreferenceSaved extends PreferenceLoadState {
  final Preference preference;
  PreferenceSaved(this.preference);
}

class PreferenceError extends PreferenceLoadState {
  final String error;
  final Preference preference;
  PreferenceError(this.preference,this.error);
}
