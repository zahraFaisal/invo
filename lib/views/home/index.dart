import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:invo_mobile/blocs/home_page/home_page_bloc.dart';
import 'package:invo_mobile/blocs/home_page/home_page_events.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/services/InvoCloud/webSocket_IO.dart';
import 'package:invo_mobile/views/blocProvider.dart';

import 'package:invo_mobile/views/home/portrait.dart';
import 'package:invo_mobile/views/home/landscape.dart';
import 'package:invo_mobile/widgets/layout/home_header.dart';
import 'package:invo_mobile/widgets/layout/home_header_portrait.dart';
import 'package:invo_mobile/widgets/user_setting/userSetting.dart';
import 'package:oktoast/oktoast.dart';
import '../../service_locator.dart';
import 'package:invo_mobile/widgets/notification_center/notification_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late HomePageBloc homePageBloc;

  @override
  void initState() {
    super.initState();
    if (!locator.isRegistered<HomePageBloc>()) {
      locator.registerSingleton<HomePageBloc>(HomePageBloc(BlocProvider.of<NavigatorBloc>(context)));

      locator.registerSingleton<MainBloc>(MainBloc(BlocProvider.of<NavigatorBloc>(context)));
    }

    homePageBloc = locator.get<HomePageBloc>();
  }

  @override
  void dispose() {
    super.dispose();
    if (homePageBloc != null) {
      homePageBloc.dispose();

      if (GetIt.instance.isRegistered<HomePageBloc>()) {
        GetIt.instance.unregister<HomePageBloc>();
      }
    }
  }

  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool mobileLayout = shortestSide < 500;
    SystemChrome.setEnabledSystemUIOverlays([]); //full screen
    if (mobileLayout) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      if (shortestSide <= 800) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
    }

    // orientation == Orientation.portrait ? HomePagePortrait() : HomePageLandscape()

    return SafeArea(
        child: Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: BlocProvider<HomePageBloc>(
          bloc: homePageBloc,
          child: Container(
            // Set background image of home page

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Wallpaper.jpg"),
                fit: BoxFit.fill,
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                orientation == Orientation.portrait ? HomeHeaderPortrait() : HomeHeader(),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: orientation == Orientation.portrait ? HomePagePortrait() : HomePageLandscape(),
                ),
                Container(
                  height: 50,
                  color: Colors.black38,
                  child: Container(
                    margin: EdgeInsets.only(left: 3, right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            homePageBloc.openDrawer();
                          },
                          child: Image.asset("assets/icons/cash_drawer.png"),
                        ),
                        StreamBuilder(
                            stream: homePageBloc.isINVOConnection.stream,
                            builder: (context, snapshot) {
                              if (homePageBloc.isINVOConnection.value == null) {
                                return SizedBox();
                              } else {
                                if (homePageBloc.isINVOConnection.value!) {
                                  return TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), child: NotificationPage());
                                        },
                                      );
                                    },
                                    child: StreamBuilder(
                                        stream: homePageBloc.notificationCount.stream,
                                        builder: (context, snapshot) {
                                          return Stack(
                                            children: [
                                              Icon(
                                                Icons.notifications_active_outlined,
                                                color: Colors.white,
                                                size: 45,
                                              ),
                                              (homePageBloc.notificationCount.value != 0)
                                                  ? Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: Container(
                                                        padding: EdgeInsets.all(1),
                                                        decoration: BoxDecoration(
                                                          color: Color.fromARGB(255, 78, 130, 169),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        constraints: BoxConstraints(
                                                          minWidth: 24,
                                                          minHeight: 24,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            homePageBloc.notificationCount.value.toString(),
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          );
                                        }),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }
                            }),
                        TextButton(
                          onPressed: () {
                            homePageBloc.serviceEventSink.add(SearchClick());
                          },
                          child: Image.asset("assets/icons/search.png"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
