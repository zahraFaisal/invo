import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/activation_home/activation_home_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';

import '../../service_locator.dart';
import '../blocProvider.dart';
import 'landscape.dart';
import 'portrait.dart';

class ActivationHome extends StatefulWidget {
  ActivationHome({Key? key}) : super(key: key);

  @override
  _ActivationHomeState createState() => _ActivationHomeState();
}

class _ActivationHomeState extends State<ActivationHome> {
  ActivationHomeBloc? activationHomeBloc;

  @override
  void initState() {
    super.initState();
    locator.registerSingleton(ActivationHomeBloc(BlocProvider.of<NavigatorBloc>(context)));

    activationHomeBloc = locator.get<ActivationHomeBloc>();
  }

  @override
  void dispose() {
    activationHomeBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
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
              Expanded(
                child: orientation == Orientation.portrait ? ActivationHomePortrait() : ActivationHomeLandscape(),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
