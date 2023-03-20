import 'package:flutter/material.dart';
import 'package:invo_mobile/models/order/order_header.dart';

import 'package:invo_mobile/widgets/order_cart/order_cart.dart';

class MultiTickets extends StatefulWidget {
  final List<OrderHeader> orders;
  MultiTickets(this.orders);
  @override
  State<StatefulWidget> createState() {
    return _MultiTicketsState();
  }
}

class _MultiTicketsState extends State<MultiTickets> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: widget.orders.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.empty(growable: true);
    for (var item in widget.orders) {
      widgets.add(OrderCart(
        order: item,
      ));
    }

    return Container(
        child: Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                  //  flex: 1,
                  child: Column(
                children: <Widget>[
                  Container(
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 45,
                              width: 300,
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.only(left: 8, right: 8),
                              constraints: BoxConstraints(maxHeight: 150.0),
                              decoration: BoxDecoration(),
                              child: TabBar(
                                controller: tabController,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.white,

                                // labelStyle: TextStyle( fontSize: 15 , color : Colors.black , fontWeight: FontWeight.bold ) ,
                                // unselectedLabelColor: Colors.b ,
                                tabs: [
                                  Tab(text: "1"
                                      //AppLocalizations.of(context).translate('open orders')
                                      // text: AppLocalizations.of(context)
                                      //     .translate('open orders'),
                                      ),
                                  Tab(text: "2"
                                      // text: AppLocalizations.of(context)
                                      //     .translate('settled orders'),
                                      ),
                                  Tab(text: "3"
                                      // text: AppLocalizations.of(context)
                                      //     .translate('rejected orders'),
                                      ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 10,
                          ),

                          // Container(
                          // margin: EdgeInsets.only(top : 14),
                          // height: 40 ,
                          //               color: Colors.red,
                          //               child: Text("fdf"),
                          //             )
                          //            ,

                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () => print('hello'),
                              child: Container(
                                width: 9.0,
                                margin: EdgeInsets.only(top: 10),
                                height: 45.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  border: Border.all(
                                    color: Colors.grey[600]!,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: 32.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: widgets,
                        ),
                      ),
                      // OrderCartButtons(),
                    ],
                  ))
                ],
              )),
              // Expanded(flex: 1, child: OrderCartOptions())
            ],
          ),
        )
      ],
    ));
  }
}
