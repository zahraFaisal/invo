import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/dinein_page/dinein_page_bloc.dart';
import 'package:invo_mobile/blocs/dinein_page/dinein_page_events.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/views/dine_in/widgets/section_floor.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/layout/header_landscape.dart';
import 'package:invo_mobile/widgets/layout/header_portrait.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../service_locator.dart';
import '../blocProvider.dart';

class DineInPage extends StatefulWidget {
  final bool selectTable;
  DineInPage(this.selectTable);
  @override
  State<StatefulWidget> createState() {
    return _DineInPageState();
  }
}

class _DineInPageState extends State<DineInPage> with SingleTickerProviderStateMixin {
  late DineInPageBloc dineInPageBloc;
  int _tabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    locator.registerSingleton<DineInPageBloc>(DineInPageBloc(BlocProvider.of<NavigatorBloc>(context), widget.selectTable));

    dineInPageBloc = locator.get<DineInPageBloc>();
    _tabController = TabController(vsync: this, length: dineInPageBloc.dineInGroups!.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locator.unregister<DineInPageBloc>();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabsHeader = List<Widget>.empty(growable: true);
    List<Widget> tabsContent = List<Widget>.empty(growable: true);

    for (var item in dineInPageBloc.dineInGroups!) {
      tabsHeader.add(Tab(
        child: Container(width: 120, child: Center(child: Text(item.name))),
      ));

      tabsContent.add(SectionFloor(
          dineInPageBloc: dineInPageBloc,
          tables: item.tables!,
          type: MediaQuery.of(context).orientation == Orientation.landscape ? FloorType.positionView : FloorType.gridView));
    }

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
            child: BlocProvider<DineInPageBloc>(
              bloc: dineInPageBloc,
              child: Column(
                children: <Widget>[
                  MediaQuery.of(context).orientation == Orientation.landscape ? HeaderLandscape() : Header(),
                  Container(
                      height: 45,
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // FlatButton(
                          //   child: Text(
                          //     "<",
                          //     style: TextStyle(fontSize: 40, color: Colors.white),
                          //   ),
                          //   onPressed: () {
                          //     if (_tabController.index == 0) return;
                          //     _tabIndex = _tabController.index - 1;
                          //     _tabController.animateTo(_tabIndex);
                          //   },
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: TabBar(
                                isScrollable: true,
                                controller: _tabController,
                                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.white,
                                tabs: tabsHeader,
                              ),
                            ),
                          ),
                          // FlatButton(
                          //   child: Text(
                          //     ">",
                          //     style: TextStyle(fontSize: 40, color: Colors.white),
                          //   ),
                          //   onPressed: () {
                          //     if (_tabController.index + 1 == _tabController.length)
                          //       return;
                          //     _tabIndex = _tabController.index + 1;
                          //     _tabController.animateTo(_tabIndex);
                          //   },
                          // )
                        ],
                      )),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(color: Theme.of(context).primaryColor, width: 5),
                          left: BorderSide(color: Theme.of(context).primaryColor, width: 5),
                          bottom: BorderSide(color: Theme.of(context).primaryColor, width: 5),
                        ),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        children: tabsContent,
                      ),
                    ),
                  ),
                  controlButtons(),
                  // FooterLandscape()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget controlButtons() {
    return Container(
      color: Colors.white,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1),
            child: SizedBox(
              height: 50,
              width: 150,
              child: PrimaryButton(
                text: AppLocalizations.of(context)!.translate('Back'),
                onTap: () {
                  dineInPageBloc.eventSink.add(DineInPageGoBack());
                },
              ),
            ),
          ),
          dineInPageBloc.setteldOrders == true
              ? Padding(
                  padding: EdgeInsets.all(1),
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: PrimaryButton(
                      isEnabled: !dineInPageBloc.selectTable,
                      text: AppLocalizations.of(context)!.translate('Paid Orders'),
                      onTap: () {
                        dineInPageBloc.eventSink.add(GoToRecallPage());
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
