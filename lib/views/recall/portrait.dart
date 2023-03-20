import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_event.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_state.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/custom/search.dart';

import 'package:invo_mobile/views/order/index.dart';
import 'package:invo_mobile/views/recall/widgets/order_summary.dart';
import 'package:invo_mobile/views/recall/widgets/orders_tabs.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/date_field.dart';
import 'package:invo_mobile/widgets/discount/discount_list.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/layout/header_portrait.dart';
import 'package:invo_mobile/widgets/pay_panel/pay_panel.dart';
import 'package:invo_mobile/widgets/surcharge/surcharge_list.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../blocProvider.dart';

class RecallPageProtrait extends StatefulWidget {
  final String service;

  const RecallPageProtrait({Key? key, this.service = ""}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RecallPageProtraitState();
  }
}

class _RecallPageProtraitState extends State<RecallPageProtrait> {
  late RecallPageBloc recallPageBloc;

  List<DropdownMenuItem<int>> status = List<DropdownMenuItem<int>>.empty(growable: true);
  List<DropdownMenuItem<int>> services = List<DropdownMenuItem<int>>.empty(growable: true);

  SearchModel search = new SearchModel();
  @override
  void initState() {
    super.initState();
    recallPageBloc = BlocProvider.of<RecallPageBloc>(context);
    recallPageBloc.selectedService.stream.listen((data) {
      setState(() {});
    });

    recallPageBloc.popup.stream.listen((s) async {
      if (s is RecallDiscountPanel) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: DiscountList(
                discounts: s.discounts,
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onDiscountClick: (discount) {
                  recallPageBloc.eventSink.add(DiscountClicked(discount));
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      } else if (s is RecallSurchargePanel) {
        await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            // return object of type Dialog
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: SurchargeList(
                surcharges: s.surcharges,
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onSurchargeClick: (surcharge) {
                  Navigator.of(context).pop();
                  recallPageBloc.eventSink.add(SurchargeClicked(surcharge));
                },
              ),
            );
          },
        );
      } else if (s is RecallPayPanel) {
        return await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            // return object of type Dialog
            return PayPanel(
              bloc: recallPageBloc.settlePageBloc!,
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    });
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: DefaultTabController(
          length: 3,
          child: Container(
            // Set background image of home page
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Wallpaper.jpg"),
                fit: BoxFit.fill,
              ),
            ),

            child: Column(
              children: <Widget>[
                // header of page

                Header(),
                recallPageBloc.selectedService.value!.id == 0
                    ? StreamBuilder(
                        stream: recallPageBloc.openOrder.stream,
                        initialData: recallPageBloc.openOrder.value,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return Expanded(
                            // tabs of open , paid and delivered orders

                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 50,
                                    color: Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("All",
                                        textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange)),
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
                        })
                    : Expanded(
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

                Container(
                  color: Colors.white,
                ),

                Container(
                  height: 60,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: PrimaryButton(
                            text: AppLocalizations.of(context)!.translate('Back'),
                            onTap: () {
                              recallPageBloc.eventSink.add(GoBack());
                            },
                          ),
                        ),
                      ),
                      recallPageBloc.selectedService.value!.id == 0
                          ? Expanded(
                              child: Padding(
                              padding: EdgeInsets.all(5),
                              child: PrimaryButton(
                                text: AppLocalizations.of(context)!.translate('Search'),
                                onTap: () {
                                  searchPopUp();
                                },
                              ),
                            ))
                          : Expanded(
                              child: Padding(
                              padding: EdgeInsets.all(5),
                              child: PrimaryButton(
                                text: AppLocalizations.of(context)!.translate('New'),
                                onTap: () {
                                  recallPageBloc.eventSink.add(ClickNewOrder(orientation: Orientation.portrait));
                                },
                              ),
                            )),
                      // Expanded(
                      //     child: Padding(
                      //   padding: EdgeInsets.all(5),
                      //   child: PrimaryButton(
                      //       text: AppLocalizations.of(context)
                      //           !.translate('Assign Driver')),
                      // )),
                      // Expanded(
                      //     child: Padding(
                      //   padding: EdgeInsets.all(5),
                      //   child: PrimaryButton(
                      //       text: AppLocalizations.of(context)
                      //           !.translate('Driver Arrival')),
                      // ))
                    ],
                  ),
                ),
              ],
            ),
          )),
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

  //Navigator.pop(context);
  searchPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, snapshot) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: <Widget>[
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
                              snapshot(() {
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
                              snapshot(() {
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
                              snapshot(() {
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
                              icon: SizedBox(),
                              elevation: 16,
                              isExpanded: true,
                              value: search.status,
                              items: status,
                              onChanged: (value) {
                                snapshot(() {
                                  search.status = value as int;
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
                              icon: SizedBox(),
                              elevation: 16,
                              value: search.service,
                              items: services,
                              onChanged: (value) {
                                snapshot(() {
                                  search.service = value as int;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            child: KeypadButton(
                                text: AppLocalizations.of(context)!.translate('Back'),
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                }),
                          ),
                        ),
                        Expanded(
                          child: Container(
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
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    text: AppLocalizations.of(context)!.translate('Search'),
                                    fontSize: 35,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
