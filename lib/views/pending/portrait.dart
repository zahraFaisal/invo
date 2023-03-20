import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_state.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/custom/search.dart';
import 'package:invo_mobile/views/pending/widgets/vertical_ticket_options.dart';
import 'package:invo_mobile/views/pending/widgets/pending_orders.dart';
import 'package:invo_mobile/widgets/date_field.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/layout/header_landscape.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import '../blocProvider.dart';

class PendingPagePprtrait extends StatefulWidget {
  PendingPagePprtrait({Key? key}) : super(key: key);

  @override
  _PendingPagePprtraitState createState() => _PendingPagePprtraitState();
}

class _PendingPagePprtraitState extends State<PendingPagePprtrait> {
  late PendingPageBloc pendingPageBloc;
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
  }

  @override
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
                  flex: 6,
                  child: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: PendingOrders(
                                            pendingPageBloc: pendingPageBloc,
                                          ),
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
                          pendingPageBloc.eventSink.add(GoBack());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                          AppLocalizations.of(context)!.translate("From"),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
