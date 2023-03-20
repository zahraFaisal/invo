import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:invo_mobile/blocs/back_office/dashboard_page/dash_board_page_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import '../drawer_tab.dart';
import 'charts/dailyincome.dart';
import 'charts/salesbyemployee.dart';
import 'charts/salesbytype.dart';

class DashBoardPortrait extends StatefulWidget {
  DashBoardPortrait({Key? key}) : super(key: key);

  @override
  _DashBoardPortraitState createState() => _DashBoardPortraitState();
}

late DashboardPageBloc dashboardPageBloc;

class _DashBoardPortraitState extends State<DashBoardPortrait> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardPageBloc = DashboardPageBloc(BlocProvider.of<NavigatorBloc>(context));

    // loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerTab.singleton(),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          AppLocalizations.of(context)!.translate('Dashboard'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: BlocProvider<DashboardPageBloc>(bloc: dashboardPageBloc, child: DashBoardTabPortrait()),
    );
  }
}

class DashBoardTabPortrait extends StatefulWidget {
  DashBoardTabPortrait({Key? key}) : super(key: key);

  @override
  _DashBoardTabPortraitState createState() => _DashBoardTabPortraitState();
}

class _DashBoardTabPortraitState extends State<DashBoardTabPortrait> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dashboardPageBloc.model.stream,
        builder: (context, snapshot) {
          if (dashboardPageBloc.model.value == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                                height: 80,
                                width: 120,
                                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[300]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Center(
                                        child: Text(Number.formatCurrency(dashboardPageBloc.model.value!.total_sale),
                                            style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                                    Center(
                                        child: Text(AppLocalizations.of(context)!.translate("Total Sale"),
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                              height: 80,
                              width: 120,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[300]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Center(
                                      child: Text(dashboardPageBloc.model.value!.total_order.toString(),
                                          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                                  Center(
                                      child: Text(AppLocalizations.of(context)!.translate("Total Order"),
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 400,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Text(
                                AppLocalizations.of(context)!.translate("Sales By Employee"),
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 10, 15, 20),
                                  padding: EdgeInsets.all(20),
                                  child: SalesByEmployeeChart.withSampleData(dashboardPageBloc.model.value!.employee_report!)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 400,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                AppLocalizations.of(context)!.translate("Sales By Type"),
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child:
                                    // PointsLineChart.withSampleData()
                                    SalesByTypeChart.withSampleData(dashboardPageBloc.model.value!.service_report!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 400,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(AppLocalizations.of(context)!.translate("Daily Income"),
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(20), child: DailyIncomeChart.withSampleData(dashboardPageBloc.model.value!.daily_report!)),
                              ),
                            ],
                          ))
                    ],
                  )
                ],
              ),
            );
          }
        });
  }
}
