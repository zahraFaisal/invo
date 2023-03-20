import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import 'package:invo_mobile/blocs/main/main_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/global.dart';
import 'package:invo_mobile/views/back_office/dashboard/landscape.dart';
import 'package:invo_mobile/views/back_office/dashboard/portrait.dart';
import 'package:invo_mobile/views/back_office/settings.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:invo_mobile/models/cashier.dart';

import '../../service_locator.dart';

class UserSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserSettingState();
  }
}

class _UserSettingState extends State<UserSetting> {
  final GlobalKey _userMenuKey = new GlobalKey();

  late MainBloc mainBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = locator.get<MainBloc>();

    mainBloc.userSettings.stream.listen((open) {
      dynamic state = _userMenuKey.currentWidget;
      if (state != null) state.onTap();
    });
  }

  @override
  void dispose() {
    mainBloc.userSettings.dispose();
  }

  RelativeRect buttonMenuPosition(BuildContext c) {
    final RenderBox bar = c.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(c)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.bottomRight(Offset.zero), ancestor: overlay),
        bar.localToGlobal(bar.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }

  @override
  Widget build(BuildContext context) {
    NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    return InkWell(
      key: _userMenuKey,
      onTap: () {
        if (mainBloc.employeeName.value == "") {
          mainBloc.eventSink.add(LogIn());
        } else {
          showMenu(context: context, position: buttonMenuPosition(_userMenuKey.currentContext!), items: <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
                height: 60,
                child: Container(
                    width: 500,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            mainBloc.eventSink.add(GoToTerminalSettings());
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(7.0),
                              ),
                            ),
                            child: Center(
                              child: Text(AppLocalizations.of(context)!.translate('Terminal Settings'),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                            ),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            mainBloc.eventSink.add(ChangeConnection());
                          },
                          child: Container(
                            height: 60,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(7.0),
                              ),
                            ),
                            child: Center(
                              child: Text(AppLocalizations.of(context)!.translate("Change Connection"),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                            ),
                          ),
                        )),
                      ],
                    ))),
            PopupMenuItem<int>(
                height: 60,
                child: Container(
                    width: 500,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder(
                            stream: this.mainBloc.authCashier.stream,
                            builder: (context, snapshot) {
                              return Expanded(
                                  child: InkWell(
                                onTap: () {
                                  if (this.mainBloc.authCashier.value == null)
                                    mainBloc.eventSink.add(GoToCashierPage());
                                  else if (this.mainBloc.authCashier.value!.cashier_out == null) mainBloc.eventSink.add(GoToCashierPage());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: this.mainBloc.authCashier.value == null
                                        ? Theme.of(context).primaryColor
                                        : (this.mainBloc.authCashier.value!.cashier_out == null ? Theme.of(context).primaryColor : Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(AppLocalizations.of(context)!.translate('Cashier In'),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                                  ),
                                ),
                              ));
                            }),
                        StreamBuilder(
                            stream: this.mainBloc.authCashier.stream,
                            builder: (context, snapshot) {
                              return Expanded(
                                  child: InkWell(
                                onTap: () {
                                  if (this.mainBloc.authCashier.value!.cashier_out != null) mainBloc.eventSink.add(GoToCashierPage());
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: this.mainBloc.authCashier.value != null
                                        ? (this.mainBloc.authCashier.value!.cashier_out != null ? Theme.of(context).primaryColor : Colors.grey)
                                        : Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(AppLocalizations.of(context)!.translate("Cashier Out"),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                                  ),
                                ),
                              ));
                            }),
                      ],
                    ))),
            PopupMenuItem<int>(
              height: 60,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          mainBloc.eventSink.add(GoToDailySalesReport());
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7.0),
                            ),
                          ),
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.translate('Daily Sales Report'),
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        mainBloc.eventSink.add(GoToCashierReport());
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(7.0),
                          ),
                        ),
                        child: Center(
                          child: Text(AppLocalizations.of(context)!.translate('Cashier History'),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            PopupMenuItem<int>(
                height: 60,
                child: Container(
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();

                              if (navigatorBloc != null && navigatorBloc.currentPage == "HomePage") {
                                mainBloc.eventSink.add(LogOut());
                              }
                            },
                            child: Container(
                              margin: mainBloc.isINVOConnection.value! ? EdgeInsets.only(right: 0) : EdgeInsets.only(right: 8),
                              height: 60,
                              decoration: BoxDecoration(
                                color:
                                    (navigatorBloc != null && navigatorBloc.currentPage == "HomePage") ? Theme.of(context).primaryColor : Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7.0),
                                ),
                              ),
                              child: Center(
                                child: Text(AppLocalizations.of(context)!.translate('Logout'),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                        mainBloc.isINVOConnection.value!
                            ? SizedBox()
                            : Expanded(
                                child: InkWell(
                                onTap: () {
                                  mainBloc.eventSink.add(GoToMainSettings());
                                  // NavigatorBloc navigatorBloc =
                                  //     BlocProvider.of<NavigatorBloc>(context);
                                  // Navigator.of(context)
                                  //     .push(new MaterialPageRoute(builder: (context) {
                                  //   return Settings();
                                  // }));
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(AppLocalizations.of(context)!.translate('Settings'),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 18)),
                                  ),
                                ),
                              )),
                      ],
                    ))),
          ]);
        }
      },
      child: Image.asset("assets/icons/profile_icon.png"),
    );
  }
}
