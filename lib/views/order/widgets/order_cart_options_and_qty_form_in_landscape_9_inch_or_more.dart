import "package:flutter/material.dart";
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_state.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/widgets/buttons/secondary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

GlobalKey<KeypadState> _globalKeyPadKey = new GlobalKey();

class OrderCartOptionsInLandscape9Inch extends StatefulWidget {
  final OrderPageBloc orderPageBloc;
  OrderCartOptionsInLandscape9Inch(this.orderPageBloc);
  @override
  State<StatefulWidget> createState() {
    return _OrderCartOptionsInLandscape9InchState();
  }
}

class _OrderCartOptionsInLandscape9InchState extends State<OrderCartOptionsInLandscape9Inch> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.orderPageBloc.qty.stream.listen((data) {
      if (_globalKeyPadKey.currentState != null) {
        _globalKeyPadKey.currentState!.setState(() {
          _globalKeyPadKey.currentState!.text = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: widget.orderPageBloc.option.stream,
              initialData: widget.orderPageBloc.option.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                OrderPageOptionState? temp = widget.orderPageBloc.option.value;
                OrderTransaction? transaction = widget.orderPageBloc.order.value!.itemSelected.value;
                if (temp is QuickModifierOption) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3 / 2,
                            crossAxisCount: 2,
                          ),
                          itemCount: temp.modifiers!.length,
                          itemBuilder: (context, index) {
                            return SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.eventSink.add(AddTransactionModifier(temp.modifiers![index]));
                              },
                              text: temp.modifiers![index].name,
                              isBorderRounded: true,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: transaction!.isNew
                                  ? SecondaryButton(
                                      onTap: () {
                                        widget.orderPageBloc.popup.sinkValue(ModifierListPanel());
                                      },
                                      text: AppLocalizations.of(context)!.translate("Extra Modifiers"),
                                      isBorderRounded: true,
                                    )
                                  : SizedBox(),
                            ),
                            Expanded(
                              child: transaction.isNew
                                  ? SecondaryButton(
                                      onTap: () {
                                        widget.orderPageBloc.eventSink.add(ShowShortNote());
                                      },
                                      text: AppLocalizations.of(context)!.translate("Short Note"),
                                      isBorderRounded: true,
                                    )
                                  : SizedBox(),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else if (temp is ItemOption && transaction != null) {
                  return GridView.count(
                    childAspectRatio: 3 / 2,
                    crossAxisCount: 2,
                    children: <Widget>[
                      transaction.isNew
                          ? SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.eventSink.add(IncreaseTransactionQty());
                              },
                              text: AppLocalizations.of(context)!.translate("Increase Qty"),
                              isBorderRounded: true,
                            )
                          : SizedBox(),
                      transaction.isNew
                          ? SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.eventSink.add(DecreaseTransactionQty());
                              },
                              text: AppLocalizations.of(context)!.translate("Decrease Qty"),
                              isBorderRounded: true,
                            )
                          : SizedBox(),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(AdjTransactionPrice());
                        },
                        text: AppLocalizations.of(context)!.translate("Adj Price"),
                        isBorderRounded: true,
                      ),
                      transaction.isNew
                          ? SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.eventSink.add(AdjTransactionQty());
                              },
                              text: AppLocalizations.of(context)!.translate("Adj Qty"),
                              isBorderRounded: true,
                            )
                          : SizedBox(),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(OrderDiscountItem());
                        },
                        text: (transaction.discount_amount > 0) ? "Remove Discount" : AppLocalizations.of(context)!.translate("Discount Item"),
                        isBorderRounded: true,
                      ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(ReOrderTransaction());
                        },
                        text: AppLocalizations.of(context)!.translate("Re Order"),
                        isBorderRounded: true,
                      ),
                      (transaction.isNew && transaction.hold_time == null)
                          ? SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.eventSink.add(HoldUntilFire());
                              },
                              text: AppLocalizations.of(context)!.translate("Hold Until Fire"),
                              isBorderRounded: true,
                            )
                          : Center(),
                      (transaction.hold_time != null)
                          ? SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.eventSink.add(HoldUntilFire());
                              },
                              text: AppLocalizations.of(context)!.translate("Fire"),
                              isBorderRounded: true,
                            )
                          : Center(),
                      transaction.isNew
                          ? SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.popup.sinkValue(ModifierListPanel());
                              },
                              text: AppLocalizations.of(context)!.translate("Extra Modifiers"),
                              isBorderRounded: true,
                            )
                          : SizedBox(),
                      transaction.isNew
                          ? SecondaryButton(
                              onTap: () {
                                widget.orderPageBloc.eventSink.add(ShowShortNote());
                              },
                              text: AppLocalizations.of(context)!.translate("Short Note"),
                              isBorderRounded: true,
                            )
                          : SizedBox(),
                    ],
                  );
                } else if (temp is OrderPageOption) {
                  return GridView.count(
                    childAspectRatio: 3 / 2,
                    crossAxisCount: 2,
                    children: <Widget>[
                      // SecondaryButton(
                      //   text: AppLocalizations.of(context)
                      //       !.translate("Split Ticket"),
                      //   isBorderRounded: true,
                      // ),
                      // SecondaryButton(
                      //   text: AppLocalizations.of(context)
                      //       !.translate("Merge Order"),
                      //   isBorderRounded: true,
                      // ),
                      // SecondaryButton(
                      //   text:
                      //       AppLocalizations.of(context)!.translate("Ready At"),
                      //   isBorderRounded: true,
                      // ),
                      // SecondaryButton(
                      //   text: AppLocalizations.of(context)
                      //       !.translate("Add Change Customer"),
                      //   isBorderRounded: true,
                      // ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(AddTag());
                        },
                        text: AppLocalizations.of(context)!.translate("Add Tag"),
                        isBorderRounded: true,
                      ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(SurchargeOrder());
                        },
                        text: (widget.orderPageBloc.order.value!.surcharge_amount > 0)
                            ? "Remove Subcharge"
                            : AppLocalizations.of(context)!.translate("Add Subcharge"),
                        isBorderRounded: true,
                      ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(AdjGuestNumber());
                        },
                        text: "Adj Guest Number",
                        isBorderRounded: true,
                      ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(VoidOrder());
                        },
                        text: AppLocalizations.of(context)!.translate("Void Ticket"),
                        isBorderRounded: true,
                      ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(DiscountOrder());
                        },
                        text: (widget.orderPageBloc.order.value!.discount_amount > 0)
                            ? "Remove Discount"
                            : AppLocalizations.of(context)!.translate("Discount Order"),
                        isBorderRounded: true,
                      ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(AddCustomer());
                        },
                        text: AppLocalizations.of(context)!.translate("Add/Change Customer"),
                        isBorderRounded: true,
                      ),
                      SecondaryButton(
                        onTap: () {
                          widget.orderPageBloc.eventSink.add(SearchItem());
                        },
                        text: AppLocalizations.of(context)!.translate("Search Item"),
                        isBorderRounded: true,
                      ),
                      // SecondaryButton(
                      //   text:
                      //       AppLocalizations.of(context)!.translate("Auto Hold"),
                      //   isBorderRounded: true,
                      // ),
                    ],
                  );
                } else {
                  return Center();
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 5,
                  ),
                ),
              ),
              child: Keypad(
                key: _globalKeyPadKey,
                EnterText: AppLocalizations.of(context)!.translate('Enter Quantity'),
                maxLength: 3,
                onChange: (s) {
                  widget.orderPageBloc.qty.sinkValue(s);
                },
                isButtonOfHalfInclude: widget.orderPageBloc.isHalfItemEnabled,
              ),
            ),
          )
        ],
      ),
    );
  }
}
