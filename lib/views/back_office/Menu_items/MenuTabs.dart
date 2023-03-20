import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:invo_mobile/views/back_office/Menu_items/menu_category/list.dart';
import 'package:invo_mobile/views/back_office/Menu_items/menu_items/list.dart';
import 'package:invo_mobile/views/back_office/Menu_items/price_labels/list.dart';
import 'package:invo_mobile/views/back_office/Menu_items/surcharge/list.dart';
import 'package:invo_mobile/views/back_office/settings/menu_builder/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../drawer_tab.dart';
import 'discount/list.dart';
import 'menu_modifier/list.dart';

class MenuTabs extends StatefulWidget {
  MenuTabs({Key? key}) : super(key: key);

  @override
  _MenuTabsState createState() => _MenuTabsState();
}

class _MenuTabsState extends State<MenuTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 7);
    _tabController.addListener(() {
      print(_tabController.index);
    });
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
            AppLocalizations.of(context)!.translate('Menu Items'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        body: content(),
      );
    } else {
      return Scaffold(
          body: Container(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        DrawerTab.singleton(),
        Expanded(
          flex: 5,
          child: content(),
        )
      ])));
    }
  }

  Widget content() {
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
                    AppLocalizations.of(context)!.translate('Menu Builder'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 80,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Menu Item'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 120,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Menu Modifier'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 120,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Menu Category'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 120,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Prices'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 120,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Discount'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 120,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Surcharge'),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              MenuBuilderForm(),
              MenuItemsListPage(),
              MenuModifierListPage(),
              MenuCategoryListPage(),
              PriceLabelListPage(),
              DiscountListPage(),
              SurchargeListPage(),
            ],
          ),
        ),
      ]),
    );
  }
}
