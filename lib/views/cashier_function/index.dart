import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/cashier_function/cashier_function_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/views/cashier_function/portrait.dart';

import '../../service_locator.dart';
import '../blocProvider.dart';
import 'landscape.dart';

class CashierFunction extends StatefulWidget {
  CashierFunction({Key? key}) : super(key: key);

  @override
  _CashierFunctionState createState() => _CashierFunctionState();
}

class _CashierFunctionState extends State<CashierFunction> {
  late CashierFunctionBloc customerPageBloc;

  @override
  void initState() {
    super.initState();
    customerPageBloc = CashierFunctionBloc(BlocProvider.of<NavigatorBloc>(context));
    locator.registerSingleton(customerPageBloc);
  }

  @override
  void dispose() {
    customerPageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    // orientation == Orientation.portrait ? HomePagePortrait() : HomePageLandscape()

    return SafeArea(
        child: Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Container(
          // Set background image of home page

          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Wallpaper.jpg"),
              fit: BoxFit.fill,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: orientation == Orientation.portrait ? CashierFunctionPortrait() : CashierFunctionLandscape(),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
