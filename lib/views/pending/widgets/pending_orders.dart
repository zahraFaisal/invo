import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/date_field.dart';
import './order_summary.dart';
import 'dart:convert';

class PendingOrders extends StatefulWidget {
  final PendingPageBloc pendingPageBloc;
  const PendingOrders({Key? key, required this.pendingPageBloc}) : super(key: key);

  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> with TickerProviderStateMixin {
  late TabController tabController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.pendingPageBloc.eventSink.add(LoadPendingOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            stream: widget.pendingPageBloc.pendingOrder.stream,
            initialData: widget.pendingPageBloc.pendingOrder.value,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<MiniOrder>? orders = widget.pendingPageBloc.pendingOrder.value;
              if (orders == null) return Container(color: Colors.white, child: Center(child: CircularProgressIndicator()));
              return Container(
                  color: Colors.white,
                  child: GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: noOfColumns(orders), childAspectRatio: 0.90),
                    itemBuilder: (context, index) {
                      return PendingOrderSummary(
                        pendingPageBloc: widget.pendingPageBloc,
                        order: orders[index],
                      );
                    },
                    itemCount: orders.length,
                  ));
            },
          ),
        )
      ],
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
