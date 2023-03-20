import "package:flutter/material.dart";
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_state.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class OrderCartOptionsInLandscape7Inch extends StatefulWidget {
  // this paramerter use to store value of selection of user ( qty form , ticket options , item modifiers )
  final OrderPageBloc orderPageBloc;
  const OrderCartOptionsInLandscape7Inch({Key? key, required this.orderPageBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OrderCartOptionsInLandscape7InchState();
  }
}

class _OrderCartOptionsInLandscape7InchState extends State<OrderCartOptionsInLandscape7Inch> {
  late String text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), border: Border.all(color: Theme.of(context).primaryColor, width: 3)),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  text = "";
                  widget.orderPageBloc.qty.sinkValue("");
                  // widget.orderPageBloc.option.sinkValue(null);
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: StreamBuilder(
                  stream: widget.orderPageBloc.qty.stream,
                  initialData: widget.orderPageBloc.qty.value,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Text(
                      (widget.orderPageBloc.qty.value! != null && widget.orderPageBloc.qty.value! != "")
                          ? widget.orderPageBloc.qty.value!
                          : AppLocalizations.of(context)!.translate('Qty'),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            ),
            Expanded(child: getOption(context)),
            // InkWell(
            //   onTap: () {
            //     widget.orderPageBloc.popup.sinkValue(ModifierListPanel());
            //   },
            //   child: Container(
            //     padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            //     child: Text(
            //       AppLocalizations.of(context)!.translate('Extra'),
            //       style: TextStyle(
            //           color: Colors.black, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // Divider(
            //   color: Colors.grey,
            // ),
            // InkWell(
            //   child: Container(
            //     padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            //     child: Text(
            //       AppLocalizations.of(context)!.translate('Note'),
            //       style: TextStyle(
            //           color: Colors.black, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget getOption(BuildContext context) {
    Widget _numberWidget = numbersWidget();
    return StreamBuilder(
        stream: widget.orderPageBloc.option.stream,
        initialData: widget.orderPageBloc.option.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          OrderPageOptionState temp = widget.orderPageBloc.option.value!;
          OrderTransaction transaction = widget.orderPageBloc.order.value!.itemSelected.value!;
          if (temp is QuickModifierOption) {
            return quickModifiers(temp);
          } else if (temp is ItemOption && transaction != null) {
            return itemOption(transaction);
          } else if (temp is OrderPageOption) {
            return orderOption();
          } else {
            return _numberWidget;
          }
        });

    // } else {
    //
    // }
  }

  Widget itemOption(OrderTransaction transaction) {
    return ListView(
      children: <Widget>[
        transaction.isNew
            ? optionButton(
                onTap: () {
                  widget.orderPageBloc.eventSink.add(IncreaseTransactionQty());
                },
                text: AppLocalizations.of(context)!.translate("Increase Qty"),
              )
            : SizedBox(),
        transaction.isNew
            ? optionButton(
                onTap: () {
                  widget.orderPageBloc.eventSink.add(DecreaseTransactionQty());
                },
                text: AppLocalizations.of(context)!.translate("Decrease Qty"),
              )
            : SizedBox(),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(AdjTransactionPrice());
          },
          text: AppLocalizations.of(context)!.translate("Adj Price"),
        ),
        transaction.isNew
            ? optionButton(
                onTap: () {
                  widget.orderPageBloc.eventSink.add(AdjTransactionQty());
                },
                text: AppLocalizations.of(context)!.translate("Adj Qty"),
              )
            : SizedBox(),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(OrderDiscountItem());
          },
          text: (transaction.discount_amount > 0) ? "Remove Discount" : AppLocalizations.of(context)!.translate("Discount Item"),
        ),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(ReOrderTransaction());
          },
          text: AppLocalizations.of(context)!.translate("Re Order"),
        ),
        (transaction.isNew && transaction.hold_time == null)
            ? optionButton(
                onTap: () {
                  widget.orderPageBloc.eventSink.add(HoldUntilFire());
                },
                text: AppLocalizations.of(context)!.translate("Hold Until Fire"),
              )
            : Center(),
        (transaction.hold_time != null)
            ? optionButton(
                onTap: () {
                  widget.orderPageBloc.eventSink.add(HoldUntilFire());
                },
                text: AppLocalizations.of(context)!.translate("Fire"),
              )
            : Center(),
        transaction.isNew
            ? optionButton(
                onTap: () {
                  widget.orderPageBloc.popup.sinkValue(ModifierListPanel());
                },
                text: AppLocalizations.of(context)!.translate("Extra Modifiers"),
              )
            : SizedBox(),
        transaction.isNew
            ? optionButton(
                onTap: () {
                  widget.orderPageBloc.eventSink.add(ShowShortNote());
                },
                text: AppLocalizations.of(context)!.translate("Short Note"),
              )
            : SizedBox(),
      ],
    );
  }

  Widget orderOption() {
    return ListView(
      children: <Widget>[
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(AddTag());
          },
          text: AppLocalizations.of(context)!.translate("Add Tag"),
        ),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(AdjGuestNumber());
          },
          text: "Adj Guest Number",
        ),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(SurchargeOrder());
          },
          text: (widget.orderPageBloc.order.value!.surcharge_amount > 0)
              ? "Remove Surcharge"
              : AppLocalizations.of(context)!.translate("Add Subcharge"),
        ),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(VoidOrder());
          },
          text: AppLocalizations.of(context)!.translate("Void Ticket"),
        ),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(DiscountOrder());
          },
          text:
              (widget.orderPageBloc.order.value!.discount_amount > 0) ? "Remove Discount" : AppLocalizations.of(context)!.translate("Discount Order"),
        ),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(AddCustomer());
          },
          text: AppLocalizations.of(context)!.translate("Add/Change Customer"),
        ),
        optionButton(
          onTap: () {
            widget.orderPageBloc.eventSink.add(SearchItem());
          },
          text: AppLocalizations.of(context)!.translate("Search Item"),
        ),
      ],
    );
  }

  Widget optionButton({required String text, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 50,
          padding: EdgeInsets.all(5),
          color: Colors.grey[400],
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  Widget quickModifiers(QuickModifierOption event) {
    return ListView.builder(
      itemCount: event.modifiers!.length,
      itemBuilder: (BuildContext conttext, int index) {
        return InkWell(
          onTap: () {
            widget.orderPageBloc.eventSink.add(AddTransactionModifier(event.modifiers![index]));
          },
          child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              color: Colors.grey[400],
              child: Center(
                child: Text(
                  event.modifiers![index].display ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        );
      },
    );
  }

  Widget numbersWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("1");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "1",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("2");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "2",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("3");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "3",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("4");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "4",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("5");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "5",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("6");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "6",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("7");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "7",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("8");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "8",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("9");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "9",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              numberClicked("0");
            },
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  void numberClicked(String number) {
    if (text == null) text = "";
    if (text.length < 3) {
      this.text = this.text + number;
    }

    widget.orderPageBloc.qty.sinkValue(this.text);
  }
}

// this function appear widget based of status
// if user doesn't select the item it will show qty form
// if user select the item it will show modifiers of item
