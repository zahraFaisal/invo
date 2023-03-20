import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_state.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/custom/search.dart';
import 'package:invo_mobile/views/pending/widgets/vertical_ticket_options.dart';
import 'package:invo_mobile/views/pending/widgets/pending_orders.dart';
import 'package:invo_mobile/widgets/date_field.dart';

import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/layout/header_landscape.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../blocProvider.dart';

class PendingPageLandscape extends StatefulWidget {
  const PendingPageLandscape({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PendingPageLandscapeState();
  }
}

class _PendingPageLandscapeState extends State<PendingPageLandscape> {
  late PendingPageBloc pendingPageBloc;

  // DateTime startDate, DateTime endDate, String searchText, int service, int status
  SearchModel search = new SearchModel();
  Property<bool> isTelephoneHit = new Property<bool>(); // determine if telephone number is set or empty
  late String number;
  List<DropdownMenuItem<int>> status = List<DropdownMenuItem<int>>.empty(growable: true);
  List<DropdownMenuItem<int>> services = List<DropdownMenuItem<int>>.empty(growable: true);
  var _statusValue = 0;
  var _serviceValue = 0;
  @override
  void initState() {
    super.initState();
    pendingPageBloc = BlocProvider.of<PendingPageBloc>(context);
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
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: StreamBuilder(
                              stream: pendingPageBloc.orderState.stream,
                              initialData: OrderIsHidden(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.data is OrderIsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.data is OrderIsLoaded) {
                                  OrderIsLoaded state = snapshot.data;
                                  return Container(child: OrderCart(order: state.order!));
                                }
                                return Center();
                              },
                            ),
                          ),
                          StreamBuilder(
                            stream: pendingPageBloc.popup.stream,
                            initialData: pendingPageBloc.popup.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (pendingPageBloc.popup.value != null && pendingPageBloc.popup.value is! PopUpPanel) {
                                return SizedBox();
                              }
                              return SizedBox(
                                height: 50,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Expanded(
                                      child: KeypadButton(
                                          text: AppLocalizations.of(context)!.translate('Back'),
                                          onTap: () {
                                            pendingPageBloc.eventSink.add(GoBack());
                                          }),
                                    ),
                                  ],
                                ),
                              );
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
                          StreamBuilder<OrderPendingViewState>(
                            stream: pendingPageBloc.orderState.stream,
                            initialData: OrderIsHidden(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data is OrderIsLoaded) {
                                return Expanded(
                                  flex: 1,
                                  child: VerticalTicketOptionsPending(bloc: pendingPageBloc),
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
                          StreamBuilder(
                            stream: pendingPageBloc.pendingOrder.stream,
                            initialData: pendingPageBloc.pendingOrder.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(width: 3, color: Theme.of(context).primaryColor)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50,
                                        color: Theme.of(context).primaryColor,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(AppLocalizations.of(context)!.translate('Pending Orders'),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange)),
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height * 0.8,
                                        color: Colors.white,
                                        child: PendingOrders(
                                          pendingPageBloc: pendingPageBloc,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
