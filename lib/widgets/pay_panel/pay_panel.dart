import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/settle_page/settle_page_bloc.dart';
import 'package:invo_mobile/blocs/settle_page/settle_page_event.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/order/order_payment.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';

class PayPanel extends StatefulWidget {
  final Void2VoidFunc? onCancel;
  final SettlePageBloc bloc;
  final Transaction2VoidFunc? onDelete;
  PayPanel({Key? key, this.onCancel, required this.bloc, this.onDelete}) : super(key: key);

  @override
  _PayPanelState createState() => _PayPanelState();
}

class _PayPanelState extends State<PayPanel> {
  GlobalKey<KeypadState> _globalKeyPadKey = new GlobalKey();
  late SettlePageBloc settlePageBloc;
  late Preference preference;
  late PaymentMethod paymentMethod;
  late double paymentAmount;
  late double currentPaymentAmount;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preference = locator.get<ConnectionRepository>().preference!;
    settlePageBloc = widget.bloc;
    settlePageBloc.finish.stream.listen((s) {
      if (s) widget.onCancel!();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    settlePageBloc.dispose();
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (await settlePageBloc.asyncValidateForm(paymentAmount, paymentMethod)) {
      _formStateKey.currentState!.validate();
      _formStateKey.currentState!.save();
      settlePageBloc.eventSink.add(
        MethodClicked(
          paymentMethod,
          paymentAmount,
        ),
      );
    } else {
      _formStateKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: SafeArea(
        child: orientation == Orientation.portrait ? portrait() : landscape(),
      ),
    );
  }

  Widget portrait() {
    return Form(
      key: _formStateKey,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(left: 2, top: 2, bottom: 2),
                      child: Keypad(
                        key: _globalKeyPadKey,
                        EnterText: 'Enter Price',
                        maxLength: 8,
                        onChange: (s) {},
                        isButtonOfDotInclude: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: suggestionPricesPortrait(),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 4,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: paymentMethodsPortrait(),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 4,
            ),
            Expanded(
              flex: 2,
              child: orderInfoTotalPaid(),
            ),
            Container(
              margin: EdgeInsets.all(2),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: PrimaryButton(
                        onTap: () {
                          widget.onCancel!();
                        },
                        text: "Cancel",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: PrimaryButton(
                        onTap: () {
                          settlePageBloc.eventSink.add(
                            ConfirmPayment(),
                          );
                        },
                        text: "Confirm",
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget orderInfoTotalPaid() {
    return StreamBuilder(
        stream: settlePageBloc.orderHeader!.headerUpdate.stream,
        initialData: settlePageBloc.orderHeader!.headerUpdate.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (settlePageBloc.orderHeader == null) {
            return Center();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder(
                    stream: settlePageBloc.orderHeader!.footerUpdate.stream,
                    initialData: settlePageBloc.orderHeader!.footerUpdate.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Widget> list = List<Widget>.empty(growable: true);
                      List<Widget> payments = List<Widget>.empty(growable: true);
                      double fontSize = 18;

                      if (settlePageBloc.orderHeader!.payments.length > 0) {
                        for (var item in settlePageBloc.orderHeader!.payments) {
                          payments.add(
                            InkWell(
                              onTap: () {
                                setState(() {
                                  settlePageBloc.orderHeader!.payments.removeAt(settlePageBloc.orderHeader!.payments.indexOf(item));
                                  settlePageBloc.orderHeader!.amountBalance += item.actualAmountPaid;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Text(
                                            item.date_time == null ? "" : (item.date_time!.day.toString() + "-" + item.date_time!.month.toString() + "-" + item.date_time!.year.toString()),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontSize,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Text(
                                          item.date_time == null ? "" : (item.date_time!.hour.toString() + ":" + item.date_time!.minute.toString()),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(
                                          item.method == null ? "Pay: " : (item.method!.name.toString() + ": "),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          Number.getNumber(item.actualAmountPaid),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          item.status == 1 ? " Rejected" : "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        if (payments.length > 0)
                          list.add(Container(
                            margin: EdgeInsets.all(2),
                            height: 60,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: payments,
                            ),
                          ));
                      }
                      list.addAll([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Total:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              ((settlePageBloc.orderHeader!.grand_price != null) ? Number.formatCurrency(settlePageBloc.orderHeader!.grand_price) : Number.formatCurrency(0)),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ]);
                      if (settlePageBloc.orderHeader!.amountTendered > 0) {
                        list.addAll([
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Paid:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                Number.formatCurrency(settlePageBloc.orderHeader!.amountTendered),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          )
                        ]);
                      }

                      if (settlePageBloc.orderHeader!.isBalanceVisible) {
                        list.addAll([
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Balance:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                Number.formatCurrency(settlePageBloc.orderHeader!.amountBalance),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          )
                        ]);
                      }

                      if (settlePageBloc.orderHeader!.amountTendered >= (settlePageBloc.orderHeader!.grand_price == null ? 0 : settlePageBloc.orderHeader!.grand_price) && settlePageBloc.orderHeader!.amountChange >= 0) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Change:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.amountChange),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: list,
                      );
                    },
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget orderInfo() {
    var orientation = MediaQuery.of(context).orientation;
    return StreamBuilder(
        stream: settlePageBloc.orderHeader!.headerUpdate.stream,
        initialData: settlePageBloc.orderHeader!.headerUpdate.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (settlePageBloc.orderHeader == null) {
            return Center();
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // column of order header information

                  // Total
                  StreamBuilder(
                    stream: settlePageBloc.orderHeader!.footerUpdate.stream,
                    initialData: settlePageBloc.orderHeader!.footerUpdate.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Widget> list = List<Widget>.empty(growable: true);
                      double fontSize = 18;

                      if (settlePageBloc.orderHeader!.isItemTotalVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Item Total",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.item_total),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isChargePerHourVisible && settlePageBloc.orderHeader!.isMinChargeVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Charge Per Hour" + "(" + (settlePageBloc.orderHeader!.total_charge_per_hour! / settlePageBloc.orderHeader!.charge_per_hour).round().toString() + "h)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isMinChargeVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Minimum Charge",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.min_charge),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: Colors.red),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isDiscountVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Discount",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.discount_actual_amount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }
                      if (settlePageBloc.orderHeader!.isSurchargeVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Surcharge",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.surcharge_actual_amount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isDeliveryChargeVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Delivery Charge",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.delivery_charge),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isTax3Visible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              preference.tax3Alias.toString() + " Collected",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.total_tax3),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isSubTotalVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Sub Total",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.sub_total_price),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isTaxVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              preference.tax1Alias!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.total_tax),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isTax2Visible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              preference.tax2Alias!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.total_tax2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      if (settlePageBloc.orderHeader!.isRoundingVisible) {
                        list.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Rounding",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              Number.formatCurrency(settlePageBloc.orderHeader!.Rounding),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ));
                      }

                      list.addAll([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF068102)),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              ((settlePageBloc.orderHeader!.grand_price != null) ? Number.formatCurrency(settlePageBloc.orderHeader!.grand_price) : Number.formatCurrency(0)),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF068102)),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                      ]);
                      if (orientation == Orientation.landscape) {
                        if (settlePageBloc.orderHeader!.amountTendered > 0) {
                          list.add(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Tendered",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                Number.formatCurrency(settlePageBloc.orderHeader!.amountTendered),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ));
                        }

                        if (settlePageBloc.orderHeader!.isBalanceVisible) {
                          list.add(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Balance",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                Number.formatCurrency(settlePageBloc.orderHeader!.amountBalance),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ));
                        }

                        if (settlePageBloc.orderHeader!.amountTendered >= (settlePageBloc.orderHeader!.grand_price == null ? 0 : settlePageBloc.orderHeader!.grand_price) && settlePageBloc.orderHeader!.amountChange >= 0) {
                          list.add(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Change",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                Number.formatCurrency(settlePageBloc.orderHeader!.amountChange),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ));
                        }
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: list,
                      );
                    },
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget orderAmount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            paymentAmount = double.parse(value);
          });
        },
        onSaved: (value) {
          setState(() {
            paymentAmount = (value!.isEmpty ? null : double.parse(value))!;
          });
        },
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please Enter Amount';
          }
          return null;
        },
        decoration: InputDecoration(labelText: 'Enter Amount', border: OutlineInputBorder()),
      ),
    );
  }

  Widget orderMethodDropdown() {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: paymentMethod == null ? Colors.redAccent[700]! : Colors.grey,
          width: 1,
        ),
      ),
      child: StreamBuilder(
        stream: settlePageBloc.methods.stream,
        initialData: settlePageBloc.methods.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (settlePageBloc.methods.value == null || settlePageBloc.methods.value!.length == 0)
            return Center(
              child: CircularProgressIndicator(),
            );

          List<PaymentMethod> value = settlePageBloc.methods.value!;
          List<Widget> widgets = [];
          for (PaymentMethod payment in value) {
            widgets.add(
              RadioListTile(
                value: payment,
                groupValue: paymentMethod,
                title: Text(
                  payment.name,
                ),
                onChanged: (values) {
                  setState(() {
                    paymentMethod = values as PaymentMethod;
                  });
                },
                selected: paymentMethod == payment,
              ),
            );
          }

          return Column(
            children: widgets,
          );
        },
      ),
    );
  }

  Widget landscape() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  width: 230,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 5,
                            ),
                          ),
                          child: Keypad(
                            key: _globalKeyPadKey,
                            EnterText: 'Enter Price',
                            maxLength: 3,
                            onChange: (s) {},
                            isButtonOfDotInclude: true,
                          ),
                        ),
                      ),
                      Expanded(
                        child: suggestionPrices(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[Expanded(child: paymentMethods()), Expanded(child: payments())],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 3, bottom: 3),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 150,
                  child: PrimaryButton(
                    onTap: () {
                      widget.onCancel!();
                    },
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 150,
                  child: PrimaryButton(
                    onTap: () {
                      settlePageBloc.eventSink.add(
                        ConfirmPayment(),
                      );
                    },
                    text: "Confirm",
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget suggestionPrices() {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 5,
        ),
      ),
      child: StreamBuilder(
        stream: settlePageBloc.priceSuggestion.stream,
        initialData: settlePageBloc.priceSuggestion.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (settlePageBloc.priceSuggestion.value == null || settlePageBloc.priceSuggestion.value!.length == 0)
            return Center(
              child: CircularProgressIndicator(),
            );

          List<double> value = settlePageBloc.priceSuggestion.value!;

          return GridView.builder(
            itemCount: settlePageBloc.priceSuggestion.value!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.1),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                      onTap: () {
                        _globalKeyPadKey.currentState!.updateNumber(value[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7.0),
                            )),
                        // color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(Number.getNumber(value[index]), softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 24)),
                        ),
                      )),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: PrimaryButton(
                    onTap: () {
                      _globalKeyPadKey.currentState!.updateNumber(value[index]);
                    },
                    text: Number.getNumber(value[index]),
                    fontSize: 24),
              );
            },
          );
        },
      ),
    );
  }

  Widget paymentMethods() {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 5,
        ),
      ),
      child: StreamBuilder(
        stream: settlePageBloc.methods.stream,
        initialData: settlePageBloc.methods.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (settlePageBloc.methods.value == null || settlePageBloc.methods.value!.length == 0)
            return Center(
              child: CircularProgressIndicator(),
            );

          List<PaymentMethod> value = settlePageBloc.methods.value!;
          return GridView.builder(
            itemCount: value.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1, crossAxisCount: 4),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                      onTap: () {
                        if (_globalKeyPadKey.currentState!.text != null && _globalKeyPadKey.currentState!.text != "") {
                          settlePageBloc.eventSink.add(
                            MethodClicked(
                              value[index],
                              double.parse(_globalKeyPadKey.currentState!.text),
                            ),
                          );
                          _globalKeyPadKey.currentState!.clear();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            )),
                        // color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Image.asset(
                                  "assets/icons/cash.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(value[index].name, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, height: 1, fontWeight: FontWeight.w900, fontSize: 24)),
                            ],
                          ),
                        ),
                      )),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                    onTap: () {
                      if (_globalKeyPadKey.currentState!.text != null && _globalKeyPadKey.currentState!.text != "") {
                        settlePageBloc.eventSink.add(
                          MethodClicked(
                            value[index],
                            double.parse(_globalKeyPadKey.currentState!.text),
                          ),
                        );
                        _globalKeyPadKey.currentState!.clear();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          )),
                      // color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(value[index].name, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, height: 1, fontWeight: FontWeight.w900, fontSize: 24)),
                      ),
                    )),
              );
            },
          );
        },
      ),
    );
  }

  Widget paymentMethodsPortrait() {
    return Container(
      margin: EdgeInsets.all(2),
      child: StreamBuilder(
        stream: settlePageBloc.methods.stream,
        initialData: settlePageBloc.methods.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (settlePageBloc.methods.value == null || settlePageBloc.methods.value!.length == 0)
            return Center(
              child: CircularProgressIndicator(),
            );

          List<PaymentMethod>? value = settlePageBloc.methods.value;
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: value!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 1,
              crossAxisSpacing: 2.0,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                    onTap: () {
                      settlePageBloc.eventSink.add(
                        MethodClicked(
                          value[index],
                          double.parse(_globalKeyPadKey.currentState!.text),
                        ),
                      );
                      _globalKeyPadKey.currentState!.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          )),
                      // color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Image.asset(
                                "assets/icons/cash.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Text(value[index].name, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, height: 1, fontWeight: FontWeight.w900, fontSize: 14)),
                          ],
                        ),
                      ),
                    ));
              }
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                    onTap: () {
                      if (_globalKeyPadKey.currentState!.text == "") return;
                      settlePageBloc.eventSink.add(
                        MethodClicked(
                          value[index],
                          double.parse(_globalKeyPadKey.currentState!.text),
                        ),
                      );

                      _globalKeyPadKey.currentState!.clear();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          )),
                      // color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(value[index].name, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).primaryColor, height: 1, fontWeight: FontWeight.w900, fontSize: 14)),
                      ),
                    )),
              );
            },
          );
        },
      ),
    );
  }

  Widget payments() {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Equivalent',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: settlePageBloc.payments.stream,
              initialData: settlePageBloc.payments.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListView.builder(
                  itemExtent: 50,
                  itemCount: settlePageBloc.payments.value!.length,
                  itemBuilder: (context, index) {
                    OrderPayment temp = settlePageBloc.payments.value![index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              Misc.toShortDateTime(temp.date_time!),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              (temp.method == null) ? "" : temp.method!.name.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              Number.getNumber(temp.amount_paid),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              Number.getNumber(temp.actualAmountPaid),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: PrimaryButton(
                              text: "X",
                              onTap: () {
                                settlePageBloc.eventSink.add(CancelPayment(temp));
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget suggestionPricesPortrait() {
    return Container(
      margin: EdgeInsets.only(right: 2, top: 2, bottom: 2),
      child: StreamBuilder(
        stream: settlePageBloc.priceSuggestion.stream,
        initialData: settlePageBloc.priceSuggestion.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (settlePageBloc.priceSuggestion.value == null || settlePageBloc.priceSuggestion.value!.length == 0)
            return Center(
              child: CircularProgressIndicator(),
            );

          List<double> value = settlePageBloc.priceSuggestion.value!;

          return GridView.builder(
            itemCount: settlePageBloc.priceSuggestion.value!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 1),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                      onTap: () {
                        print(value[index]);
                        _globalKeyPadKey.currentState!.updateNumber(value[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(
                              Radius.circular(7.0),
                            )),
                        // color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(Number.getNumber(value[index]), softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 24)),
                        ),
                      )),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: PrimaryButton(
                    onTap: () {
                      _globalKeyPadKey.currentState!.updateNumber(value[index]);
                    },
                    text: Number.getNumber(value[index]),
                    fontSize: 24),
              );
            },
          );
        },
      ),
    );
  }
}
