import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_state.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/views/order/widgets/list_of_groups.dart';
import 'package:invo_mobile/views/order/widgets/list_of_items.dart';
import 'package:invo_mobile/views/order/widgets/menu_selection.dart';
import 'package:invo_mobile/views/order/widgets/modifier_button.dart';
import 'package:invo_mobile/views/order/widgets/modifier_list.dart';
import 'package:invo_mobile/views/order/widgets/popup_modifiers.dart';
import 'package:invo_mobile/views/order/widgets/search_item.dart';
import 'package:invo_mobile/views/order/widgets/ticket.dart';
import 'package:invo_mobile/widgets/buttons/secondary_button.dart';
import 'package:invo_mobile/widgets/customer/customer_panel.dart';
import 'package:invo_mobile/widgets/discount/discount_list.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart_buttons.dart';
import 'package:invo_mobile/widgets/pay_panel/pay_panel.dart';
import 'package:invo_mobile/widgets/surcharge/surcharge_list.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderPagePortrait extends StatefulWidget {
  final bool isServiceDineIn;

  const OrderPagePortrait({Key? key, this.isServiceDineIn = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderPagePortraitState();
  }
}

class _OrderPagePortraitState extends State<OrderPagePortrait> {
  late OrderPageBloc orderPageBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderPageBloc = BlocProvider.of<OrderPageBloc>(context);
    orderPageBloc.popup.stream.listen((s) async {
      if (s is DiscountPanel) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: DiscountList(
                discounts: s.discounts,
                onDiscountClick: (Discount discount) {
                  if (s.orderDiscount)
                    orderPageBloc.eventSink.add(OrderDiscountClicked(discount));
                  else
                    orderPageBloc.eventSink.add(OrderItemDiscountClicked(discount));
                  Navigator.of(context).pop();
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      } else if (s is LoadCustomerPanel) {
        if (orderPageBloc.customerListPageBloc != null) {
          await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              // return object of type Dialog
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: CustomerPanel(
                  bloc: orderPageBloc.customerListPageBloc!,
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onCustomerSelect: (customer) {
                    orderPageBloc.eventSink.add(SelectCustomer(customer));
                    Navigator.of(context).pop();
                  },
                  onCustomerEdit: (contact) {
                    orderPageBloc.eventSink.add(EditCustomer(contact));
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        }
      } else if (s is SurchargePanel) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: SurchargeList(
                surcharges: s.surcharges,
                onSurchargeClick: (Surcharge surcharge) {
                  orderPageBloc.eventSink.add(SurchargeClicked(surcharge));
                  Navigator.of(context).pop();
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      } else if (s is PopUpModifier) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: PopUpModifiers(
                item: s.item,
                onModifierClicked: (modifier, {required isForced}) {
                  if (s.isSubItem) {
                    orderPageBloc.eventSink.add(AddSubItemModifier(modifier, isForced: isForced));
                  } else if (s.isComboItem) {
                    orderPageBloc.eventSink.add(AddComboItemModifier(modifier, isForced: isForced));
                  } else
                    orderPageBloc.eventSink.add(AddTransactionModifier(modifier, isForced: isForced));
                },
                onCancel: (deleteItem) {
                  debugPrint("cancel");
                  if (s.isSubItem) {
                    orderPageBloc.eventSink.add(FinishSubItemPopUpModifier(deleteItem));
                    Navigator.of(context).pop();
                  } else if (s.isComboItem) {
                    orderPageBloc.eventSink.add(FinishComboItemPopUpModifier(deleteItem));
                    Navigator.of(context).pop();
                  } else {
                    orderPageBloc.eventSink.add(CancelPopUpModifier(deleteItem));
                    Navigator.of(context).pop();
                  }
                },
              ),
            );
          },
        );
      } else if (s is PopUpMenuSelection) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: MenuSelectionPanel(
                item: s.item,
                level: s.level,
                selected: s.levelSelectedItem,
                onItemClicked: (item) {
                  Navigator.of(context).pop();
                  orderPageBloc.eventSink.add(AddTransactionSubItem(item));
                },
                onCancel: (deleteItem) {
                  Navigator.of(context).pop();
                  orderPageBloc.eventSink.add(CancelPopUpModifier(deleteItem));
                },
              ),
            );
          },
        );
      } else if (s is SettlePanel) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            // return object of type Dialog
            return PayPanel(
              bloc: orderPageBloc.settlePageBloc!,
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else if (s is ModifierListPanel) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: ModifierList(
                orderPageBloc: orderPageBloc,
                onFinish: () {
                  orderPageBloc.popup.sinkValue(OrderPanel());
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      } else if (s is SearchItemPanel) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: SeachItem(
                orderPageBloc: orderPageBloc,
                onFinish: () {
                  orderPageBloc.popup.sinkValue(OrderPanel());
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 60;
    double footerHeight = 90;
    double bodyHeight = MediaQuery.of(context).size.height - (headerHeight + 40);
    double groupsMenuHeight = 140;
    double itemsMenuHeight = bodyHeight - groupsMenuHeight;

    PageController pageViewController = PageController(initialPage: 0, keepPage: false);

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
            body: PageView(
          controller: pageViewController,
          reverse: true,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  // header
                  // OrderPageHeader(),

                  Container(
                    // color: Color(0xFF231914),
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  pageViewController.animateToPage(1, curve: Curves.bounceInOut, duration: Duration(milliseconds: 350));
                                  // pageViewController.jumpToPage(index);
                                },
                                child: StreamBuilder(
                                  stream: orderPageBloc.orderQty.stream,
                                  initialData: orderPageBloc.orderQty.value,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    return ScaleTransitioWidget(
                                      child: Container(
                                        width: 50,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: Image.asset(
                                              "assets/icons/carticon.png",
                                              width: 50,
                                            ).image,
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment(0.25, -0.3),
                                          child: Text(
                                            orderPageBloc.orderQty.value == null ? "0" : orderPageBloc.orderQty.value.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: PopupMenuButton<MenuType>(
                                  offset: Offset(0, 100),
                                  child: StreamBuilder(
                                    stream: orderPageBloc.selectedMenuType.stream,
                                    initialData: orderPageBloc.selectedMenuType.value,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return AutoSizeText(orderPageBloc.selectedMenuType.value!.name, softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white));
                                    },
                                  ),
                                  onSelected: (MenuType result) {
                                    orderPageBloc.eventSink.add(MenuTypeClicked(result));
                                  },
                                  //initialValue: 4,
                                  //elevation: 2,
                                  itemBuilder: (BuildContext context1) {
                                    List<PopupMenuEntry<MenuType>> list = List<PopupMenuEntry<MenuType>>.empty(growable: true);
                                    for (var item in orderPageBloc.menus!) {
                                      list.add(
                                        PopupMenuItem<MenuType>(
                                          value: item,
                                          child: Text(
                                            item.name,
                                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }
                                    return list;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                      //Qty Button
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            // return object of type Dialog
                                            return Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                              child: Container(
                                                width: 430,
                                                height: 720,
                                                child: Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 6,
                                                          child: Keypad(
                                                            onChange: (s) {
                                                              orderPageBloc.qty.sinkValue(s);
                                                            },
                                                            maxLength: 3,
                                                            isButtonOfHalfInclude: true,
                                                            EnterText: AppLocalizations.of(context)!.translate('Enter Quantity'),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: KeypadButton(
                                                                  text: AppLocalizations.of(context)!.translate('Cancel'),
                                                                  onTap: () {
                                                                    Navigator.of(context).pop();
                                                                    orderPageBloc.qty.sinkValue("");
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(),
                                                              Expanded(
                                                                child: KeypadButton(
                                                                    text: AppLocalizations.of(context)!.translate('Enter'),
                                                                    onTap: () {
                                                                      Navigator.of(context).pop();
                                                                    }),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: StreamBuilder(
                                          stream: orderPageBloc.qty.stream,
                                          initialData: orderPageBloc.qty.value,
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (orderPageBloc.qty.value == null || orderPageBloc.qty.value == "")
                                              return Image.asset("assets/icons/qtyicon.png");
                                            else
                                              return Container(
                                                height: 100,
                                                width: 50,
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                                // decoration: BoxDecoration(
                                                //     image: DecorationImage(
                                                //         image: Image.asset(
                                                //                 "assets/icons/qtyicon.png")
                                                //             .image)),
                                                child: Center(
                                                  child: Text(
                                                    orderPageBloc.qty.value!,
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              );
                                          },
                                        ),
                                      ))),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: PopupMenuButton<Service>(
                                  child: StreamBuilder(
                                    stream: orderPageBloc.selectedService.stream,
                                    initialData: orderPageBloc.selectedService.value,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      String image = "";
                                      switch (orderPageBloc.selectedService.value!.id) {
                                        case 1:
                                          image = "assets/icons/dinein.png";
                                          break;
                                        case 2:
                                          image = "assets/icons/pickup.png";
                                          break;
                                        case 3:
                                          image = "assets/icons/carhop.png";
                                          break;
                                        case 4:
                                          image = "assets/icons/delivery.png";
                                          break;
                                        default:
                                      }

                                      return ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset(image));
                                    },
                                  ),
                                  onSelected: (Service result) {
                                    orderPageBloc.eventSink.add(ServiceChanged(result));
                                  },
                                  elevation: 2,
                                  itemBuilder: (BuildContext context1) {
                                    List<PopupMenuEntry<Service>> list = List<PopupMenuEntry<Service>>.empty(growable: true);
                                    for (var item in orderPageBloc.services!) {
                                      list.add(PopupMenuItem<Service>(
                                          value: item,
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(7.0),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(item.display_name!, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 21)),
                                            ),
                                          )));
                                      list.add(
                                        PopupMenuDivider(
                                          height: 2,
                                        ),
                                      );
                                    }
                                    return list;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: InkWell(
                                  onTap: () {
                                    orderPageBloc.eventSink.add(GoBack());
                                  },
                                  child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset("assets/icons/closeicon.png")),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    height: groupsMenuHeight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 1),
                      child: Container(
                          // groups menu
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 5)),
                          child: ListOfGroups(
                            numberOfRows: 2,
                            bloc: orderPageBloc,
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: EdgeInsets.only(top: 1, left: 5, right: 5, bottom: 1),
                      child: Container(
                          // items menu
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 5)),
                          child: ListOfItems(bloc: orderPageBloc)),
                    ),
                  ),
                  _quickModifiers(footerHeight),
                ],
              ),
            ),

            // Multi Tickets Widget

            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: OrderPageTicket(
                        orderPageBloc: orderPageBloc,
                      )),
                      OrderCartButtons(orderPageBloc),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: orderPageBloc.option.stream,
                  initialData: orderPageBloc.option.value,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    OrderPageOptionState? state = orderPageBloc.option.value;
                    if (state is OrderPageOption) {
                      return Expanded(
                        child: Container(color: Theme.of(context).primaryColor, child: orderOption()),
                      );
                    } else if (state is ItemOption) {
                      return Expanded(
                        child: Container(color: Theme.of(context).primaryColor, child: itemOption()),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget ShowTicketOrMultiTicketsBasedOnServiceType() {
    // if (widget.isServiceDineIn == false) {

    // } else if (widget.isServiceDineIn == true) {
    //   return MultiTickets();
    // }

    return Column(
      children: <Widget>[
        Expanded(
            child: StreamBuilder(
          stream: orderPageBloc.order.stream,
          initialData: orderPageBloc.order.value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return OrderCart(
              order: orderPageBloc.order.value!,
              onItemClicked: (transaction) {
                orderPageBloc.eventSink.add(SelectTransaction(transaction));
              },
              onDelete: (transaction) {
                orderPageBloc.eventSink.add(RemoveTransaction(transaction));
              },
            );
          },
        )),
        OrderCartButtons(orderPageBloc),
      ],
    );
  }

  Widget _quickModifiers(double height) {
    return StreamBuilder(
      stream: orderPageBloc.option.stream,
      initialData: orderPageBloc.option.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (orderPageBloc.option.value is QuickModifierOption) {
          QuickModifierOption temp = orderPageBloc.option.value as QuickModifierOption;
          return Container(
              height: height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: temp.modifiers!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, right: 3, left: 3),
                    child: ModifierButton(
                      modifier: temp.modifiers![index],
                      transaction: temp.transaction,
                      onSelect: () {
                        orderPageBloc.eventSink.add(AddTransactionModifier(temp.modifiers![index]));
                      },
                    ),
                  );
                },
              ));
        }
        return Container();
      },
    );
  }

  Widget orderOption() {
    return ListView(
      children: <Widget>[
        // Expanded(
        //   child: Padding(
        //     padding: EdgeInsets.all(5),
        //     child: SecondaryButton(
        //       text: AppLocalizations.of(context)!.translate("Split Ticket"),
        //       isBorderRounded: true,
        //     ),
        //   ),
        // ),
        // Expanded(
        //   child: Padding(
        //     padding: EdgeInsets.all(5),
        //     child: SecondaryButton(
        //       text: AppLocalizations.of(context)!.translate("Merge Order"),
        //       isBorderRounded: true,
        //     ),
        //   ),
        // ),
        // Expanded(
        //   child: Padding(
        //     padding: EdgeInsets.all(5),
        //     child: SecondaryButton(
        //       text: AppLocalizations.of(context)!.translate("Ready At"),
        //       isBorderRounded: true,
        //     ),
        //   ),
        // ),
        // Expanded(
        //   child: Padding(
        //     padding: EdgeInsets.all(5),
        //     child: SecondaryButton(
        //       text:
        //           AppLocalizations.of(context)!.translate("Add Change Customer"),
        //       isBorderRounded: true,
        //     ),
        //   ),
        // ),
        Container(
          height: 100,
          width: 100,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SecondaryButton(
              onTap: () {
                orderPageBloc.eventSink.add(AddTag());
              },
              text: AppLocalizations.of(context)!.translate("Add Tag"),
              isBorderRounded: true,
            ),
          ),
        ),
        Container(
          height: 100,
          width: 100,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SecondaryButton(
              onTap: () {
                orderPageBloc.eventSink.add(SurchargeOrder());
              },
              text: AppLocalizations.of(context)!.translate("Add Subcharge"),
              isBorderRounded: true,
            ),
          ),
        ),
        Container(
          height: 100,
          width: 100,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SecondaryButton(
              onTap: () {
                orderPageBloc.eventSink.add(VoidOrder());
              },
              text: AppLocalizations.of(context)!.translate("Void Ticket"),
              isBorderRounded: true,
            ),
          ),
        ),
        Container(
          height: 100,
          width: 100,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SecondaryButton(
              onTap: () {
                orderPageBloc.eventSink.add(DiscountOrder());
              },
              text: AppLocalizations.of(context)!.translate("Discount Order"),
              isBorderRounded: true,
            ),
          ),
        ),

        Container(
          height: 100,
          width: 100,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SecondaryButton(
              onTap: () {
                orderPageBloc.eventSink.add(AdjGuestNumber());
              },
              text: "Adj Guest Number",
              isBorderRounded: true,
            ),
          ),
        ),
        Container(
          height: 100,
          width: 100,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SecondaryButton(
              onTap: () {
                orderPageBloc.eventSink.add(AddCustomer());
              },
              text: AppLocalizations.of(context)!.translate("Add/Change Customer"),
              isBorderRounded: true,
            ),
          ),
        ),
        Container(
          height: 100,
          width: 100,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: SecondaryButton(
              onTap: () {
                orderPageBloc.eventSink.add(SearchItem());
              },
              text: AppLocalizations.of(context)!.translate("Search Item"),
              isBorderRounded: true,
            ),
          ),
        ),
        // Expanded(
        //   child: Padding(
        //     padding: EdgeInsets.all(5),
        //     child: SecondaryButton(
        //       text: AppLocalizations.of(context)!.translate("Auto Hold"),
        //       isBorderRounded: true,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget itemOption() {
    OrderTransaction? transaction = orderPageBloc.order.value!.itemSelected.value;
    if (transaction == null) return Center();
    return ListView(
      children: <Widget>[
        transaction.isNew
            ? Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SecondaryButton(
                    onTap: () {
                      orderPageBloc.eventSink.add(IncreaseTransactionQty());
                    },
                    text: AppLocalizations.of(context)!.translate("Increase Qty"),
                    isBorderRounded: true,
                  ),
                ))
            : SizedBox(),
        transaction.isNew
            ? Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SecondaryButton(
                    onTap: () {
                      orderPageBloc.eventSink.add(DecreaseTransactionQty());
                    },
                    text: AppLocalizations.of(context)!.translate("Decrease Qty"),
                    isBorderRounded: true,
                  ),
                ))
            : SizedBox(),
        Container(
            height: 100,
            width: 100,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: SecondaryButton(
                onTap: () {
                  orderPageBloc.eventSink.add(AdjTransactionPrice());
                },
                text: AppLocalizations.of(context)!.translate("Adj Price"),
                isBorderRounded: true,
              ),
            )),
        transaction.isNew
            ? Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SecondaryButton(
                    onTap: () {
                      orderPageBloc.eventSink.add(AdjTransactionQty());
                    },
                    text: AppLocalizations.of(context)!.translate("Adj Qty"),
                    isBorderRounded: true,
                  ),
                ))
            : SizedBox(),
        Container(
            height: 100,
            width: 100,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: SecondaryButton(
                onTap: () {
                  orderPageBloc.eventSink.add(OrderDiscountItem());
                },
                text: AppLocalizations.of(context)!.translate("Discount Item"),
                isBorderRounded: true,
              ),
            )),
        Container(
            height: 100,
            width: 100,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: SecondaryButton(
                onTap: () {
                  orderPageBloc.eventSink.add(ReOrderTransaction());
                },
                text: AppLocalizations.of(context)!.translate("Re Order"),
                isBorderRounded: true,
              ),
            )),
        (transaction.isNew && transaction.hold_time == null)
            ? Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SecondaryButton(
                    onTap: () {
                      orderPageBloc.eventSink.add(HoldUntilFire());
                    },
                    text: AppLocalizations.of(context)!.translate("Hold Until Fire"),
                    isBorderRounded: true,
                  ),
                ))
            : Center(),
        (transaction.hold_time != null)
            ? Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SecondaryButton(
                    onTap: () {
                      orderPageBloc.eventSink.add(HoldUntilFire());
                    },
                    text: AppLocalizations.of(context)!.translate("Fire"),
                    isBorderRounded: true,
                  ),
                ))
            : Center(),
        transaction.isNew
            ? Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SecondaryButton(
                    onTap: () {
                      orderPageBloc.popup.sinkValue(ModifierListPanel());
                    },
                    text: AppLocalizations.of(context)!.translate("Extra Modifiers"),
                    isBorderRounded: true,
                  ),
                ),
              )
            : SizedBox(),
        transaction.isNew
            ? Container(
                height: 100,
                width: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SecondaryButton(
                    onTap: () {
                      orderPageBloc.eventSink.add(ShowShortNote());
                    },
                    text: AppLocalizations.of(context)!.translate("Short Note"),
                    isBorderRounded: true,
                  ),
                ))
            : SizedBox(),
      ],
    );
  }
}

class ScaleTransitioWidget extends StatefulWidget {
  final Widget child;
  ScaleTransitioWidget({required this.child});
  _ScaleTransitioWidgetState createState() => _ScaleTransitioWidgetState();
}

class _ScaleTransitioWidgetState extends State<ScaleTransitioWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), value: 0.1, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _controller.forward();
  }

  @override
  void didUpdateWidget(ScaleTransitioWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _controller.reset();
    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, alignment: Alignment.center, child: widget.child);
  }
}
