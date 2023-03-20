import 'dart:async';

import 'package:invo_mobile/blocs/back_office/backoffice/backoffice_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:invo_mobile/blocs/blockBase.dart';
import '../../blockBase.dart';

class BackOfficeBloc implements BlocBase {
  final NavigatorBloc _navigationBloc;

  final _eventController = StreamController<BackOfficePageEvent>.broadcast();
  Sink<BackOfficePageEvent> get eventSink => _eventController.sink;

  BackOfficeBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
  }

  Future<void> _mapEventToState(BackOfficePageEvent event) async {
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    AppLocalizations appLocalizations = await AppLocalizations.load(Locale(lang!));
    if (event is BackToPos) {
      locator.get<DialogService>().showLoadingProgressDialog();
      await locator.get<ConnectionRepository>().connect();
      locator.get<DialogService>().closeDialog();
      _navigationBloc.navigatorSink.add(NavigateToHomePage());
    } else if (event is ResetDatabase) {
      Privilege priv = new Privilege();
      if (await priv.forceLogin(Privilages.Exit_Security)) {
        SqliteRepository connection = locator.get<ConnectionRepository>() as SqliteRepository;
        bool resault = await locator.get<DialogService>().showDialog(
            appLocalizations.translate("Reset Database"), appLocalizations.translate("Are You Sure You Want To Reset Your Database?"),
            okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));
        if (resault) {
          bool resault2 = await locator.get<DialogService>().showDialog(
              appLocalizations.translate("Database Backup"), appLocalizations.translate("Do You Want to Backup your Database?"),
              okButton: appLocalizations.translate("Yes"), cancelButton: appLocalizations.translate("No"));
          if (resault2) {
            if (await connection.dailyBackupDB()) {
              await connection.resetData();
              _navigationBloc.navigatorSink.add(NavigateToConnectionPage());
            }
          } else {
            bool resault3 = await locator.get<DialogService>().showDialog(
                appLocalizations.translate("ARE YOU SURE?"), appLocalizations.translate("Your Data will be deleted"),
                okButton: appLocalizations.translate("Proceed"), cancelButton: appLocalizations.translate("Cancel"));
            if (resault3) {
              await connection.resetData();
              _navigationBloc.navigatorSink.add(NavigateToConnectionPage());
            }
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _eventController.close();
    // TODO: implement dispose
  }
}
