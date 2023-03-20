import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';

class DatabaseConnectionBloc implements BlocBase {
  NavigatorBloc _navigationBloc;

  DatabaseConnectionBloc(this._navigationBloc) {
    if (locator.isRegistered<ConnectionRepository>()) locator.unregister<ConnectionRepository>();

    locator.registerSingleton<ConnectionRepository>(new SqliteRepository());

    connect();
  }

  connect() async {
    if (await locator.get<ConnectionRepository>().checkDatabaseIfExist()!) {
      bool resault = await locator.get<ConnectionRepository>().connect();
      if (resault) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("connectionType", "SQLLITE");
        _navigationBloc.navigatorSink.add(NavigateToHomePage());
      } else {
        //databasce is corupted (delete it)
        var sqliteRepository = new SqliteRepository();
        await sqliteRepository.deleteDatabse();

        _navigationBloc.navigatorSink.add(NavigateToConnectionPage());
      }
    } else {
      _navigationBloc.navigatorSink.add(NavigateToWizardPage());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
