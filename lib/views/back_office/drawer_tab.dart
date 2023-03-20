import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:invo_mobile/blocs/back_office/backoffice/backoffice_bloc.dart';
import 'package:invo_mobile/blocs/back_office/backoffice/backoffice_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/helpers/priviligers.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class DrawerTab extends StatefulWidget {
  static String? selectedMenu;
  static DrawerTab? drawerTab;
  factory DrawerTab.singleton() {
    drawerTab ??= DrawerTab();
    return drawerTab!;
  }

  DrawerTab();

  @override
  _DrawerTabState createState() => _DrawerTabState();
}

class _DrawerTabState extends State<DrawerTab> {
  late BackOfficeBloc backOfficeBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backOfficeBloc = locator.get<BackOfficeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blueGrey[900],
        width: 170,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  width: 50,
                  child: Image(
                    image: AssetImage('assets/icons/logo-2.png'),
                  )),
            ),
            Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                  color: Colors.blueGrey[900],
                ),
                width: 100,
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          DrawerTab.selectedMenu = "Dashboard";
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.dashboard,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("Dashboard"),
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    DrawerTab.selectedMenu == "Dashboard"
                        ? Align(
                            alignment: Alignment(1.15, 0),
                            child: CustomPaint(
                              size: Size(20, 20),
                              painter: TrianglePainter(strokeColor: Colors.white, paintingStyle: PaintingStyle.fill),
                            ),
                          )
                        : SizedBox()
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                  color: Colors.blueGrey[900],
                ),
                width: 100,
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          DrawerTab.selectedMenu = "MenuItem";
                          Navigator.pushReplacementNamed(context, '/menuItems');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.restaurant,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Menu Item'),
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    DrawerTab.selectedMenu == "MenuItem"
                        ? Align(
                            alignment: Alignment(1.15, 0),
                            child: CustomPaint(
                              size: Size(20, 20),
                              painter: TrianglePainter(strokeColor: Colors.white, paintingStyle: PaintingStyle.fill),
                            ),
                          )
                        : SizedBox()
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                  color: Colors.blueGrey[900],
                ),
                width: 100,
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          DrawerTab.selectedMenu = "Employees";
                          Navigator.pushReplacementNamed(context, '/employees');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.people,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Employee'),
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    DrawerTab.selectedMenu == "Employees"
                        ? Align(
                            alignment: Alignment(1.15, 0),
                            child: CustomPaint(
                              size: Size(20, 20),
                              painter: TrianglePainter(strokeColor: Colors.white, paintingStyle: PaintingStyle.fill),
                            ),
                          )
                        : SizedBox()
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                  color: Colors.blueGrey[900],
                ),
                width: 100,
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          DrawerTab.selectedMenu = "Reports";
                          Navigator.pushReplacementNamed(context, '/reports');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.description,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Report'),
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    DrawerTab.selectedMenu == "Reports"
                        ? Align(
                            alignment: Alignment(1.15, 0),
                            child: CustomPaint(
                              size: Size(20, 20),
                              painter: TrianglePainter(strokeColor: Colors.white, paintingStyle: PaintingStyle.fill),
                            ),
                          )
                        : SizedBox()
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                  color: Colors.blueGrey[900],
                ),
                width: 100,
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          DrawerTab.selectedMenu = "Settings";
                          Navigator.pushReplacementNamed(context, '/settings');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Configuration'),
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    DrawerTab.selectedMenu == "Settings"
                        ? Align(
                            alignment: Alignment(1.15, 0),
                            child: CustomPaint(
                              size: Size(20, 20),
                              painter: TrianglePainter(strokeColor: Colors.white, paintingStyle: PaintingStyle.fill),
                            ),
                          )
                        : SizedBox()
                  ],
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                  color: Colors.blueGrey[900],
                ),
                width: 100,
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          DrawerTab.selectedMenu = "Dashboard";
                          DrawerTab.drawerTab = null;
                          backOfficeBloc.eventSink.add(BackToPos());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.tv,
                              size: 24,
                              color: Colors.white,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Back to Pos'),
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                color: Colors.blueGrey[900],
              ),
              width: 100,
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () async {
                  Privilege priv = new Privilege();
                  if (await priv.forceLogin(Privilages.Exit_Security)) {
                    bool resault = await locator
                        .get<DialogService>()
                        .showDialog(AppLocalizations.of(context)!.translate("Database Backup"), AppLocalizations.of(context)!.translate("Do You Want to Backup your Database?"), okButton: AppLocalizations.of(context)!.translate("Yes"), cancelButton: AppLocalizations.of(context)!.translate("No"));
                    if (resault) {
                      SqliteRepository connection = locator.get<ConnectionRepository>() as SqliteRepository;

                      if (await connection.dailyBackupDB()) {
                        exit(0);
                      }
                    } else {
                      exit(0);
                    }
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      size: 24,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('Exit'),
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 3, color: Colors.white)),
                color: Colors.blueGrey[900],
              ),
              width: 100,
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  backOfficeBloc.eventSink.add(ResetDatabase());
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.delete_forever,
                      size: 24,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('Reset Database'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y / 2)
      ..lineTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(0, y / 2);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor || oldDelegate.paintingStyle != paintingStyle || oldDelegate.strokeWidth != strokeWidth;
  }
}
