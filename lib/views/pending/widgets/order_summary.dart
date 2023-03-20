import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class PendingOrderSummary extends StatefulWidget {
  final Void2VoidFunc? tab;
  final MiniOrder order;
  final bool isSelected;
  final PendingPageBloc pendingPageBloc;
  const PendingOrderSummary({Key? key, this.tab, this.isSelected = false, required this.pendingPageBloc, required this.order}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PendingOrderSummaryState();
  }
}

class _PendingOrderSummaryState extends State<PendingOrderSummary> {
  @override
  Widget build(BuildContext context) {
    Color color;
    switch (widget.order.imageStatus) {
      case 1:
        color = Colors.green;
        break;
      case 2:
        color = Colors.purple;
        break;
      case 3:
        color = Colors.orange;
        break;
      case 4:
        color = Colors.red;
        break;
        break;
      case 6:
        color = Colors.blue;
        break;
      default:
        color = Colors.green;
    }

    return InkWell(
      //onTap: widget.tab,
      onTap: () {
        widget.pendingPageBloc.eventSink.add(ClickOnOrderSummary(order: widget.order, orientation: MediaQuery.of(context).orientation));
      },

      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(
                  width: (widget.order.isSelected) ? 3 : 0,
                  color: Colors.red,
                  style: (widget.order.isSelected) ? BorderStyle.solid : BorderStyle.none),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
              color: Colors.white,
            ),
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: StreamBuilder(
                      stream: widget.order.updated!.stream,
                      initialData: widget.order.updated!.value,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return Text(
                          widget.order.orderSince + " (" + widget.order.ticketNumber.toString() + ")",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Order " + widget.order.id.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.redAccent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      (widget.order.employeeName == "" || widget.order.employeeName == null) ? "" : widget.order.employeeName.toString(),
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    (widget.order.customer_contact == "" || widget.order.customerName == null) ? "" : "Cust :" + widget.order.customer_contact,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.order.customerName ?? "",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      Number.formatCurrency(widget.order.grandPrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      color: color,
                    ),
                    child: widget.order.table_name != null && widget.order.table_name != ""
                        ? Center(
                            child: Text(
                              "Table: " + widget.order.table_name.toString(),
                              style: TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          )
                        : Center(),
                  ),
                )
              ],
            ),
          ),
          (widget.order.prepared_date != null)
              ? Center(
                  child: Icon(Icons.check, size: 100, color: Colors.green[100]),
                )
              : Center(),
        ],
      ),
    );
  }
}
