import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_bloc.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_event.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_state.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/SalesSummaryModels.dart';
import 'package:invo_mobile/views/back_office/reports/DailySalesReport.dart';
import 'package:invo_mobile/views/back_office/reports/DriverSummary.dart';
import 'package:invo_mobile/views/back_office/reports/SalesByCategory.dart';
import 'package:invo_mobile/views/back_office/reports/SalesByEmployee.dart';
import 'package:invo_mobile/views/back_office/reports/SalesByHours.dart';
import 'package:invo_mobile/views/back_office/reports/SalesByItem.dart';
import 'package:invo_mobile/views/back_office/reports/SalesBySectionTable.dart';
import 'package:invo_mobile/views/back_office/reports/SalesByService.dart';
import 'package:invo_mobile/views/back_office/reports/SalesByTable.dart';
import 'package:invo_mobile/views/back_office/reports/SalesSummaryReport.dart';
import 'package:invo_mobile/views/back_office/reports/TaxReport.dart';
import 'package:invo_mobile/views/back_office/reports/VoidReport.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

import '../drawer_tab.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportTab extends StatefulWidget {
  final SalesSummaryReport? report;
  ReportTab({Key? key, this.report}) : super(key: key);

  @override
  _ReportTabState createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  late ReportPageBloc bloc;
  final Property<double> scale = Property<double>();

  @override
  void initState() {
    super.initState();
    bloc = ReportPageBloc();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

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
            AppLocalizations.of(context)!.translate('Reports'),
            // ignore: prefer_const_constructors
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
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 1,
              color: Colors.black12,
            ))),
            height: 100,
            child: ListView(
              itemExtent: 180,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    onTap: () {
                      bloc.eventSink.add(SalesSummary(from, to));
                    },
                    text: AppLocalizations.of(context)!.translate("Sales Summary"),
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                      text: AppLocalizations.of(context)!.translate("Daily Sales Report"),
                      onTap: () {
                        bloc.eventSink.add(DailySales(from, to));
                      }),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                      text: AppLocalizations.of(context)!.translate("Sales By Hours"),
                      onTap: () {
                        bloc.eventSink.add(SalesByHours(from, to));
                      }),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                      text: AppLocalizations.of(context)!.translate("Sales By Service"),
                      onTap: () {
                        bloc.eventSink.add(SalesByService(from, to));
                      }),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Sales By Table"),
                    onTap: () {
                      bloc.eventSink.add(SalesByTable(from, to));
                    },
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Sales By Table Section"),
                    onTap: () {
                      bloc.eventSink.add(SalesBySectionTable(from, to));
                    },
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Sales By Item"),
                    onTap: () {
                      bloc.eventSink.add(SalesByItem(from, to));
                    },
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Sales By Category"),
                    onTap: () {
                      bloc.eventSink.add(SalesByCategory(from, to));
                    },
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Tax Report"),
                    onTap: () {
                      bloc.eventSink.add(TaxReport(from, to));
                    },
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Sales By Employee"),
                    onTap: () {
                      bloc.eventSink.add(SalesByEmployee(from, to));
                    },
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Driver Summary"),
                    onTap: () {
                      bloc.eventSink.add(DriverSummary(from, to));
                    },
                  ),
                ),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Void Report"),
                    onTap: () {
                      bloc.eventSink.add(VoidReport(from, to));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(width: 200, child: fromDateField()),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(width: 200, child: toDateField()),
                            Container(
                                padding: const EdgeInsets.all(10),
                                width: 100,
                                child: PrimaryButton(
                                  onTap: () {
                                    setState(() {});
                                    // if (bloc.report.value is SalesSummaryReport) {
                                    //   bloc.eventSink.add(SalesSummary(from, to));
                                    // } else if (bloc.report.value is DailySalesReport) {
                                    //   bloc.eventSink.add(DailySales(from, to));
                                    // } else if (bloc.report.value is SalesByHoursReport) {
                                    //   bloc.eventSink.add(SalesByHours(from, to));
                                    // } else if (bloc.report.value is SalesByServiceReport) {
                                    //   bloc.eventSink.add(SalesByService(from, to));
                                    // } else if (bloc.report.value is SalesByTableReport) {
                                    //   bloc.eventSink.add(SalesByTable(from, to));
                                    // } else if (bloc.report.value is SalesBySectionTableReport) {
                                    //   bloc.eventSink.add(SalesBySectionTable(from, to));
                                    // } else if (bloc.report.value is SalesByItemReport) {
                                    //   bloc.eventSink.add(SalesByItem(from, to));
                                    // } else if (bloc.report.value is SalesByCategoryReport) {
                                    //   bloc.eventSink.add(SalesByCategory(from, to));
                                    // } else if (bloc.report.value is Tax) {
                                    //   // bloc.eventSink.add(TaxReport(from, to));
                                    // } else if (bloc.report.value is SalesByEmployeeReport) {
                                    //   bloc.eventSink.add(SalesByEmployee(from, to));
                                    // } else if (bloc.report.value is DriverSummaryReport) {
                                    //   bloc.eventSink.add(DriverSummary(from, to));
                                    // } else if (bloc.report.value is Voidorders) {
                                    //   bloc.eventSink.add(VoidReport(from, to));
                                    // }
                                  },
                                  text: AppLocalizations.of(context)!.translate("Go"),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: StreamBuilder(
                        stream: bloc.report.stream,
                        initialData: bloc.report.value,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (bloc.report.value == null) {
                            return Container();
                          } else {
                            if (bloc.report.value is SalesSummaryReport) {
                              return SalesSummaryReportWidget(scale: scale, report: bloc.report.value as SalesSummaryReport);
                            } else if (bloc.report.value is DailySalesReport) {
                              return Dailysales(
                                report: (bloc.report.value as DailySalesReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is SalesByHoursReport) {
                              return SalesbyHours(
                                report: (bloc.report.value as SalesByHoursReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is SalesByServiceReport) {
                              return SalesBServiceReport(
                                report: (bloc.report.value as SalesByServiceReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is SalesByTableReport) {
                              return SalesbyTable(
                                report: (bloc.report.value as SalesByTableReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is SalesBySectionTableReport) {
                              return SalesbySectionTable(
                                report: (bloc.report.value as SalesBySectionTableReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is SalesByItemReport) {
                              return SalesByMenuItem(
                                report: (bloc.report.value as SalesByItemReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is SalesByCategoryReport) {
                              return SalesByMenuCategory(
                                report: (bloc.report.value as SalesByCategoryReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is Tax) {
                              return Taxreport(
                                report: (bloc.report.value as Tax),
                                scale: scale,
                              );
                            } else if (bloc.report.value is SalesByEmployeeReport) {
                              return SalesbyEmployee(
                                report: (bloc.report.value as SalesByEmployeeReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is DriverSummaryReport) {
                              return Driversummary(
                                report: (bloc.report.value as DriverSummaryReport),
                                scale: scale,
                              );
                            } else if (bloc.report.value is Voidorders) {
                              return Voidreport(
                                report: (bloc.report.value as Voidorders),
                                scale: scale,
                              );
                            }
                          }

                          return Container();
                        },
                      ),
                    )),
                  ],
                )),
          )
        ],
      ),
    );
  }

  void _showPrintedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final Uint8List bytes = await build(pageFormat);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File file = File(appDocPath + '/' + 'document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
  }

  Widget fromDateField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 80,
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            AppLocalizations.of(context)!.translate('From'),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: Misc.toShortDate(from)),
            onTap: () async {
              DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2010), maxTime: DateTime.now(), onConfirm: (date) {
                setState(() {
                  from = date;
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget toDateField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 80,
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            AppLocalizations.of(context)!.translate('To'),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: TextEditingController(text: Misc.toShortDate(to)),
            readOnly: true,
            onTap: () async {
              DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2010), maxTime: DateTime.now(), onConfirm: (date) {
                setState(() {
                  to = date;
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
