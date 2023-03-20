import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/models/order/TransactionModifier.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';

class OrderPageTicket extends StatefulWidget {
  final OrderPageBloc orderPageBloc;
  OrderPageTicket({Key? key, required this.orderPageBloc}) : super(key: key);

  @override
  _OrderPageTicketState createState() => _OrderPageTicketState();
}

class _OrderPageTicketState extends State<OrderPageTicket> {
  @override
  Widget build(BuildContext context) {
    OrderPageBloc orderPageBloc = widget.orderPageBloc;
    return StreamBuilder(
      stream: orderPageBloc.order.stream,
      initialData: orderPageBloc.order.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Column(
          children: <Widget>[
            StreamBuilder(
              stream: orderPageBloc.orders.stream,
              initialData: orderPageBloc.orders.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (orderPageBloc.orders.value != null) {
                  return Container(
                    height: 60,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 9,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderPageBloc.orders.value!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  orderPageBloc.eventSink.add(ChangeTicket(orderPageBloc.orders.value![index]));
                                },
                                child: Container(
                                  width: 80,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: (orderPageBloc.orders.value![index] == orderPageBloc.order.value) ? Colors.white : Colors.grey,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 30,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            orderPageBloc.eventSink.add(AddNewTicket());
                          },
                          child: Container(
                            width: 80,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "+",
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1, fontSize: 40),
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            Expanded(
              flex: 9,
              child: new OrderCart(
                order: orderPageBloc.order.value!,
                onItemClicked: (transaction) {
                  orderPageBloc.eventSink.add(SelectTransaction(transaction));
                },
                onModifierDelete: (TransactionModifier modifier) {
                  orderPageBloc.eventSink.add(RemoveTransactionModifier(modifier, selectedTranscation: true));
                },
                onDiscountDelete: (transaction) {
                  orderPageBloc.eventSink.add(RemoveTransactionDiscount());
                },
                onDelete: (transaction) {
                  orderPageBloc.eventSink.add(RemoveTransaction(transaction));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
