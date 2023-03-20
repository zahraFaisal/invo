import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_state.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/service_locator.dart';

import 'package:invo_mobile/views/pending/landscape.dart';
import 'package:invo_mobile/views/pending/portrait.dart';
import 'package:invo_mobile/widgets/discount/discount_list.dart';
import 'package:invo_mobile/widgets/pay_panel/pay_panel.dart';
import 'package:invo_mobile/widgets/surcharge/surcharge_list.dart';

import '../blocProvider.dart';

class PendingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PendingPageState();
  }
}

class _PendingPageState extends State<PendingPage> with WidgetsBindingObserver {
  late PendingPageBloc pendingPageBloc;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    locator.registerSingleton<PendingPageBloc>(PendingPageBloc(
      BlocProvider.of<NavigatorBloc>(context),
    ));

    pendingPageBloc = locator.get<PendingPageBloc>();
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
          child: BlocProvider<PendingPageBloc>(
            bloc: pendingPageBloc,
            child: orientation == Orientation.portrait ? PendingPagePprtrait() : PendingPageLandscape(),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("resumed");
    } else if (state == AppLifecycleState.inactive) {
      print("paused");
    } else if (state == AppLifecycleState.paused) {
      print("paused");
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    locator.unregister<PendingPageBloc>();
  }
}
