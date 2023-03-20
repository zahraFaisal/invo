import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/customer_page/customer_page_bloc.dart';
import 'package:invo_mobile/views/customer/portrait.dart';

import '../../service_locator.dart';
import '../blocProvider.dart';
import 'landsacape.dart';

class CustomerPage extends StatefulWidget {
  CustomerPage({Key? key}) : super(key: key);

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late CustomerPageBloc customerPageBloc;

  @override
  void initState() {
    super.initState();
    customerPageBloc = locator.get<CustomerPageBloc>();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: SafeArea(
          child: Container(
            // Set background image of home page

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Wallpaper.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: BlocProvider<CustomerPageBloc>(
              bloc: customerPageBloc,
              child: orientation == Orientation.portrait ? CustomerPageProtrait() : CustomerPageLandscape(),
            ),
          ),
        ),
      ),
    );
  }
}
