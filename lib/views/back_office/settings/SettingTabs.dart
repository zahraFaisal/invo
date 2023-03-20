import 'package:flutter/material.dart';
import 'package:invo_mobile/views/back_office/settings/cloud/form.dart';
import 'package:invo_mobile/views/back_office/settings/payment_method/list.dart';
import 'package:invo_mobile/views/back_office/settings/preferences/form.dart';
import 'package:invo_mobile/views/back_office/settings/price_managment/list.dart';
import 'package:invo_mobile/views/back_office/settings/services/form.dart';
import 'package:invo_mobile/views/back_office/settings/import_export/form.dart';
import 'package:invo_mobile/views/back_office/settings/table_builder/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../drawer_tab.dart';
import 'menu_builder/form.dart';

class SettingTabs extends StatefulWidget {
  SettingTabs({Key? key}) : super(key: key);

  @override
  _SettingTabsState createState() => _SettingTabsState();
}

class _SettingTabsState extends State<SettingTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 7);
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
            AppLocalizations.of(context)!.translate('Settings'),
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
                width: 150,
                height: 80,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Preferences'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 80,
                child: Center(
                  child: Text(
                    'Invo Cloud',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 80,
                child: Center(
                  child: Text(
                    'Export/Import',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 80,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Services'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 80,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Payment Method'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 80,
                child: Center(
                  child: Text(AppLocalizations.of(context)!.translate('Price Management'), textAlign: TextAlign.center),
                ),
              ),
              Container(
                width: 150,
                height: 80,
                child: Center(
                  child: Text(AppLocalizations.of(context)!.translate('Table Builder'), textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              PreferencesForm(),
              CloudForm(),
              ImportExportForm(),
              ServicesForm(),
              PaymentMethodListPage(),
              PriceManagmentListPage(),
              TableBuilder(),
            ],
          ),
        ),
      ]),
    );
  }
}
