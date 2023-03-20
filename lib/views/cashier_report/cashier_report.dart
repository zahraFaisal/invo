// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:math';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
// import 'package:get_ip/get_ip.dart';
import 'package:invo_mobile/blocs/cashier_report/cashier_report_page_bloc.dart';
import 'package:invo_mobile/blocs/cashier_report/cashier_report_page_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/terminal_page/terminal_page_bloc.dart';
import 'package:invo_mobile/blocs/terminal_page/terminal_page_event.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/date_field.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class CashierReportPage extends StatefulWidget {
  CashierReportPage({Key? key}) : super(key: key);

  @override
  _CashierReportPageState createState() => _CashierReportPageState();
}

class _CashierReportPageState extends State<CashierReportPage> {
  CashierReportModel cashierReport =
      CashierReportModel(categoryReports: [], credit_payments: [], details: [], forignCurrency: [], local_currency: [], other_tenders: []);

  late CashierReportPageBloc cashierReportPageBloc;
  DateTime selectedDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cashierReportPageBloc = CashierReportPageBloc(BlocProvider.of<NavigatorBloc>(context));

    // loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocProvider<CashierReportPageBloc>(
        bloc: cashierReportPageBloc,
        child: SafeArea(
          child: Container(
            color: Colors.grey[200],
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return portrait();
                } else {
                  return landscape();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget portrait() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 5,
            ),
          ),
          margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
          padding: EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              datePickerCode(),
            ],
          ),
        ),
        Container(
          height: 130,
          margin: EdgeInsets.all(6),
          width: MediaQuery.of(context).size.width,
          child: cashierPickerCode(),
        ),
        Expanded(
          child: cashierReportCode(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 4, 4),
                  height: 50,
                  child: PrimaryButton(
                    onTap: () {
                      cashierReportPageBloc.eventSink.add(CashierReportPageGoBack());
                    },
                    text: 'Back',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(4, 6, 8, 4),
                  child: PrimaryButton(
                    onTap: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      cashierReportPageBloc.eventSink.add(PrintCashierReport());
                    },
                    text: 'Print',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget landscape() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 5,
            ),
          ),
          margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
          padding: EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              datePickerCode(),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: cashierPickerCode(),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    width: 500,
                    child: cashierReportCode(),
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 4, 4),
                  height: 50,
                  child: PrimaryButton(
                    onTap: () {
                      cashierReportPageBloc.eventSink.add(CashierReportPageGoBack());
                    },
                    text: 'Back',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(4, 6, 8, 4),
                  child: PrimaryButton(
                    onTap: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      cashierReportPageBloc.eventSink.add(PrintCashierReport());
                    },
                    text: 'Print',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  datePickerCode() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: DatePicker(
              selectedDate: DateTime.now(),
              selectDate: (newValue) {
                selectedDate = newValue;
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 6),
              height: 40,
              child: PrimaryButton(
                onTap: () {
                  cashierReportPageBloc.eventSink.add(CashierReportLoadReport(selectedDate));
                  if (cashierReportPageBloc.modelList.value!.length > 0) {
                    cashierReportPageBloc.eventSink.add(CashierReportDetailsLoadReport(cashierReportPageBloc.modelList.value![0].id));
                  }
                },
                text: 'Go',
              ),
            ),
          ),
        ],
      ),
    );
  }

  cashierPickerCode() {
    return StreamBuilder(
        stream: cashierReportPageBloc.modelList.stream,
        builder: (context, snapshot) {
          if (cashierReportPageBloc.modelList.value == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
              scrollDirection: MediaQuery.of(context).orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
              itemCount: cashierReportPageBloc.modelList.value!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0,
                  color: Colors.grey[200],
                  child: Container(
                    height: 130,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 4),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        cashierReportPageBloc.eventSink.add(CashierReportDetailsLoadReport(cashierReportPageBloc.modelList.value![index].id));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'CashierID# ' + cashierReportPageBloc.modelList.value![index].id.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            cashierReportPageBloc.modelList.value![index].name!,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Terminal: ' + cashierReportPageBloc.modelList.value![index].terminal_id.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Start: ' +
                                cashierReportPageBloc.modelList.value![index].cashier_days(cashierReportPageBloc.modelList.value![index].cashier_in) +
                                "/" +
                                cashierReportPageBloc.modelList.value![index]
                                    .cashier_month(cashierReportPageBloc.modelList.value![index].cashier_in) +
                                "/" +
                                cashierReportPageBloc.modelList.value![index].cashier_in!.year.toString() +
                                " " +
                                cashierReportPageBloc.modelList.value![index].cashier_hour(cashierReportPageBloc.modelList.value![index].cashier_in) +
                                ":" +
                                cashierReportPageBloc.modelList.value![index].cashier_min(cashierReportPageBloc.modelList.value![index].cashier_in),
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'End: ' +
                                cashierReportPageBloc.modelList.value![index]
                                    .cashier_days(cashierReportPageBloc.modelList.value![index].cashier_out) +
                                "/" +
                                cashierReportPageBloc.modelList.value![index]
                                    .cashier_month(cashierReportPageBloc.modelList.value![index].cashier_out) +
                                "/" +
                                cashierReportPageBloc.modelList.value![index].cashier_out!.year.toString() +
                                " " +
                                cashierReportPageBloc.modelList.value![index]
                                    .cashier_hour(cashierReportPageBloc.modelList.value![index].cashier_out) +
                                ":" +
                                cashierReportPageBloc.modelList.value![index].cashier_min(cashierReportPageBloc.modelList.value![index].cashier_out),
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
          }
        });
  }

  cashierReportCode() {
    return StreamBuilder(
        stream: cashierReportPageBloc.model.stream,
        builder: (context, snapshot) {
          if (cashierReportPageBloc.model.value == null) {
            return Center(
              child: Text("Choose an Employee"),
            );
          } else {
            List<Widget> widgets = List<Widget>.empty(growable: true);
            widgets.add(
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierReportPageBloc.preference!.restaurantName.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
            if (cashierReportPageBloc.preference!.phone != null)
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierReportPageBloc.preference!.phone.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              );
            if (cashierReportPageBloc.preference!.fax != null)
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierReportPageBloc.preference!.fax.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              );
            widgets.add(
              const Divider(
                color: Colors.black87,
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            );

            widgets.addAll([
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cashier: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        cashierReportPageBloc.model.value!.name.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Starting',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ' +
                            cashierReportPageBloc.model.value!.cashier_days(cashierReportPageBloc.model.value!.cashier_in) +
                            "/" +
                            cashierReportPageBloc.model.value!.cashier_month(cashierReportPageBloc.model.value!.cashier_in) +
                            "/" +
                            cashierReportPageBloc.model.value!.cashier_in!.year.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Time: ' +
                            cashierReportPageBloc.model.value!.cashier_hour(cashierReportPageBloc.model.value!.cashier_in) +
                            ":" +
                            cashierReportPageBloc.model.value!.cashier_min(cashierReportPageBloc.model.value!.cashier_in),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Closing',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ' +
                            cashierReportPageBloc.model.value!.cashier_days(cashierReportPageBloc.model.value!.cashier_out) +
                            "/" +
                            cashierReportPageBloc.model.value!.cashier_month(cashierReportPageBloc.model.value!.cashier_out) +
                            "/" +
                            cashierReportPageBloc.model.value!.cashier_out!.year.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Time: ' +
                            cashierReportPageBloc.model.value!.cashier_hour(cashierReportPageBloc.model.value!.cashier_out) +
                            ":" +
                            cashierReportPageBloc.model.value!.cashier_min(cashierReportPageBloc.model.value!.cashier_out).toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.black87,
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ]);
            widgets.addAll([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Transactions:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    cashierReportPageBloc.model.value!.total_Transactions.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Opening Amount:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.getNumber(cashierReportPageBloc.model.value!.start_amount).toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payments:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.formatCurrency(cashierReportPageBloc.model.value!.total_Sale),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Income:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.formatCurrency(cashierReportPageBloc.model.value!.total_income),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Divider(
                color: Colors.black87,
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ]);
            if (cashierReportPageBloc.model.value!.details.length > 0) {
              widgets.addAll([
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sales By Tender',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tenders',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Equivalant',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                getByTender(),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Net Sale',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.formatCurrency(cashierReportPageBloc.model.value!.netSale),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ]);
            }
            if (cashierReportPageBloc.model.value!.categoryReports.length > 0) {
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Income By Category',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                getByCategory(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category Total:',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      Number.formatCurrency(cashierReportPageBloc.model.value!.categoryTotal),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      Number.formatCurrency(cashierReportPageBloc.model.value!.categoryTotal),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ]);
            }
            if (cashierReportPageBloc.model.value!.combine.length > 0)
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Short/Over Report',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                getByShortOver(),
              ]);

            return ListView(
              padding: EdgeInsets.only(left: 8, right: 8),
              children: widgets,
            );
          }
        });
  }

  Widget getByTender() {
    List<Widget> list = List<Widget>.empty(growable: true);
    cashierReportPageBloc.model.value!.details.forEach((element) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            element.payment_method.toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            Number.getNumber(element.amount_paid).toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            Number.getNumber(element.actual_amount_paid).toString(),
            style: TextStyle(fontSize: 18),
          ),
        ],
      ));
    });
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  Widget getByShortOver() {
    List<Widget> list = List<Widget>.empty(growable: true);
    cashierReportPageBloc.model.value!.combine.forEach((element) {
      if (element.payment_method != "Account") {
        if (element.payment_method_id == 1) {
          list.addAll([
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  element.payment_method.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expected:",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(element.start_amount + element.amount_paid - cashierReportPageBloc.model.value!.payOut_total).toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Count:",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(element.end_amount).toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Short Over:",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(
                          element.end_amount - (element.start_amount + element.amount_paid - cashierReportPageBloc.model.value!.payOut_total))
                      .toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ]);
        } else {
          list.addAll([
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  element.payment_method.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expected:",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(element.start_amount + element.amount_paid).toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Count:",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(element.end_amount).toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Short Over:",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(element.end_amount - (element.start_amount + element.amount_paid)).toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ]);
        }
        list.add(
          const Divider(
            color: Colors.black87,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
        );
      }
    });
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  Widget getByCategory() {
    List<Widget> list = List<Widget>.empty(growable: true);
    cashierReportPageBloc.model.value!.categoryReports.forEach((element) {
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              element.category_name.toString(),
              style: TextStyle(fontSize: 18),
            ),
            Text(
              Number.getNumber(element.total!).toString(),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    });
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
