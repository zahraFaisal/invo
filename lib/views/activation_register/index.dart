import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invo_mobile/blocs/activation_register/activation_register_bloc.dart';
import 'package:invo_mobile/views/activation_register/card_formatter.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import './landscape.dart';
import './portrait.dart';

class ActivationRegister extends StatefulWidget {
  ActivationRegister({Key? key}) : super(key: key);

  @override
  _ActivationRegisterState createState() => _ActivationRegisterState();
}

class _ActivationRegisterState extends State<ActivationRegister> {
  ActivationRegisterBloc? activationRegisterBloc;
  String? sKey;

  @override
  void initState() {
    super.initState();
    activationRegisterBloc = new ActivationRegisterBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  void dispose() {
    activationRegisterBloc?.dispose();
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
                child: orientation == Orientation.portrait ? ActivationRegisterPortrait() : ActivationRegisterLandScape(),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
