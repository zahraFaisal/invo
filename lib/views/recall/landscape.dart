import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_event.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_state.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/custom/search.dart';
import 'package:invo_mobile/views/recall/widgets/order_summary.dart';
import 'package:invo_mobile/views/pending/widgets/pending_orders.dart';

import 'package:invo_mobile/views/recall/widgets/orders_tabs.dart';
import 'package:invo_mobile/views/recall/widgets/vertical_ticket_options.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/date_field.dart';
import 'package:invo_mobile/widgets/discount/discount_list.dart';

import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/layout/header_landscape.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';
import 'package:invo_mobile/widgets/pay_panel/pay_panel.dart';
import 'package:invo_mobile/widgets/surcharge/surcharge_list.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../blocProvider.dart';

class RecallPageLandscape extends StatefulWidget {
  const RecallPageLandscape({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecallPageLandscapeState();
  }
}

class _RecallPageLandscapeState extends State<RecallPageLandscape> {
  late RecallPageBloc recallPageBloc;

  // DateTime startDate, DateTime endDate, String searchText, int service, int status
  SearchModel search = new SearchModel();
  Property<bool> isTelephoneHit = new Property<bool>(); // determine if telephone number is set or empty
  late String number;
  List<DropdownMenuItem<int>> status = new List<DropdownMenuItem<int>>.empty(growable: true);
  List<DropdownMenuItem<int>> services = new List<DropdownMenuItem<int>>.empty(growable: true);
  var _statusValue = 0;
  var _serviceValue = 0;
  @override
  void initState() {
    super.initState();
    recallPageBloc = BlocProvider.of<RecallPageBloc>(context);
    status.addAll([
      DropdownMenuItem(
        value: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                "All",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Center(child: Icon(Icons.arrow_drop_down))
          ],
        ),
      ),
      DropdownMenuItem(
        value: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                "Open",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Center(child: Icon(Icons.arrow_drop_down))
          ],
        ),
      ),
      DropdownMenuItem(
        value: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                "Voided",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Center(child: Icon(Icons.arrow_drop_down))
          ],
        ),
      ),
      DropdownMenuItem(
        value: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                "ReOpened",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Center(child: Icon(Icons.arrow_drop_down))
          ],
        ),
      ),
      DropdownMenuItem(
        value: 7,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                "Merged",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Center(child: Icon(Icons.arrow_drop_down))
          ],
        ),
      ),
    ]);

    if (recallPageBloc.setteldOrders == true) {
      status.add(DropdownMenuItem(
        value: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                "Paid",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Center(child: Icon(Icons.arrow_drop_down))
          ],
        ),
      ));
    }

    services.add(DropdownMenuItem(
      value: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Text(
              "All",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Center(child: Icon(Icons.arrow_drop_down))
        ],
      ),
    ));

    for (var i = 0; i < recallPageBloc.services.length; i++) {
      services.add(DropdownMenuItem(
        value: i + 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                recallPageBloc.services[i].display_name!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Center(child: Icon(Icons.arrow_drop_down))
          ],
        ),
      ));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isTelephoneHit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        // Set background image of home page
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Wallpaper.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HeaderLandscape(),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    // keypad and options based on service selected
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 3, color: Theme.of(context).primaryColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: StreamBuilder(
                              stream: recallPageBloc.orderState.stream,
                              initialData: OrderIsHidden(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.data is OrderIsHidden) {
                                  if (recallPageBloc.isKeyPadVisible) {
                                    //show keypad
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Expanded(
                                          child: Keypad(
                                            isTelephoneStyle: true,
                                            onChange: (s) {
                                              number = s;
                                              if (number == "" && isTelephoneHit.value != false) {
                                                isTelephoneHit.sinkValue(false);
                                              } else if (isTelephoneHit.value != true) {
                                                isTelephoneHit.sinkValue(true);
                                              }
                                            },
                                            EnterText: AppLocalizations.of(context)!.translate('Enter Telephone'),
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream: isTelephoneHit.stream,
                                          initialData: false,
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            return Container(
                                              padding: EdgeInsets.all(1),
                                              height: 50,
                                              child: PrimaryButton(
                                                text: AppLocalizations.of(context)!.translate('Enter'),
                                                onTap: () {
                                                  recallPageBloc.eventSink.add(LoadCustomer(number));
                                                },
                                                fontSize: 35,
                                                isEnabled: (isTelephoneHit.value != null) ? isTelephoneHit.value! : false,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  } else if (recallPageBloc.isSearchVisible) {
                                    //add search inputs
                                    return ListView(children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!.translate("Search"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              initialValue: search.searchText,
                                              onChanged: (value) {
                                                setState(() {
                                                  search.searchText = value;
                                                });
                                              },
                                              onSaved: (value) {
                                                search.searchText = value!;
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {}
                                                return null;
                                              },
                                              decoration: InputDecoration(labelText: 'Search', border: OutlineInputBorder()),
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("From"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DatePicker(
                                              selectedDate: DateTime.now(),
                                              selectDate: (newValue) {
                                                setState(() {
                                                  search.start_date = newValue;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("To"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DatePicker(
                                              selectedDate: DateTime.now(),
                                              selectDate: (newValue) {
                                                setState(() {
                                                  search.end_date = newValue;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("Status"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            width: MediaQuery.of(context).size.width,
                                            child: Center(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                elevation: 16,
                                                icon: SizedBox(),
                                                value: search.status,
                                                items: status,
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    search.status = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("Services"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            width: MediaQuery.of(context).size.width,
                                            child: Center(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                elevation: 16,
                                                icon: SizedBox(),
                                                value: search.service,
                                                items: services,
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    search.service = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]);
                                  }
                                } else if (snapshot.data is OrderIsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.data is OrderIsLoaded) {
                                  OrderIsLoaded state = snapshot.data;
                                  return OrderCart(order: state.order!);
                                }

                                return Center();
                              },
                            ),
                          ),
                          StreamBuilder(
                            stream: recallPageBloc.orderState.stream,
                            initialData: OrderIsHidden(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data is OrderIsHidden) {
                                if (recallPageBloc.selectedService.value!.id == 2) {
                                  return Container(
                                      height: 50,
                                      child: StreamBuilder(
                                        stream: isTelephoneHit.stream,
                                        initialData: false,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          return Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: PrimaryButton(
                                              onTap: () {
                                                recallPageBloc.eventSink.add(TakeOrderFirst());
                                              },
                                              text: AppLocalizations.of(context)!.translate('Walk In Customer'),
                                              fontSize: 35,
                                              isEnabled: (isTelephoneHit.value != null) ? !isTelephoneHit.value! : true,
                                            ),
                                          );
                                        },
                                      ));
                                } else if (recallPageBloc.selectedService.value!.id == 4) {
                                  return Container(
                                      height: 50,
                                      child: StreamBuilder(
                                        stream: isTelephoneHit.stream,
                                        initialData: false,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          return Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: PrimaryButton(
                                              onTap: () {
                                                recallPageBloc.eventSink.add(TakeOrderFirst());
                                              },
                                              text: AppLocalizations.of(context)!.translate('Take Order First'),
                                              fontSize: 35,
                                              isEnabled: (isTelephoneHit.value != null) ? !isTelephoneHit.value! : true,
                                            ),
                                          );
                                        },
                                      ));
                                  // return Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: <Widget>[
                                  //     Expanded(
                                  //       child: Container(
                                  //         height: 50,
                                  //         child: KeypadButton(
                                  //             text: AppLocalizations.of(
                                  //                     context)
                                  //                 !.translate(
                                  //                     'Search Customer'),
                                  //             onTap: () {}),
                                  //       ),
                                  //     ),
                                  //     Expanded(
                                  //       child: Container(
                                  //         height: 50,
                                  //         child: KeypadButton(
                                  //             text: AppLocalizations.of(
                                  //                     context)
                                  //                 !.translate(
                                  //                     'Take Order First'),
                                  //             onTap: () {
                                  //               recallPageBloc.eventSink
                                  //                   .add(TakeOrderFirst());
                                  //             }),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // );
                                } else if (recallPageBloc.selectedService.value!.id == 0) {
                                  return Container(
                                    height: 50,
                                    child: StreamBuilder(
                                      stream: recallPageBloc.openOrder.stream,
                                      initialData: false,
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        return Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: PrimaryButton(
                                            onTap: () {
                                              recallPageBloc.eventSink.add(SearchOrder(search));
                                            },
                                            text: AppLocalizations.of(context)!.translate('Search'),
                                            fontSize: 35,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              }

                              return Center();
                            },
                          ),
                          StreamBuilder(
                            stream: recallPageBloc.popup.stream,
                            initialData: recallPageBloc.popup.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (recallPageBloc.popup.value != null && recallPageBloc.popup.value is! PopUpPanel) {
                                return SizedBox();
                              }

                              //service id = 0 //ALL
                              if (recallPageBloc.selectedService.value!.id == 0) {
                                return SizedBox(
                                  height: 50,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        child: KeypadButton(
                                            text: AppLocalizations.of(context)!.translate('Back'),
                                            onTap: () {
                                              recallPageBloc.eventSink.add(GoBack());
                                            }),
                                      ),
                                      Expanded(
                                        child: KeypadButton(
                                          onTap: () {
                                            recallPageBloc.orderState.sinkValue(OrderIsHidden());
                                          },
                                          text: AppLocalizations.of(context)!.translate('New Search'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  height: 50,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        child: KeypadButton(
                                            text: AppLocalizations.of(context)!.translate('Back'),
                                            onTap: () {
                                              recallPageBloc.eventSink.add(GoBack());
                                            }),
                                      ),
                                      Expanded(
                                        child: StreamBuilder(
                                          stream: recallPageBloc.orderState.stream,
                                          initialData: recallPageBloc.orderState.value,
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            OrderViewState? temp = snapshot.data;
                                            if (temp is OrderIsHidden && temp.isKeyPadVisible) {
                                              return PrimaryButton(
                                                text: AppLocalizations.of(context)!.translate('New Order'),
                                                fontSize: 35,
                                                isEnabled: false,
                                              );
                                            } else {
                                              return KeypadButton(
                                                  text: AppLocalizations.of(context)!.translate('New Order'),
                                                  onTap: () {
                                                    recallPageBloc.eventSink.add(ClickNewOrder());
                                                  });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          StreamBuilder<OrderViewState>(
                            stream: recallPageBloc.orderState.stream,
                            initialData: OrderIsHidden(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data is OrderIsLoaded) {
                                return Expanded(
                                  flex: 1,
                                  child: VerticalTicketOptions(bloc: recallPageBloc),
                                );
                              } else if (snapshot.data is OrderIsLoading) {
                                return Expanded(
                                  flex: 1,
                                  child: Container(height: double.maxFinite, color: Colors.white, child: Center(child: CircularProgressIndicator())),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                          //stream builder selectedService id // 0  // else

                          StreamBuilder(
                            stream: recallPageBloc.openOrder.stream,
                            initialData: recallPageBloc.openOrder.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (recallPageBloc.selectedService.value!.id == 0) {
                                //return Center();
                                return Expanded(
                                  // tabs of open , paid and delivered orders
                                  flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(border: Border.all(width: 3, color: Theme.of(context).primaryColor)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 50,
                                          color: Theme.of(context).primaryColor,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(AppLocalizations.of(context)!.translate("All"),
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange)),
                                        ),
                                        Expanded(
                                          child: Container(
                                              color: Colors.white,
                                              child: GridView.builder(
                                                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: noOfColumns(recallPageBloc.allOrders!), childAspectRatio: 0.90),
                                                itemBuilder: (context, index) {
                                                  return OrderSummary(
                                                    recallPageBloc: recallPageBloc,
                                                    order: recallPageBloc.allOrders![index],
                                                  );
                                                },
                                                itemCount: recallPageBloc.allOrders!.length,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else if (recallPageBloc.selectedService.value!.id > 0) {
                                return Expanded(
                                  // tabs of open , paid and delivered orders
                                  flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(border: Border.all(width: 3, color: Theme.of(context).primaryColor)),
                                    child: StreamBuilder(
                                      stream: recallPageBloc.selectedService.stream,
                                      initialData: recallPageBloc.selectedService.value,
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        return OrderTabs(
                                          recallPageBloc: recallPageBloc,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }

                              return Container();
                            },
                          ),
                        ],
                      ),
                      StreamBuilder(
                        stream: recallPageBloc.popup.stream,
                        initialData: recallPageBloc.popup.value,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          var s = recallPageBloc.popup.value;

                          if (s is RecallDiscountPanel) {
                            return DiscountList(
                              discounts: s.discounts,
                              onCancel: () {
                                recallPageBloc.popup.sinkValue(PopUpPanel());
                              },
                              onDiscountClick: (discount) {
                                recallPageBloc.eventSink.add(DiscountClicked(discount));
                                recallPageBloc.popup.sinkValue(PopUpPanel());
                              },
                            );
                          } else if (s is RecallSurchargePanel) {
                            return SurchargeList(
                              surcharges: s.surcharges,
                              onCancel: () {
                                recallPageBloc.popup.sinkValue(PopUpPanel());
                              },
                              onSurchargeClick: (surcharge) {
                                recallPageBloc.popup.sinkValue(PopUpPanel());
                                recallPageBloc.eventSink.add(SurchargeClicked(surcharge));
                              },
                            );
                          } else if (recallPageBloc.popup.value is RecallPayPanel) {
                            return PayPanel(
                              bloc: recallPageBloc.settlePageBloc!,
                              onCancel: () {
                                recallPageBloc.popup.sinkValue(PopUpPanel());
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            )),
            // FooterLandscape()
          ],
        ),
      ),
    );
  }

  int noOfColumns(List<MiniOrder> orders) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool mobileLayout = shortestSide < 500;

    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? (mobileLayout)
            ? 2
            : 3
        : ((orders.where((f) => f.isSelected).length > 0) ? 3 : 4);
  }
}
