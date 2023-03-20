import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invo_mobile/views/back_office/Employee/role/list.dart';
import 'package:invo_mobile/views/back_office/drawer_tab.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'employee/list.dart';

class EmployeeTab extends StatefulWidget {
  EmployeeTab({Key? key}) : super(key: key);

  @override
  _EmployeeTabState createState() => _EmployeeTabState();
}

class _EmployeeTabState extends State<EmployeeTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  late Orientation orientation;

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return Scaffold(
        backgroundColor: Colors.white,
        drawer: DrawerTab.singleton(),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text(
            AppLocalizations.of(context)!.translate('Employee'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        body: SafeArea(child: body()),
      );
    } else {
      return Scaffold(
          body: Container(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        DrawerTab.singleton(),
        Expanded(flex: 3, child: body()),
      ])));
    }
  }

  Widget body() {
    return Container(
      color: Colors.blueGrey[900],
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 22),
            controller: _tabController,
            tabs: <Widget>[
              Container(
                width: 120,
                height: 80,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Employee'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 120,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Role'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              EmployeesListPage(),
              RolesListPage(),
            ],
          ),
        ),
      ]),
    );
  }
}
