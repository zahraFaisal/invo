import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_state.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/views/order/widgets/list_of_groups.dart';
import 'package:invo_mobile/views/order/widgets/list_of_items.dart';
import 'package:invo_mobile/views/order/widgets/menu_selection.dart';
import 'package:invo_mobile/views/order/widgets/modifier_list.dart';
import 'package:invo_mobile/views/order/widgets/order_cart_options_and_qty_form_in_landscape_7_inch_or_less.dart';
import 'package:invo_mobile/views/order/widgets/order_cart_options_and_qty_form_in_landscape_9_inch_or_more.dart';
import 'package:invo_mobile/views/order/widgets/popup_modifiers.dart';
import 'package:invo_mobile/views/order/widgets/search_item.dart';
import 'package:invo_mobile/views/order/widgets/ticket.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/customer/customer_panel.dart';
import 'package:invo_mobile/widgets/discount/discount_list.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:invo_mobile/widgets/layout/header_landscape.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart_buttons.dart';
import 'package:invo_mobile/widgets/pay_panel/pay_panel.dart';
import 'package:invo_mobile/widgets/surcharge/surcharge_list.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class OrderPageLandscape extends StatefulWidget {
  final bool isServiceDineIn;

  const OrderPageLandscape({Key? key, this.isServiceDineIn = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderPageLandscapeState();
  }
}

class _OrderPageLandscapeState extends State<OrderPageLandscape> {
  late OrderPageBloc orderPageBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderPageBloc = BlocProvider.of<OrderPageBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          HeaderLandscape(
            height: 45,
          ),
          Expanded(
            flex: 9,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 5)),
                            child: Column(
                              children: <Widget>[
                                getPopupMenusOfTypeOfMealAndService(context),
                                Expanded(
                                  child: OrderPageTicket(
                                    orderPageBloc: orderPageBloc,
                                  ),
                                ),
                                StreamBuilder(
                                    stream: orderPageBloc.popup.stream,
                                    initialData: orderPageBloc.popup.value,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (orderPageBloc.popup.value is OrderPanel) {
                                        return OrderCartButtons(orderPageBloc);
                                      } else {
                                        return SizedBox();
                                      }
                                    }),
                              ],
                            )))),
                _getPopUpWindow(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getPopUpWindow() {
    return StreamBuilder(
      stream: orderPageBloc.popup.stream,
      initialData: orderPageBloc.popup.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        PopupPanelState temp = orderPageBloc.popup.value!;
        if (temp is PopUpModifier) {
          return Expanded(
              flex: 7,
              // ignore: unnecessary_new
              child: new PopUpModifiers(
                item: temp.item,
                onModifierClicked: (MenuModifier modifier, {bool? isForced}) {
                  debugPrint("modifier click");
                  if (temp.isSubItem) {
                    debugPrint("sub item");
                    orderPageBloc.eventSink.add(AddSubItemModifier(modifier, isForced: isForced!));
                  } else if (temp.isComboItem) {
                    debugPrint("combo item");
                    orderPageBloc.eventSink.add(AddComboItemModifier(modifier, isForced: isForced!));
                  } else {
                    debugPrint("else");
                    orderPageBloc.eventSink.add(AddTransactionModifier(modifier, isForced: isForced!));
                  }
                },
                onCancel: (deleteItem) {
                  if (temp.isSubItem) {
                    orderPageBloc.eventSink.add(FinishSubItemPopUpModifier(deleteItem));
                  } else if (temp.isComboItem) {
                    orderPageBloc.eventSink.add(FinishComboItemPopUpModifier(deleteItem));
                  } else {
                    orderPageBloc.eventSink.add(CancelPopUpModifier(deleteItem));
                  }
                },
              ));
        } else if (temp is PopUpMenuSelection) {
          return Expanded(
              flex: 7,
              child: MenuSelectionPanel(
                item: temp.item,
                level: temp.level,
                selected: temp.levelSelectedItem,
                onItemClicked: (mi.MenuItem item) {
                  orderPageBloc.eventSink.add(AddTransactionSubItem(item));
                },
                onCancel: (deleteItem) {
                  orderPageBloc.eventSink.add(CancelPopUpModifier(deleteItem));
                },
              ));
        } else if (temp is ModifierListPanel) {
          return Expanded(
            flex: 7,
            child: ModifierList(
              orderPageBloc: orderPageBloc,
              onFinish: () {
                orderPageBloc.popup.sinkValue(OrderPanel());
              },
            ),
          );
        } else if (temp is SearchItemPanel) {
          return Expanded(
            flex: 7,
            child: SeachItem(
              orderPageBloc: orderPageBloc,
              onFinish: () {
                orderPageBloc.popup.sinkValue(OrderPanel());
              },
            ),
          );
        } else if (temp is LoadCustomerPanel) {
          return CustomerPanel(
            bloc: orderPageBloc.customerListPageBloc!,
            onCancel: () {
              orderPageBloc.popup.sinkValue(OrderPanel());
            },
            onCustomerSelect: (customer) {
              orderPageBloc.eventSink.add(SelectCustomer(customer));
            },
            onCustomerEdit: (contact) {
              orderPageBloc.eventSink.add(EditCustomer(contact));
            },
          );
        } else if (temp is DiscountPanel) {
          return Expanded(
            flex: 7,
            child: DiscountList(
              discounts: temp.discounts,
              onDiscountClick: (Discount discount) {
                if (temp.orderDiscount)
                  orderPageBloc.eventSink.add(OrderDiscountClicked(discount));
                else
                  orderPageBloc.eventSink.add(OrderItemDiscountClicked(discount));
              },
              onCancel: () {
                orderPageBloc.popup.sinkValue(OrderPanel());
              },
            ),
          );
        } else if (temp is SurchargePanel) {
          return Expanded(
            flex: 7,
            child: SurchargeList(
              surcharges: temp.surcharges,
              onSurchargeClick: (Surcharge surcharge) {
                orderPageBloc.eventSink.add(SurchargeClicked(surcharge));
              },
              onCancel: () {
                orderPageBloc.popup.sinkValue(OrderPanel());
              },
            ),
          );
        } else if (temp is SettlePanel) {
          return Expanded(
            flex: 7,
            child: PayPanel(
              bloc: orderPageBloc.settlePageBloc!,
              onCancel: () {
                orderPageBloc.popup.sinkValue(OrderPanel());
              },
            ),
          );
        } else {
          return _orderPanel();
        }
      },
    );
  }

  Widget _orderPanel() {
    return Expanded(
      flex: 7,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: getDeviceTypeInLandscape(context) == "7 Inch or less" ? 1 : 2,
            child: Container(
              height: 70,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Container(
                    // groups menu
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 5)),
                    child: ListOfGroups(
                      bloc: orderPageBloc,
                      numberOfRows: getDeviceTypeInLandscape(context) == "7 Inch or less" ? 1 : 2,
                    )),
              ),
            ),
          ),
          Expanded(
              flex: getDeviceTypeInLandscape(context) == "7 Inch or less" ? 7 : 9,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 5)),
                  // right side of list of items

                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 5, color: Theme.of(context).primaryColor),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: getDeviceTypeInLandscape(context) == "7 Inch or less"
                                ? //Text("7")
                                OrderCartOptionsInLandscape7Inch(
                                    orderPageBloc: orderPageBloc,
                                  )
                                : //Text("9")
                                OrderCartOptionsInLandscape9Inch(orderPageBloc),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: getDeviceTypeInLandscape(context) == "7 Inch or less" ? 6 : 3,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ListOfItems(
                              bloc: orderPageBloc,
                            ),
                          ))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  // this function use to specific type of device 7 inch or less / 8.9 or more

  String getDeviceTypeInLandscape(BuildContext context) {
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    var width = MediaQuery.of(context).size.width * devicePixelRatio;
    var height = MediaQuery.of(context).size.height * devicePixelRatio;
    var deviceType;

    if (width <= 1280 && height <= 800) {
      deviceType = "7 Inch or less";
    } else if (width >= 2048 && height <= 1536 && height > 1400) {
      deviceType = "8.9 Inch or more";
    } else {
      deviceType = "unknow type";
    }

    return "$deviceType";
  }

  // this widget of type of meal and type of service popup drop down menu

  Widget getPopupMenusOfTypeOfMealAndService(BuildContext context) {
    return StreamBuilder(
        stream: orderPageBloc.popup.stream,
        initialData: orderPageBloc.popup.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (orderPageBloc.popup.value is OrderPanel) {
            return SizedBox(
                height: 45,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: PopupMenuButton<MenuType>(
                          offset: Offset(0, 100),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7.0),
                                ),
                              ),
                              // color: Theme.of(context).primaryColor,
                              child: StreamBuilder(
                                  stream: orderPageBloc.selectedMenuType.stream,
                                  builder: (context, snapshot) {
                                    return Center(
                                      child: Text(orderPageBloc.selectedMenuType.value!.name, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 21)),
                                    );
                                  }),
                            ),
                          ),
                          onSelected: (MenuType result) {
                            orderPageBloc.eventSink.add(MenuTypeClicked(result));
                          },
                          //initialValue: 4,
                          //elevation: 2,
                          itemBuilder: (BuildContext context1) {
                            List<PopupMenuEntry<MenuType>> list = List<PopupMenuEntry<MenuType>>.empty(growable: true);
                            for (var item in orderPageBloc.menus!) {
                              list.add(PopupMenuItem<MenuType>(
                                  value: item,
                                  child: Container(
                                    height: 50,
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(item.name, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 21)),
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: PopupMenuButton<Service>(
                          offset: Offset(0, 100),
                          child: StreamBuilder(
                            stream: orderPageBloc.selectedService.stream,
                            initialData: orderPageBloc.selectedService.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7.0),
                                  ),
                                ),
                                // color: Theme.of(context).primaryColor,
                                child: Center(
                                  child: Text(orderPageBloc.selectedService.value!.name, softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: 21)),
                                ),
                              );
                            },
                          ),
                          onSelected: (Service result) {
                            orderPageBloc.eventSink.add(ServiceChanged(result));
                          },
                          //initialValue: 4,
                          //elevation: 2,
                          itemBuilder: (BuildContext context1) {
                            List<PopupMenuEntry<Service>> list = List<PopupMenuEntry<Service>>.empty(growable: true);
                            for (var item in orderPageBloc.services!) {
                              list.add(
                                PopupMenuItem<Service>(
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
                                  ),
                                ),
                              );
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
                    )
                  ],
                ));
          } else {
            return SizedBox();
          }
        });
  }
}
