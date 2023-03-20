import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/views/order/landscape.dart';
import 'package:invo_mobile/views/order/portrait.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderPageState();
  }
}

class _OrderPageState extends State<OrderPage> {
  late OrderPageBloc orderPageBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderPageBloc = locator.get<OrderPageBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Container(
          child: BlocProvider<OrderPageBloc>(
            bloc: orderPageBloc,
            child: MediaQuery.of(context).orientation == Orientation.portrait ? OrderPagePortrait() : OrderPageLandscape(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locator.unregister<OrderPageBloc>();
  }
}
