import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/daily_report/daily_report_page_bloc.dart';
import 'package:invo_mobile/blocs/daily_report/daily_report_page_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/date_field.dart';

class DailySalesPage extends StatefulWidget {
  final RecallPageBloc? recallPageBloc;

  DailySalesPage({Key? key, this.recallPageBloc}) : super(key: key);

  @override
  _DailySalesPageState createState() => _DailySalesPageState();
}

class _DailySalesPageState extends State<DailySalesPage> with WidgetsBindingObserver {
  DateTime selectedDate = DateTime.now();
  DailyClosingModel dailyClosing =
      DailyClosingModel(tenderReports: [], cashierReports: [], categoryReports: [], openCashiers: [], openOrders: [], serviceReports: []);

  late DailyReportPageBloc dailyReportPageBloc;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dailyReportPageBloc = DailyReportPageBloc(BlocProvider.of<NavigatorBloc>(context));

    // loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(width);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          child: BlocProvider<DailyReportPageBloc>(
            bloc: dailyReportPageBloc,
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
        Expanded(
          child: dailyReportCode(),
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
                      dailyReportPageBloc.eventSink.add(DailyReportPageGoBack());
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
                      dailyReportPageBloc.eventSink.add(PrintDailyClosingReport(selectedDate));
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
          child: Container(width: 550, child: dailyReportCode()),
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
                      dailyReportPageBloc.eventSink.add(DailyReportPageGoBack());
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
                      dailyReportPageBloc.eventSink.add(PrintDailyClosingReport(selectedDate));
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

  Widget datePickerCode() {
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
                  dailyReportPageBloc.eventSink.add(DailyReportLoadReport(selectedDate));
                },
                text: 'Go',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSalesByCategory() {
    List<Widget> list = List<Widget>.empty(growable: true);
    dailyReportPageBloc.model.value!.categoryReports.forEach((element) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            element.category_name.toString() + ":",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            Number.getNumber(element.total!),
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

  Widget getSalesByService() {
    List<Widget> list = List<Widget>.empty(growable: true);
    dailyReportPageBloc.model.value!.serviceReports.forEach((element) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            element.service_name.toString() + ":",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            Number.getNumber(element.total!),
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

  Widget getSalesByTender() {
    List<Widget> list = List<Widget>.empty(growable: true);
    dailyReportPageBloc.model.value!.tenderReports.forEach((element) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            element.payment_method.toString() + ":",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            Number.getNumber(element.total!),
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

  Widget getOpenCashier() {
    List<Widget> list = List<Widget>.empty(growable: true);
    dailyReportPageBloc.model.value!.openCashiers.forEach((element) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            element.id.toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            element.name.toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            element.computer_id.toString(),
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

  Widget getOpenOrders() {
    List<Widget> list = List<Widget>.empty(growable: true);
    dailyReportPageBloc.model.value!.openOrders.forEach((element) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            element.date_time!.day.toString() + "/" + element.date_time!.month.toString() + "/" + element.date_time!.year.toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            element.id.toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            element.name.toString(),
            style: TextStyle(fontSize: 18),
          ),
          Text(
            Number.getNumber(element.grand_price),
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

  Widget dailyReportCode() {
    return StreamBuilder(
        stream: dailyReportPageBloc.model.stream,
        builder: (context, snapshot) {
          if (dailyReportPageBloc.model.value == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Widget> widgets = List<Widget>.empty(growable: true);

            widgets.add(Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dailyReportPageBloc.preference!.restaurantName!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ));
            if (dailyReportPageBloc.preference!.phone != null) {
              widgets.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dailyReportPageBloc.preference!.phone,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ));
            }

            if (dailyReportPageBloc.preference!.fax != null) {
              widgets.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dailyReportPageBloc.preference!.fax,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ));
            }

            widgets.addAll([
              const Divider(
                color: Colors.black87,
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Daily Sales',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                    'Total Order:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    dailyReportPageBloc.model.value!.total_order != null ? dailyReportPageBloc.model.value!.total_order.toString() : '0',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Transactions:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    dailyReportPageBloc.model.value!.total_transaction.toString(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Sale:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.formatCurrency(dailyReportPageBloc.model.value!.total_sale),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ]);

            if (dailyReportPageBloc.model.value!.total_charge_per_hour > 0) {
              print("${dailyReportPageBloc.model.value!.total_charge_per_hour}");
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Charge Per Hour:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_charge_per_hour),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ]);
            }

            if (dailyReportPageBloc.model.value!.total_minimum_charge > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Minimum Charge:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_minimum_charge),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.total_discount_amount > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Discount:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_discount_amount),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.total_surcharge_amount > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Surcharge:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_surcharge_amount),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            if (dailyReportPageBloc.model.value!.total_delivery_charge > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Delivery Charge:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_delivery_charge),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.total_tax > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dailyReportPageBloc.preference!.tax1_name != null ? dailyReportPageBloc.preference!.tax1_name.toString() + ":" : "Tax 1:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_tax),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.total_tax2 > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dailyReportPageBloc.preference!.tax2_name != null ? dailyReportPageBloc.preference!.tax2_name.toString() + ":" : "Tax 2:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_tax2),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            if (dailyReportPageBloc.model.value!.total_tax3 > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dailyReportPageBloc.preference!.tax3_name != null ? dailyReportPageBloc.preference!.tax3_name.toString() + ":" : "Tax 3:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_tax3),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.total_rounding != 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Rounding:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber((dailyReportPageBloc.model.value!.total_rounding * -1)),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            if (dailyReportPageBloc.model.value!.total_payOut > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pay Out:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_payOut),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            widgets.addAll([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Income:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.formatCurrency((dailyReportPageBloc.model.value!.total - dailyReportPageBloc.model.value!.total_payOut)),
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

            if (dailyReportPageBloc.model.value!.totalGuests > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Guests:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      dailyReportPageBloc.model.value!.totalGuests.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.total_void > 0) {
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Void:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.getNumber(dailyReportPageBloc.model.value!.total_void),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.total_void > 0 || dailyReportPageBloc.model.value!.totalGuests > 0) {
              widgets.add(
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              );
            }

            if (dailyReportPageBloc.model.value!.serviceReports.length > 0) {
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sales By Service',
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
                getSalesByService(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.formatCurrency(dailyReportPageBloc.model.value!.total_service_sales),
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
            if (dailyReportPageBloc.model.value!.categoryReports.length > 0) {
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sales By Category',
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
                getSalesByCategory(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.formatCurrency(dailyReportPageBloc.model.value!.total_category_sales),
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

            if (dailyReportPageBloc.model.value!.tenderReports.length > 0) {
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Income By Tender',
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
                getSalesByTender(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.formatCurrency(dailyReportPageBloc.model.value!.total_tender_sales),
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
            if (dailyReportPageBloc.model.value!.cashierReports.length > 0) {
              widgets.add(Center(
                child: Text(
                  "Cashier Reports",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ));
              widgets.add(const Divider(
                color: Colors.black87,
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ));

              for (var item in dailyReportPageBloc.model.value!.cashierReports) {
                widgets.addAll(cashierReport(item));
              }
            }
            if (dailyReportPageBloc.model.value!.openCashiers.length > 0) {
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Open Cashiers',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cashier ID',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Name',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Terminal',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                getOpenCashier(),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ]);
            }
            if (dailyReportPageBloc.model.value!.openOrders.length > 0) {
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Open Orders',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Order',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Type',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Total',
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
                getOpenOrders(),
                const Divider(
                  color: Colors.black87,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ]);
            }

            return ListView(
              padding: EdgeInsets.only(left: 8, right: 8),
              children: widgets,
            );
          }
        });
  }

  List<Widget> cashierReport(CashierReportModel cashierReport) {
    List<Widget> widgets = List<Widget>.empty(growable: true);
    if (cashierReport.cashier_in != null)
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
                  cashierReport.name.toString(),
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
                      cashierReport.cashier_days(cashierReport.cashier_in) +
                      "/" +
                      cashierReport.cashier_month(cashierReport.cashier_in) +
                      "/" +
                      cashierReport.cashier_year(cashierReport.cashier_in),
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Time: ' + cashierReport.cashier_hour(cashierReport.cashier_in) + ":" + cashierReport.cashier_min(cashierReport.cashier_in),
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
                      cashierReport.cashier_days(cashierReport.cashier_out) +
                      "/" +
                      cashierReport.cashier_month(cashierReport.cashier_out) +
                      "/" +
                      cashierReport.cashier_year(cashierReport.cashier_out),
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Time: ' +
                      cashierReport.cashier_hour(cashierReport.cashier_out) +
                      ":" +
                      cashierReport.cashier_min(cashierReport.cashier_out).toString(),
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
            cashierReport.total_Transactions.toString(),
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
            Number.getNumber(cashierReport.start_amount).toString(),
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
            Number.formatCurrency(cashierReport.total_Sale),
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
            Number.formatCurrency(cashierReport.total_income),
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
    if (cashierReport.details.length > 0) {
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
        getByTender(cashierReport),
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
              Number.formatCurrency(cashierReport.netSale),
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
    if (cashierReport.categoryReports.length > 0) {
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
        getByCategory(cashierReport),
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
              Number.formatCurrency(cashierReport.categoryTotal),
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
              Number.formatCurrency(cashierReport.categoryTotal),
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
    if (cashierReport.combine.length > 0)
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
        getByShortOver(cashierReport),
      ]);

    return widgets;
  }
}

Widget getByTender(CashierReportModel cashierReport) {
  List<Widget> list = List<Widget>.empty(growable: true);
  cashierReport.details.forEach((element) {
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

Widget getByShortOver(CashierReportModel cashierReport) {
  List<Widget> list = List<Widget>.empty(growable: true);
  cashierReport.combine.forEach((element) {
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
                Number.getNumber(element.start_amount + element.amount_paid - cashierReport.payOut_total).toString(),
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
                Number.getNumber(element.end_amount - (element.start_amount + element.amount_paid - cashierReport.payOut_total)).toString(),
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

Widget getByCategory(CashierReportModel cashierReport) {
  List<Widget> list = List<Widget>.empty(growable: true);
  cashierReport.categoryReports.forEach((element) {
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
