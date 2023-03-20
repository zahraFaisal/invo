import 'dart:io';

import 'package:android_plugin/android_plugin_method_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/views/connection/connect.dart';
import 'package:invo_mobile/views/connection/invo_connection.dart';
import 'package:invo_mobile/views/dialogManager.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:invo_mobile/widgets/translation/application.dart';
import 'package:oktoast/oktoast.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'blocs/navigator/navigator_bloc.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = new MyHttpOverrides();
  // InAppPurchaseConnection.enablePendingPurchases();
  setupLocator();
  runApp(MyApp());
//   WidgetsFlutterBinding.ensureInitialized();
// // Must add this line.
//   await windowManager.ensureInitialized();

// // Use it only after calling `hiddenWindowAtLaunch`
//   windowManager.waitUntilReadyToShow().then((_) async {
// // Hide window title bar
//     await windowManager.setFullScreen(true);
//     await windowManager.center();
//     await windowManager.show();
//     await windowManager.setSkipTaskbar(false);
//   });
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
  MyApp();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late String _deviceId;

  late SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState() {
    super.initState();

    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
    initPlatformState();

    ///
    /// Let's save a pointer to this method, should the user wants to change its language
    /// We would then call: applic.onLocaleChanged(new Locale('en',''));
    ///
    applic.onLocaleChanged = onLocaleChange;
    locator.registerSingleton<NavigatorBloc>(new NavigatorBloc(navigatorKey: navigatorKey));
  }

  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("deviceId", deviceId!);
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _deviceId = deviceId;
    //   print("deviceId->$_deviceId");
    // });
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigatorBloc>(
      bloc: locator.get<NavigatorBloc>(),
      child: OKToast(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primaryColor: const Color(0xFF3F454E),
          ),
          title: "InvoPOS Mobile",
          debugShowCheckedModeBanner: false,
          //theme: ThemeData(primarySwatch: Colors.black),
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
          builder: (context, widget) => Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(
                child: widget!,
              ),
            ),
          ),
          home: InvoConnectionPage(null),
        ),
      ),
    );
  }
}
