import 'dart:async';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/wizard.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/invo_connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blockBase.dart';
import '../property.dart';
import 'wizard_page_event.dart';

class WizardPageBloc extends BlocBase {
  final NavigatorBloc _navigationBloc;
  final _eventController = StreamController<WizardPageEvent>.broadcast();
  Sink<WizardPageEvent> get eventSink => _eventController.sink;
  Preference? preference;
  Property<Wizard> wizard = Property<Wizard>();
  WizardPageBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
    preference = locator.get<ConnectionRepository>().preference;
    wizard.sinkValue(Wizard());
  }

  @override
  void dispose() {
    _eventController.close();
    wizard.dispose();
    // TODO: implement dispose
  }

  void _mapEventToState(WizardPageEvent event) async {
    if (event is WizardPageGoBack) {
      _navigationBloc.navigatorSink.add(PopUp());
    } else if (event is WizardPageGoHome) {
      _navigationBloc.navigatorSink.add(NavigateToHomePage());
    } else if (event is WizardCreateDB) {
      SqliteRepository connection = locator.get<ConnectionRepository>() as SqliteRepository;
      locator.get<DialogService>().showLoadingProgressDialog();
      bool resault = await connection.initDatabaseWithData(event.wizard);

      if (resault) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("connectionType", "SQLLITE");
        locator.get<DialogService>().closeDialog();
        //_navigationBloc.navigateToMainSettingsPage();
        _navigationBloc.navigateToMenuBuilderPage(active: true);
      }
    }
  }

  String company_name_validation = "";
  String phone_validation = "";

  String admin_name_validation = "";
  String pass_code_validation = "";
  String symbol_validation = "";
  String dicamal_validation = "";

  Future<bool> asyncValidateFirstForm(Wizard wizard) async {
    company_name_validation = "";
    phone_validation = "";

    if (wizard.company_name == null || wizard.company_name == "") {
      company_name_validation = "Value must be Entered";
      return false;
    }

    if (wizard.phone == null || wizard.phone == "") {
      phone_validation = "Value must be Entered";
      return false;
    }

    return true;
  }

  Future<bool> asyncValidateSecondForm(Wizard wizard) async {
    admin_name_validation = "";
    pass_code_validation = "";

    if (wizard.admin_name == null || wizard.admin_name == "") {
      admin_name_validation = "Value must be Entered";
      return false;
    }

    if (wizard.pass_code == null || wizard.pass_code == "") {
      pass_code_validation = "Value must be Entered";
      return false;
    }

    return true;
  }

  Future<bool> asyncValidateFinalForm(Wizard wizard) async {
    company_name_validation = "";
    phone_validation = "";
    admin_name_validation = "";
    pass_code_validation = "";
    symbol_validation = "";
    dicamal_validation = "";
    if (wizard.symbol == null || wizard.symbol == "") {
      symbol_validation = "Value must be Entered";
      return false;
    }

    if (wizard.dicamal == null || wizard.dicamal.isNaN) {
      dicamal_validation = "Value must be Entered";
      return false;
    }

    if (wizard.company_name == null || wizard.company_name == "") {
      company_name_validation = "Value must be Entered";
      return false;
    }

    if (wizard.phone == null || wizard.phone == "") {
      phone_validation = "Value must be Entered";
      return false;
    }

    if (wizard.admin_name == null || wizard.admin_name == "") {
      admin_name_validation = "Value must be Entered";
      return false;
    }

    if (wizard.pass_code == null || wizard.pass_code == "") {
      pass_code_validation = "Value must be Entered";
      return false;
    }

    return true;
  }
}
