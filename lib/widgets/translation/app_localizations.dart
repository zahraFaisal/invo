import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'application.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Map<String, String>? _localizedString;

  // Future<bool> load() async{
  //   String jsonString = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');

  //   Map<String,dynamic> jsonMap = jsonDecode(jsonString);

  //   _localizedString = jsonMap.map((key,value){
  //     return MapEntry(key,value.toString());
  //   });

  //   return true;
  // }

  static Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations translations = new AppLocalizations(locale);
    String jsonString = await rootBundle.loadString("assets/i18n/${locale.languageCode}.json");

    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    _localizedString = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return translations;
  }

  String translate(String key) {
    if (_localizedString![key] == null) {
      return "";
    }
    return (_localizedString![key])!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return applic.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

class SpecificLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale? overriddenLocale;

  const SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(overriddenLocale!);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;
}
