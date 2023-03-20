import 'package:flutter/material.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/order/TransactionModifier.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/widgets/order_cart/close_button.dart';
import 'dart:convert';

import 'package:invo_mobile/widgets/translation/app_localizations.dart';

typedef Transaction2VoidFunc = void Function(OrderTransaction temp);
typedef Modifer2VoidFunc = void Function(TransactionModifier modifier);

class OrderCart extends StatefulWidget {
  final bool isOrderCartInDialog;
  final OrderHeader order;
  final Transaction2VoidFunc? onDelete;
  final Transaction2VoidFunc? onItemClicked;
  final Modifer2VoidFunc? onModifierDelete;
  final Transaction2VoidFunc? onDiscountDelete;

  const OrderCart({Key? key, this.isOrderCartInDialog = false, required this.order, this.onItemClicked, this.onModifierDelete, this.onDiscountDelete, this.onDelete}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderCartState();
  }
}

class OrderCartState extends State<OrderCart> {
  final _transactionListKey = GlobalKey<AnimatedListState>();
  ScrollController transactionController = ScrollController();
  ScrollController scrollController = ScrollController();
  late Preference preference;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preference = locator.get<ConnectionRepository>().preference!;
    widget.order.itemAdded.stream.listen((data) {
      if (mounted) {
        setState(() {});
        transactionController.animateTo(
          transactionController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      // if (_transactionListKey.currentState != null) {
      //   _transactionListKey.currentState.insertItem(
      //       widget.order.transaction.length - 1,
      //       duration: Duration(milliseconds: 100));

      //   Timer(Duration(milliseconds: 200), () {
      //     transactionController.animateTo(
      //       transactionController.position.maxScrollExtent,
      //       curve: Curves.easeOut,
      //       duration: const Duration(milliseconds: 200),
      //     );
      //   });
      // }
    });

    widget.order.itemUpdated.stream.listen((data) {
      if (mounted) {
        setState(() {});

        transactionController.animateTo(
          transactionController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      // if (_transactionListKey.currentState != null) {
      //   _transactionListKey.currentState.setState(() {});

      //   Timer(Duration(milliseconds: 120), () {
      //     double height = 0;
      //     for (var i = 0; i < widget.order.transaction.indexOf(data) - 1; i++) {
      //       height += 25;
      //       for (var item in widget.order.transaction[i].modifiers) {
      //         height += 25;
      //       }
      //     }

      //     transactionController.animateTo(
      //       height,
      //       curve: Curves.easeOut,
      //       duration: const Duration(milliseconds: 200),
      //     );
      //   });
      // }
    });

    widget.order.itemRemoved.stream.listen((deletedItem) {
      if (mounted) {
        setState(() {});

        transactionController.animateTo(
          transactionController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      // if (_transactionListKey.currentState != null) {
      //   _transactionListKey.currentState.removeItem(deletedItem.index,
      //       (context, animation) {
      //     //return _buildItem(deletedItem.item, animation);
      //   });
      // }
    });
  }

  @override
  void didUpdateWidget(OrderCart oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    widget.order.itemAdded.stream.listen((data) {
      if (mounted) {
        setState(() {});

        transactionController.animateTo(
          transactionController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      // if (_transactionListKey.currentState != null) {
      //   _transactionListKey.currentState.insertItem(
      //       widget.order.transaction.length - 1,
      //       duration: Duration(milliseconds: 100));

      //   Timer(Duration(milliseconds: 200), () {
      //     transactionController.animateTo(
      //       transactionController.position.maxScrollExtent,
      //       curve: Curves.easeOut,
      //       duration: const Duration(milliseconds: 200),
      //     );
      //   });
      // }
    });

    widget.order.itemUpdated.stream.listen((data) {
      if (mounted) {
        setState(() {});

        transactionController.animateTo(
          transactionController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      // if (_transactionListKey.currentState != null) {
      //   _transactionListKey.currentState.setState(() {});

      //   Timer(Duration(milliseconds: 120), () {
      //     double height = 0;
      //     for (var i = 0; i < widget.order.transaction.indexOf(data) - 1; i++) {
      //       height += 25;
      //       for (var item in widget.order.transaction[i].modifiers) {
      //         height += 25;
      //       }
      //     }

      //     transactionController.animateTo(
      //       height,
      //       curve: Curves.easeOut,
      //       duration: const Duration(milliseconds: 200),
      //     );
      //   });
      // }
    });

    widget.order.itemRemoved.stream.listen((deletedItem) {
      if (mounted) {
        setState(() {});

        transactionController.animateTo(
          transactionController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      // if (_transactionListKey.currentState != null) {
      //   _transactionListKey.currentState.removeItem(deletedItem.index,
      //       (context, animation) {
      //     //return _buildItem(deletedItem.item, animation);
      //   });
      // }
    });
    // widget.order.itemAdded.stream.listen((data) {
    //   setState(() {});
    //   if (_transactionListKey.currentState != null) {
    //     _transactionListKey.currentState.insertItem(
    //         widget.order.transaction.length - 1,
    //         duration: Duration(milliseconds: 100));

    //     Timer(Duration(milliseconds: 200), () {
    //       transactionController.animateTo(
    //         transactionController.position.maxScrollExtent,
    //         curve: Curves.easeOut,
    //         duration: const Duration(milliseconds: 200),
    //       );
    //     });
    //   }
    // });

    // widget.order.itemUpdated.stream.listen((data) {
    //   if (_transactionListKey.currentState != null) {
    //     _transactionListKey.currentState.setState(() {});

    //     Timer(Duration(milliseconds: 120), () {
    //       double height = 0;
    //       for (var i = 0; i < widget.order.transaction.indexOf(data) - 1; i++) {
    //         height += 25;
    //         for (var item in widget.order.transaction[i].modifiers) {
    //           height += 25;
    //         }
    //       }

    //       transactionController.animateTo(
    //         height,
    //         curve: Curves.easeOut,
    //         duration: const Duration(milliseconds: 200),
    //       );
    //     });
    //   }
    // });

    // widget.order.itemRemoved.stream.listen((deletedItem) {
    //   if (_transactionListKey.currentState != null) {
    //     _transactionListKey.currentState.removeItem(deletedItem.index,
    //         (context, animation) {
    //       // return _buildItem(deletedItem.item, animation);
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.empty(growable: true);
    for (var item in widget.order.transaction) {
      widgets.add(_buildItem(item));
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Card header

          StreamBuilder(
            stream: widget.order.headerUpdate.stream,
            initialData: widget.order.headerUpdate.value,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (widget.order == null) {
                return Center();
              } else {
                var orderLabel = "Order:" + widget.order.id.toString() + " (" + widget.order.ticket_number.toString() + ")";
                if (widget.order.prepared_date != null) {
                  orderLabel = orderLabel + " (✓)";
                }

                return Container(
                  height: (widget.order.customer == null) ? 45 : 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // column of order header information

                      Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            controller: transactionController,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                              // row  1
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //order number
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      orderLabel,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ), //ticket number
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        widget.order.service != null
                                            ? widget.order.service!.serviceName! + (widget.order.dinein_table != null ? " Table:" + widget.order.dinein_table!.name.toString() : "")
                                            : "" + (widget.order.dinein_table != null ? " Table:" + widget.order.dinein_table!.name.toString() : ""),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      )),
                                ],
                              ),

                              // row  2
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //employee text
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      widget.order.employee != null ? widget.order.employee!.name : "",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ), //type of service
                                  Expanded(
                                      child: Text(
                                    ((widget.order.Label == null || widget.order.Label == "") ? "" : "label : " + widget.order.Label.toString()),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  )),
                                ],
                              ),

                              // row 3
                              ((widget.order.customer != null && widget.order.customer!.id_number > 0))
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //customer text
                                        (widget.order.customer!.name != null)
                                            ? Expanded(
                                                flex: 2,
                                                child: Text(
                                                  widget.order.customer!.name.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                ),
                                              )
                                            : SizedBox(),

                                        //label
                                        (widget.order.customer_contact != null)
                                            ? Expanded(
                                                child: Text(
                                                  widget.order.customer_contact.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    )
                                  : SizedBox(),

                              (widget.order.customer_address != null)
                                  ? Text(
                                      widget.order.customer_address.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    )
                                  : SizedBox(),

                              // // row 4
                              (widget.order.no_of_guests >= 1)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //customer mobile
                                        Expanded(
                                          child: Text(
                                            "Guests:" + widget.order.no_of_guests.toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                        ), //label
                                      ],
                                    )
                                  : SizedBox(),
                            ]),
                          )),

                      (widget.isOrderCartInDialog)
                          ? Expanded(
                              child: OrderCartCloseButton(
                                isOrderCartInDailog: widget.isOrderCartInDialog,
                              ),
                            )
                          : SizedBox()
                      // PrimaryButton(
                      //     text: "Scan",
                      //     onTap: () {
                      //       FlutterBarcodeScanner.getBarcodeStreamReceiver(
                      //               "#ff6666",
                      //               "Cancel",
                      //               false,
                      //               ScanMode.BARCODE)
                      //           .listen((barcode) {
                      //             print(barcode);
                      //         /// barcode to be used
                      //       });
                      //     },
                      //   )
                    ],
                  ),
                );
              }
            },
          ),

          // card horizenalline
          Divider(
            color: Colors.black,
            height: 1,
          ),

          // orders items
          Container(
            child: Expanded(
              flex: 3,
              child: ListView(
                shrinkWrap: true,
                children: widgets,
              ),
            ),
          ),

          Divider(
            color: Colors.black,
          ),

          // Total
          StreamBuilder(
            stream: widget.order.footerUpdate.stream,
            initialData: widget.order.footerUpdate.value,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Widget> list = List<Widget>.empty(growable: true);
              double fontSize = 16;

              if (widget.order.isItemTotalVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate("Item Total"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.item_total),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isChargePerHourVisible && widget.order.isMinChargeVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Charge Per Hour" + "(" + (widget.order.total_charge_per_hour! / widget.order.charge_per_hour).round().toString() + "h)",
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

              if (widget.order.isMinChargeVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Minimum Charge'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.min_charge),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: Colors.red),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isDiscountVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Discount'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.discount_actual_amount),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }
              if (widget.order.isSurchargeVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Surcharge'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.surcharge_actual_amount),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isDeliveryChargeVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Delivery Charge'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.delivery_charge),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isTax3Visible) {
                print(preference.tax3Alias.toString() + " Collected");
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
                      Number.formatCurrency(widget.order.total_tax3),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isSubTotalVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Sub Total'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.sub_total_price),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isTaxVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      preference.tax1Alias.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.total_tax),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isTax2Visible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      preference.tax2Alias.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.total_tax2),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isRoundingVisible) {
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
                      Number.formatCurrency(widget.order.Rounding),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              list.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate('Total'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF068102)),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    ((widget.order.grand_price != null) ? Number.formatCurrency(widget.order.grand_price) : Number.formatCurrency(0)),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Color(0xFF068102)),
                    textAlign: TextAlign.end,
                  ),
                ],
              ));

              if (widget.order.amountTendered > 0) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Tendered'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.amountTendered),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.isBalanceVisible) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Balance'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.amountBalance),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ));
              }

              if (widget.order.amountTendered >= (widget.order.grand_price == null ? 0 : widget.order.grand_price) && widget.order.amountChange >= 0) {
                list.add(Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Change'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      Number.formatCurrency(widget.order.amountChange),
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
                children: list,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem(OrderTransaction item) {
    return StreamBuilder(
      stream: widget.order.itemSelected.stream,
      initialData: widget.order.itemSelected.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Decoration decoration = BoxDecoration();
        int maxLine = 1;
        double height = 25;
        if (widget.order.itemSelected.value == item) {
          decoration = BoxDecoration(border: Border.all(width: 2));
          maxLine = 2;
          height = 40;
        }

        String secondaryLang = locator.get<ConnectionRepository>().preference!.secondary_lang_code;
        String lang = locator.get<ConnectionRepository>().terminal!.langauge ?? "";

        String itemName = item.menu_item!.name!;
        if (lang == secondaryLang && item.menu_item!.secondary_name != null && item.menu_item!.secondary_name!.isNotEmpty) {
          itemName = item.menu_item!.secondary_name!;
        }

        List<Widget> list = List<Widget>.empty(growable: true);
        //item
        list.add(
          Container(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                (item.status == 2)
                    ? Container(
                        color: Colors.red,
                        height: 5,
                      )
                    : SizedBox(),
                Row(
                  children: <Widget>[
                    item.hold_time != null
                        ? Expanded(
                            child: Icon(Icons.access_time),
                          )
                        : Center(),
                    // item quentity
                    Expanded(
                      child: Text(
                        item.qtyString.toString() + (((item.menu_item!.order_By_Weight != null) && item.menu_item!.order_By_Weight!) ? ((item.menu_item!.weight_unit == null) ? "Kg" : item.menu_item!.weight_unit!) : ""),
                        style: TextStyle(color: (item.isNew) ? Colors.black54 : Color(0xFF0000FF), fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    // item text

                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              itemName,
                              maxLines: maxLine,
                              style: TextStyle(
                                height: 1,
                                color: (item.isNew) ? Colors.black54 : Color(0xFF0000FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          (item.prepared_date != null) ? Icon(Icons.check, size: 24, color: Colors.green[200]) : SizedBox(),
                        ],
                      ),
                    ),

                    // space

                    // item quentity

                    Expanded(
                      flex: 2,
                      child: Text(
                        Number.getNumber(item.grand_price),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: TextStyle(color: (item.isNew) ? Colors.black54 : Color(0xFF0000FF), height: 1, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),

                    (widget.onDelete != null && widget.order.itemSelected.value == item && item.status == 1)
                        ? Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                widget.onDelete!(item);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "X",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        );

        if (item.status == 1) {
          if (item.discount_amount > 0) {
            list.add(Container(
              height: height,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),

                  // item text
                  Expanded(
                    flex: 5,
                    child: Text(
                      ((item.discount != null) ? item.discount!.name : "Discount") + " (" + Number.getNumber(item.discount_actual_price) + ")",
                      maxLines: maxLine,
                      style: TextStyle(color: (item.isNew) ? Colors.black54 : Colors.brown, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  (widget.order.itemSelected.value == item)
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              if (widget.onDiscountDelete != null) widget.onDiscountDelete!(item);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "X",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ));
          }

          for (var modifier in item.modifiers!) {
            String? modifierDisplay = modifier.display!;
            if (lang == secondaryLang && modifier.modifier?.secondary_display_name != null && modifier.modifier!.secondary_display_name!.isNotEmpty) {
              modifierDisplay = modifier.modifier?.secondary_display_name!;
            }
            list.add(Container(
              height: height,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),

                  // item text
                  Expanded(
                    flex: 5,
                    child: Text(
                      (modifier.qty > 1 ? modifier.qty.toInt().toString() + "X " : "") + (modifierDisplay!) + ((modifier.actual_price > 0) ? " - Ex " + Number.getNumber(modifier.actual_price) : ""),
                      maxLines: maxLine,
                      style: TextStyle(color: (item.isNew) ? Colors.black54 : Colors.brown, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  (widget.onModifierDelete != null && !modifier.isForced && widget.order.itemSelected.value == item)
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              if (widget.onModifierDelete != null) widget.onModifierDelete!(modifier);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "X",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ));
          }

          for (var subItem in item.sub_menu_item!) {
            list.add(Container(
              height: height,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),

                  // item text
                  Expanded(
                    flex: 5,
                    child: Text(
                      subItem.menu_item!.name!,
                      maxLines: maxLine,
                      style: TextStyle(color: (item.isNew) ? Colors.black54 : Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ));

            for (var modifier in subItem.modifiers!) {
              list.add(Container(
                height: height,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(""),
                    ),

                    // item text
                    Expanded(
                      flex: 5,
                      child: Text(
                        modifier.modifier!.display! + (modifier.modifier!.additional_price == 0.0 ? "" : " Ex " + Number.getNumber(modifier.modifier!.additional_price).toString()),
                        maxLines: maxLine,
                        style: TextStyle(color: (item.isNew) ? Colors.black54 : Colors.brown, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    // (widget.order.id == 0 &&
                    //         widget.onModifierDelete != null &&
                    //         !modifier.isForced &&
                    //         widget.order.itemSelected.value == item)
                    //     ? Expanded(
                    //         flex: 1,
                    //         child: InkWell(
                    //           onTap: () {
                    //             if (widget.onModifierDelete != null)
                    //               widget.onModifierDelete(modifier);
                    //           },
                    //           child: Container(
                    //             margin: EdgeInsets.all(5),
                    //             height: 40,
                    //             width: 40,
                    //             decoration: BoxDecoration(
                    //               color: Theme.of(context).primaryColor,
                    //               borderRadius: BorderRadius.all(
                    //                 Radius.circular(5),
                    //               ),
                    //             ),
                    //             child: Center(
                    //               child: Text(
                    //                 "X",
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : SizedBox(),
                  ],
                ),
              ));
            }
          }
        }
        return InkWell(
          onTap: () {
            if (widget.onItemClicked != null && (item.status == 1)) widget.onItemClicked!(item);
          },
          child: Container(
            decoration: decoration,
            child: Column(
              children: list,
            ),
          ),
        );
      },
    );
  }
}
