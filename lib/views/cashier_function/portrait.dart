import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/cashier_function/cashier_function_bloc.dart';
import 'package:invo_mobile/blocs/cashier_function/cashier_function_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import '../../service_locator.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class CashierFunctionPortrait extends StatefulWidget {
  CashierFunctionPortrait({Key? key}) : super(key: key);

  @override
  _CashierFunctionPortraitState createState() => _CashierFunctionPortraitState();
}

class _CashierFunctionPortraitState extends State<CashierFunctionPortrait> {
  late CashierFunctionBloc cashierPageBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cashierPageBloc = locator.get<CashierFunctionBloc>();
  }

  double get total {
    double _total = cashierPageBloc.extraCash;
    for (var item in cashierPageBloc.localcurrencies.value!) {
      _total += item.amount;
    }

    for (var item in cashierPageBloc.forigenCurrencies.value!) {
      _total += item.equivalant;
    }

    for (var item in cashierPageBloc.otherTenders.value!) {
      _total += item.amount;
    }
    return _total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          StreamBuilder(
              stream: cashierPageBloc.localcurrencies.stream,
              initialData: cashierPageBloc.localcurrencies.value,
              builder: (context, snapshot) {
                return localCurrencyList();
              }),
          StreamBuilder(
              stream: cashierPageBloc.forigenCurrencies.stream,
              initialData: cashierPageBloc.forigenCurrencies.value,
              builder: (context, snapshot) {
                return forignCurrencyList();
              }),
          StreamBuilder(
              stream: cashierPageBloc.otherCurrency.stream,
              initialData: cashierPageBloc.otherCurrency.value,
              builder: (context, snapshot) {
                return otherCurrencyList();
              }),
          Container(
            height: 100,
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: extraCashField(),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text(
                      AppLocalizations.of(context)!.translate("Total") + " " + Number.formatCurrency(total),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  child: PrimaryButton(
                    onTap: () {
                      cashierPageBloc.eventSink.add(CancelCashierFunction());
                    },
                    text: AppLocalizations.of(context)!.translate("Cancel"),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  width: 150,
                  child: PrimaryButton(
                    onTap: () {
                      List<CashReigisterCount> count = List<CashReigisterCount>.empty(growable: true);

                      CashReigisterCount cash = CashReigisterCount();
                      cash.method = locator.get<ConnectionRepository>().cash;
                      cash.total = cashierPageBloc.extraCash;
                      for (var item in cashierPageBloc.localcurrencies.value!) {
                        cash.total += item.amount;
                      }
                      count.add(cash);

                      for (var item in cashierPageBloc.forigenCurrencies.value!) {
                        count.add(
                          CashReigisterCount(
                            method: item.method,
                            total: item.equivalant,
                          ),
                        );
                      }

                      for (var item in cashierPageBloc.otherTenders.value!) {
                        count.add(
                          CashReigisterCount(
                            method: item.method,
                            total: item.amount,
                          ),
                        );
                      }
                      cashierPageBloc.eventSink.add(SaveCashier(count));
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return Dialog(
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: cashierReport(),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 8, top: 10, bottom: 10, right: 8),
                                            child: PrimaryButton(
                                              text: AppLocalizations.of(context)!.translate("Close"),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                cashierPageBloc.eventSink.add(CancelCashierFunction());
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 8, top: 10, bottom: 10, right: 8),
                                            child: PrimaryButton(
                                              text: AppLocalizations.of(context)!.translate("Print"),
                                              onTap: () {
                                                cashierPageBloc.eventSink.add(PrintCashier());
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    text: AppLocalizations.of(context)!.translate("Confirm"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget localCurrencyList() {
    List<Widget> widgets = List<Widget>.empty(growable: true);
    for (var currency in cashierPageBloc.localcurrencies.value!) {
      int index = cashierPageBloc.localcurrencies.value!.indexWhere((element) => element == currency);
      widgets.add(InkWell(
        onTap: () async {
          DialogService _dialogService = locator<DialogService>();
          String number = await _dialogService.showNumberDialog(NumberDialogRequest(title: "Enter Number Of " + currency.type.toString() + " you have"));

          print(number);
          if (number == "") return;
          setState(() {
            cashierPageBloc.localcurrencies.value![index].qty = int.tryParse(number.toString())!;
          });
        },
        child: Container(
          height: 50,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
              right: BorderSide(
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  Number.getNumber(currency.type),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  currency.qty.toString(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  Number.getNumber(currency.amount),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                left: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
                right: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Local Currency"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate("Qty"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate("Total"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Column(
              children: widgets,
            ),
          ),
        ],
      ),
    );
  }

  Widget forignCurrencyList() {
    List<Widget> widgets = List<Widget>.empty(growable: true);
    for (var currency in cashierPageBloc.forigenCurrencies.value!) {
      int index = cashierPageBloc.forigenCurrencies.value!.indexWhere((element) => element == currency);
      widgets.add(InkWell(
        onTap: () async {
          DialogService _dialogService = locator<DialogService>();
          String number = await _dialogService.showNumberDialog(NumberDialogRequest(hasDotButton: true, title: "Enter Number Of " + currency.method.name.toString() + " you have"));

          print(number);
          if (number == "") return;
          setState(() {
            cashierPageBloc.forigenCurrencies.value![index].amount = double.tryParse(number.toString())!;
          });
        },
        child: Container(
          height: 50,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  Number.getNumber(currency.amount),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  currency.method.name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  Number.getNumber(currency.equivalant),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                left: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
                right: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Foreign Currency"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 3,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate("Amount"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate("Currency"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate("Equivalent"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
                left: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
                right: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Column(
              children: widgets,
            ),
          ),
        ],
      ),
    );
  }

  Widget otherCurrencyList() {
    List<Widget> widgets = List<Widget>.empty(growable: true);
    for (var tender in cashierPageBloc.otherTenders.value!) {
      int index = cashierPageBloc.otherTenders.value!.indexWhere((element) => element == tender);
      widgets.add(InkWell(
        onTap: () async {
          DialogService _dialogService = locator<DialogService>();
          String number = await _dialogService.showNumberDialog(NumberDialogRequest(hasDotButton: true, title: "Enter Number Of " + tender.method!.name.toString() + " you have"));

          print(number);
          if (number == "") return;
          setState(() {
            cashierPageBloc.otherTenders.value![index].amount = double.tryParse(number.toString())!;
          });
        },
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  tender.method!.name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  Number.getNumber(tender.amount),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                left: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
                right: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Other Tenders"),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate("Currency"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate("Amount"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
                left: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
                right: BorderSide(
                  width: 3,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: Column(
              children: widgets,
            ),
          ),
        ],
      ),
    );
  }

  Widget extraCashField() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.translate("Extra Cash"),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
        child: InkWell(
          onTap: () async {
            DialogService _dialogService = locator<DialogService>();
            String number = await _dialogService.showNumberDialog(
              NumberDialogRequest(title: AppLocalizations.of(context)!.translate("Enter Extra Cash"), hasDotButton: true, maxLength: 1000),
            );

            if (number == "") return;
            setState(() {
              cashierPageBloc.extraCash = double.tryParse(number)!;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    Number.getNumber(cashierPageBloc.extraCash),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Icon(
                  Icons.dialpad,
                  size: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  List<Widget> widgets = List<Widget>.empty(growable: true);
  Widget cashierReport() {
    return StreamBuilder(
        stream: cashierPageBloc.model.stream,
        builder: (context, snapshot) {
          if (cashierPageBloc.model.value == null) {
            widgets.add(
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierPageBloc.preference!.restaurantName.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
            if (cashierPageBloc.preference!.phone != null)
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierPageBloc.preference!.phone.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              );
            if (cashierPageBloc.preference!.fax != null)
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierPageBloc.preference!.fax.toString(),
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

            widgets.add(localCurrencyReportField());
            widgets.add(otherTendersCurrencyReportField());
            widgets.add(forginCurrencyReportField());
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Total"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    Number.formatCurrency(cashierPageBloc.total),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ]);
            return ListView(
              padding: EdgeInsets.only(left: 20, right: 20),
              children: widgets,
            );
          } else {
            widgets.add(
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierPageBloc.preference!.restaurantName.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
            if (cashierPageBloc.preference!.phone != null)
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierPageBloc.preference!.phone.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              );
            if (cashierPageBloc.preference!.fax != null)
              widgets.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cashierPageBloc.preference!.fax.toString(),
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

            if (cashierPageBloc.model.value!.cashier_out != null) {
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
                          AppLocalizations.of(context)!.translate("Cashier:"),
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          cashierPageBloc.model.value!.name.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Starting"),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Date:") +
                              cashierPageBloc.model.value!.cashier_days(cashierPageBloc.model.value!.cashier_in) +
                              "/" +
                              cashierPageBloc.model.value!.cashier_month(cashierPageBloc.model.value!.cashier_in) +
                              "/" +
                              cashierPageBloc.model.value!.cashier_in!.year.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate("Time:") + cashierPageBloc.model.value!.cashier_hour(cashierPageBloc.model.value!.cashier_in) + ":" + cashierPageBloc.model.value!.cashier_min(cashierPageBloc.model.value!.cashier_in),
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
            } else {
              cashierPageBloc.model.value!.cashier_out = DateTime.now();
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
                          AppLocalizations.of(context)!.translate("Cashier:"),
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          cashierPageBloc.model.value!.name.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Starting"),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Date:") +
                              cashierPageBloc.model.value!.cashier_days(cashierPageBloc.model.value!.cashier_in) +
                              "/" +
                              cashierPageBloc.model.value!.cashier_month(cashierPageBloc.model.value!.cashier_in) +
                              "/" +
                              cashierPageBloc.model.value!.cashier_in!.year.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate("Time:") + cashierPageBloc.model.value!.cashier_hour(cashierPageBloc.model.value!.cashier_in) + ":" + cashierPageBloc.model.value!.cashier_min(cashierPageBloc.model.value!.cashier_in),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Closing"),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("Date:") +
                              cashierPageBloc.model.value!.cashier_days(cashierPageBloc.model.value!.cashier_out) +
                              "/" +
                              cashierPageBloc.model.value!.cashier_month(cashierPageBloc.model.value!.cashier_out) +
                              "/" +
                              cashierPageBloc.model.value!.cashier_out!.year.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate("Time:") + cashierPageBloc.model.value!.cashier_hour(cashierPageBloc.model.value!.cashier_out) + ":" + cashierPageBloc.model.value!.cashier_min(cashierPageBloc.model.value!.cashier_out).toString(),
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
            }

            widgets.addAll([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("Total Transactions:"),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    cashierPageBloc.model.value!.total_Transactions.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("Opening Amount:"),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.getNumber(cashierPageBloc.model.value!.start_amount).toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("Total Payments:"),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.formatCurrency(cashierPageBloc.model.value!.total_Sale),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("Total Income:"),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    Number.formatCurrency(cashierPageBloc.model.value!.total_income),
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
            if (cashierPageBloc.model.value!.details.length > 0) {
              widgets.addAll([
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate("Sales By Tender"),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate("Tenders"),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate("Total"),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate("Equivalent"),
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
                      AppLocalizations.of(context)!.translate("Net Sale"),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Number.formatCurrency(cashierPageBloc.model.value!.netSale),
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
            if (cashierPageBloc.model.value!.categoryReports.length > 0) {
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate("Income By Category"),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                getByCategory(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate("Category Total:"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      Number.formatCurrency(cashierPageBloc.model.value!.categoryTotal),
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
                      AppLocalizations.of(context)!.translate("Total"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      Number.formatCurrency(cashierPageBloc.model.value!.categoryTotal),
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
            if (cashierPageBloc.model.value!.combine.length > 0)
              widgets.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate("Short/Over Report"),
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

            widgets.add(localCurrencyReportField());
            widgets.add(otherTendersCurrencyReportField());
            widgets.add(forginCurrencyReportField());
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Total"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    Number.formatCurrency(cashierPageBloc.total),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ]);
            return ListView(
              padding: EdgeInsets.only(left: 20, right: 20),
              children: widgets,
            );
          }
        });
  }

  Widget localCurrencyReportField() {
    List<Widget> list = List<Widget>.empty(growable: true);

    if (cashierPageBloc.localcurrencies.value!.length > 0) {
      list.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.translate("Local Currency"),
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
        )
      ]);
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                "",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate("Qty"),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.translate("Total"),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
      list.add(
        const Divider(
          color: Colors.black87,
          height: 20,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      );
      for (int index = 0; cashierPageBloc.localcurrencies.value!.length > index; index++) {
        list.addAll([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  Number.getNumber(cashierPageBloc.localcurrencies.value![index].type),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  cashierPageBloc.localcurrencies.value![index].qty.toString(),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                Number.getNumber(cashierPageBloc.localcurrencies.value![index].amount),
                style: TextStyle(
                  fontSize: 18,
                ),
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
      list.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate("Extra Cash"),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              Number.getNumber(cashierPageBloc.extraCash),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ]);
      list.add(
        const Divider(
          color: Colors.black87,
          height: 20,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
      );
      list.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate("Total"),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Text(
              Number.formatCurrency(cashierPageBloc.localCurrencyTotal),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ]);
    }

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  Widget otherTendersCurrencyReportField() {
    List<Widget> list = List<Widget>.empty(growable: true);
    return StreamBuilder(
        stream: cashierPageBloc.otherTenders.stream,
        initialData: cashierPageBloc.otherTenders.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (cashierPageBloc.otherTenders.value == null || cashierPageBloc.otherTenders.value!.length == 0) return Center();

          if (cashierPageBloc.otherTenders.value!.length > 0) {
            list.addAll([
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("Other Tenders"),
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
              )
            ]);
            list.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Name"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Total"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate("Equivalent"),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
            list.add(
              const Divider(
                color: Colors.black87,
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            );
            for (int index = 0; cashierPageBloc.otherTenders.value!.length > index; index++) {
              list.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        cashierPageBloc.otherTenders.value![index].method!.name,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Number.getNumber(cashierPageBloc.otherTenders.value![index].amount),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      Number.getNumber(cashierPageBloc.otherTenders.value![index].amount),
                      style: TextStyle(
                        fontSize: 18,
                      ),
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

            list.addAll([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Total"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    Number.formatCurrency(cashierPageBloc.otherTenderTotal),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ]);
          }

          return new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list,
          );
        });
  }

  Widget forginCurrencyReportField() {
    List<Widget> list = List<Widget>.empty(growable: true);
    return StreamBuilder(
        stream: cashierPageBloc.forigenCurrencies.stream,
        initialData: cashierPageBloc.forigenCurrencies.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (cashierPageBloc.forigenCurrencies.value == null || cashierPageBloc.forigenCurrencies.value!.length == 0) return Center();

          if (cashierPageBloc.forigenCurrencies.value!.length > 0) {
            list.addAll([
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("Forign Currency"),
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
              )
            ]);
            list.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Currency"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Amount"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate("Equivalent"),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
            list.add(
              const Divider(
                color: Colors.black87,
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            );
            for (int index = 0; cashierPageBloc.forigenCurrencies.value!.length > index; index++) {
              list.addAll([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        cashierPageBloc.forigenCurrencies.value![index].method.name,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Number.getNumber(cashierPageBloc.forigenCurrencies.value![index].amount),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      Number.getNumber(cashierPageBloc.forigenCurrencies.value![index].equivalant),
                      style: TextStyle(
                        fontSize: 18,
                      ),
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
            list.addAll([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("Total"),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    Number.formatCurrency(cashierPageBloc.forignCurrencyTotal),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ]);
          }

          return new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list,
          );
        });
  }

  Widget getByTender() {
    List<Widget> list = List<Widget>.empty(growable: true);
    cashierPageBloc.model.value!.details.forEach((element) {
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

  Widget getByCategory() {
    List<Widget> list = List<Widget>.empty(growable: true);
    cashierPageBloc.model.value!.categoryReports.forEach((element) {
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

  Widget getByShortOver() {
    List<Widget> list = List<Widget>.empty(growable: true);
    cashierPageBloc.model.value!.combine.forEach((element) {
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
                  AppLocalizations.of(context)!.translate("Expected") + ":",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(element.start_amount + element.amount_paid - cashierPageBloc.model.value!.payOut_total).toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Count") + ":",
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
                  AppLocalizations.of(context)!.translate("Short Over") + ":",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  Number.getNumber(element.end_amount - (element.start_amount + element.amount_paid - cashierPageBloc.model.value!.payOut_total)).toString(),
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
                  AppLocalizations.of(context)!.translate("Expected") + ":",
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
                  AppLocalizations.of(context)!.translate("Count") + ":",
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
                  AppLocalizations.of(context)!.translate("Short Over") + ":",
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
}
