import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:invo_mobile/blocs/back_office/backoffice/backoffice_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/back_office/drawer_tab.dart';
import 'package:invo_mobile/views/back_office/reports/ReportTab.dart';
import 'package:invo_mobile/views/back_office/settings/SettingTabs.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:invo_mobile/widgets/translation/application.dart';
import 'package:oktoast/oktoast.dart';
import 'Employee/employeeTab.dart';
import 'Menu_items/MenuTabs.dart';
import 'dashboard/landscape.dart';
import 'dashboard/portrait.dart';

class MainSettings extends StatefulWidget {
  @override
  _MainSettingsState createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  late SpecificLocalizationDelegate _localeOverrideDelegate;
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    String? lang = locator.get<ConnectionRepository>().terminal!.getLangauge();
    Locale locale;
    if (lang == "" || lang == "null" || lang == null) {
      locale = new Locale('en');
    } else {
      locale = new Locale(lang);
    }
    _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    applic.onLocaleChanged = onLocaleChange;

    locator.registerSingleton<BackOfficeBloc>(new BackOfficeBloc(BlocProvider.of<NavigatorBloc>(context)));
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  void dispose() {
    super.dispose();
    locator.unregister<BackOfficeBloc>();
    DrawerTab.drawerTab = null;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Settings',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color(0xFF3F454E),
          ),
          initialRoute: '/',
          navigatorKey: _navigator,
          supportedLocales: applic.supportedLocales(),
          localizationsDelegates: [
            _localeOverrideDelegate,
            GlobalMaterialLocalizations.delegate,
            //GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedocals) {
            for (var supportedocal in supportedocals) {
              if (supportedocal.languageCode == locale!.languageCode) {
                return supportedocal;
              }
            }

            return supportedocals.first;
          },
          routes: {
            '/': (context) => OrientationBuilder(builder: (context, orientation) {
                  if (orientation == Orientation.landscape) {
                    return DashBoardLandscape();
                  } else {
                    return DashBoardPortrait();
                  }
                }),
            '/menuItems': (context) => MenuTabs(),
            '/employees': (context) => EmployeeTab(),
            '/settings': (context) => SettingTabs(),
            '/reports': (context) => ReportTab(),
          }),
    );
  }
}
