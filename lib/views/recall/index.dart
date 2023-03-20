import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_event.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_state.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/service_locator.dart';

import 'package:invo_mobile/views/recall/portrait.dart';
import 'package:invo_mobile/views/recall/landscape.dart';
import 'package:invo_mobile/widgets/discount/discount_list.dart';
import 'package:invo_mobile/widgets/pay_panel/pay_panel.dart';
import 'package:invo_mobile/widgets/surcharge/surcharge_list.dart';

import '../blocProvider.dart';

class RecallPage extends StatefulWidget {
  final Service? service;
  final bool showTableSelections;

  const RecallPage({
    Key? key,
    this.service,
    this.showTableSelections = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecallPageState();
  }
}

class _RecallPageState extends State<RecallPage> with WidgetsBindingObserver {
  late RecallPageBloc recallPageBloc;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    locator.registerSingleton<RecallPageBloc>(RecallPageBloc(BlocProvider.of<NavigatorBloc>(context), service: widget.service));

    recallPageBloc = locator.get<RecallPageBloc>();
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
          child: BlocProvider<RecallPageBloc>(
            bloc: recallPageBloc,
            child: orientation == Orientation.portrait ? const RecallPageProtrait() : const RecallPageLandscape(),
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
    WidgetsBinding.instance.removeObserver(this);
    locator.unregister<RecallPageBloc>();
  }
}
