import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/order/employee_reference.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/service_reference.dart';
import 'package:invo_mobile/views/order/widgets/ticket.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/layout/header_landscape.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';

class SplitTicketPage extends StatefulWidget {
  SplitTicketPage({Key? key}) : super(key: key);

  @override
  _SplitTicketPageState createState() => _SplitTicketPageState();
}

class _SplitTicketPageState extends State<SplitTicketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            HeaderLandscape(),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemExtent: 350,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    print(index);
                    if (index == 2) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 4,
                        )),
                        child: Center(
                          child: IconButton(
                            onPressed: () {},
                            iconSize: 50,
                            icon: Icon(Icons.add_circle_outline),
                          ),
                        ),
                      );
                    } else
                      // ignore: curly_braces_in_flow_control_structures
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 4,
                        )),
                        child: OrderCart(
                          order: OrderHeader(
                              terminal_id: 1,
                              service: ServiceReference(id: 1, name: "Dine In"),
                              employee: EmployeeReference(id: 1, name: "Alsaro"),
                              employee_id: 1,
                              payments: [],
                              service_id: 1,
                              transaction: []),
                        ),
                      );
                    // return OrderPageTicket(orderPageBloc: null,null,OrderHeader(terminal_id: 1,),),);
                  },
                ),
              ),
            ),
            Container(
                height: 100,
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: PrimaryButton(
                        text: "Cancel",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 150,
                      child: PrimaryButton(
                        text: "Done",
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
