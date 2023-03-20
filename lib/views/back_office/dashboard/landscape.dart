import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/dashboard_page/dash_board_page_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../drawer_tab.dart';
import 'charts/dailyincome.dart';
import 'charts/salesbyemployee.dart';
import 'charts/salesbytype.dart';

class DashBoardLandscape extends StatefulWidget {
  DashBoardLandscape({Key? key}) : super(key: key);

  @override
  _DashBoardLandscapeState createState() => _DashBoardLandscapeState();
}

DashboardPageBloc? dashboardPageBloc;

class _DashBoardLandscapeState extends State<DashBoardLandscape> {
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
      body: BlocProvider<DashboardPageBloc>(bloc: dashboardPageBloc!, child: DashBoardTab()),
    );
  }
}

class DashBoardTab extends StatefulWidget {
  DashBoardTab({Key? key}) : super(key: key);

  @override
  _DashBoardTabState createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dashboardPageBloc!.model.stream,
        builder: (context, snapshot) {
          if (dashboardPageBloc?.model.value == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Row(
              children: <Widget>[
                DrawerTab.singleton(),
                Expanded(
                    flex: 5,
                    child: ListView(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(20, 20, 5, 5),
                                  height: 80,
                                  width: 120,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[300]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Center(
                                          child: Text(Number.formatCurrency(dashboardPageBloc!.model.value!.total_sale),
                                              style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                                      Center(
                                          child: Text(AppLocalizations.of(context)!.translate("Total Sale"),
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 20, 20, 5),
                                  height: 80,
                                  width: 120,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.grey[300]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Center(
                                          child: Text(dashboardPageBloc!.model.value!.total_order.toString(),
                                              style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                                      Center(
                                          child: Text(AppLocalizations.of(context)!.translate("Total Order"),
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
                                    ],
                                  )),
                            ),
                          ],
                        ),
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
                                    child: SalesByEmployeeChart.withSampleData(dashboardPageBloc!.model.value!.employee_report!)),
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
                                  child: SalesByTypeChart.withSampleData(dashboardPageBloc!.model.value!.service_report!),
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
                                      margin: EdgeInsets.all(20),
                                      child: DailyIncomeChart.withSampleData(dashboardPageBloc!.model.value!.daily_report!)),
                                ),
                              ],
                            ))
                      ],
                    ))
              ],
            );
          }
        });
  }
}
