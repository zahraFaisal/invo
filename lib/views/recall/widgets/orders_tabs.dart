import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_event.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/date_field.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:invo_mobile/helpers/priviligers.dart';

import 'order_summary.dart';

class OrderTabs extends StatefulWidget {
  final RecallPageBloc recallPageBloc;
  const OrderTabs({Key? key, required this.recallPageBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderTabsState();
  }
}

class _OrderTabsState extends State<OrderTabs> with TickerProviderStateMixin {
  late TabController tabController;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: widget.recallPageBloc.noOfTabs, vsync: this);
    tabController.addListener(() {
      if (widget.recallPageBloc.selectedService.value!.id == 4) {
        if (tabController.index == 2) {
          widget.recallPageBloc.eventSink.add(LoadPaidOrders(selectedDate));
        }
      } else {
        if (tabController.index == 1) {
          widget.recallPageBloc.eventSink.add(LoadPaidOrders(selectedDate));
        }
      }
      widget.recallPageBloc.setOrders();
    });
  }

  @override
  void didUpdateWidget(OrderTabs oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    tabController.addListener(() {
      if (widget.recallPageBloc.selectedService.value!.id == 4) {
        if (tabController.index == 2) {
          widget.recallPageBloc.eventSink.add(LoadPaidOrders(selectedDate));
        }
      } else {
        if (tabController.index == 1) {
          widget.recallPageBloc.eventSink.add(LoadPaidOrders(selectedDate));
        }
      }
      widget.recallPageBloc.setOrders();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        // tabs
        tabsOfOrders(),
        // tab bar view
        Expanded(child: tabBarViewsOfOrders()),
      ],
    );
  }

  Widget tabsOfOrders() {
    List<Widget> tabs = List<Widget>.empty(growable: true);
    if ((widget.recallPageBloc.selectedService.value!.id == 1 && !widget.recallPageBloc.selectedService.value!.showTableSelection) ||
        widget.recallPageBloc.selectedService.value!.id > 1)
      tabs.add(Container(
        width: 150,
        child: AutoSizeText(
          AppLocalizations.of(context)!.translate('Open Orders'),
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(height: 1),
          softWrap: true,
        ),
      ));

    if (widget.recallPageBloc.selectedService.value!.id == 4)
      tabs.add(Container(
        width: 150,
        child: AutoSizeText(
          AppLocalizations.of(context)!.translate('Delivered Orders'),
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(height: 1, fontSize: 16),
          softWrap: true,
        ),
      ));

    if (widget.recallPageBloc.setteldOrders == true)
      tabs.add(Container(
        width: 150,
        child: AutoSizeText(
          AppLocalizations.of(context)!.translate('Paid Orders'),
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(height: 1),
          softWrap: true,
        ),
      ));

    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(right: 8),
            constraints: const BoxConstraints(maxHeight: 150.0),
            decoration: new BoxDecoration(),
            child: TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              indicator: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              tabs: tabs,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: StreamBuilder(
            stream: widget.recallPageBloc.selectedService.stream,
            initialData: widget.recallPageBloc.selectedService.value,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) return const Center();
              return PopupMenuButton<Service>(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    (snapshot.data as Service).display_name!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                ),
                onSelected: (Service result) {
                  widget.recallPageBloc.eventSink.add(ChangeService(service: result));
                  var length = getTabsLength(result);
                  tabController = new TabController(length: length, vsync: this);
                },
                initialValue: widget.recallPageBloc.selectedService.value,
                elevation: 2,
                itemBuilder: (BuildContext context1) {
                  List<PopupMenuEntry<Service>> list = List<PopupMenuEntry<Service>>.empty(growable: true);
                  for (var item in widget.recallPageBloc.services) {
                    list.add(PopupMenuItem<Service>(
                      value: item,
                      child: Text(
                        item.display_name!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    ));
                  }
                  return list;
                },
              );
            },
          ),
        )
      ],
    );
  }

  getTabsLength(selectedService) {
    Privilege priv = new Privilege();

    if (selectedService.id == 4) {
      if (!priv.checkPrivilege1(Privilages.Setteld_Orders)) {
        return 2;
      } else {
        return 3;
      }
    }

    if (selectedService.id == 1) {
      if (selectedService.showTableSelection) {
        return 1;
      } else {
        return 2;
      }
    }

    if (!priv.checkPrivilege1(Privilages.Setteld_Orders)) {
      return 1;
    }
    return 2;
  }

  Widget tabBarViewsOfOrders() {
    List<Widget> views = List<Widget>.empty(growable: true);

    //Open Orders;
    if ((widget.recallPageBloc.selectedService.value!.id == 1 && !widget.recallPageBloc.selectedService.value!.showTableSelection) ||
        widget.recallPageBloc.selectedService.value!.id > 1)
      // ignore: curly_braces_in_flow_control_structures
      views.add(StreamBuilder(
        stream: widget.recallPageBloc.openOrder.stream,
        initialData: widget.recallPageBloc.openOrder.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (widget.recallPageBloc.openOrder.value == null)
            // ignore: curly_braces_in_flow_control_structures
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );

          List<MiniOrder> orders = widget.recallPageBloc.openOrder.value!;

          return Container(
              color: Colors.white,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: noOfColumns(orders), childAspectRatio: 0.90),
                itemBuilder: (context, index) {
                  return OrderSummary(
                    recallPageBloc: widget.recallPageBloc,
                    order: orders[index],
                  );
                },
                itemCount: orders.length,
              ));
        },
      ));

    //Delivered Orders
    if (widget.recallPageBloc.selectedService.value!.id == 4)
      views.add(StreamBuilder(
        stream: widget.recallPageBloc.deliveredOrder.stream,
        initialData: widget.recallPageBloc.deliveredOrder.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (widget.recallPageBloc.deliveredOrder.value == null)
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );

          List<MiniOrder> orders = widget.recallPageBloc.deliveredOrder.value!;

          return Container(
              color: Colors.white,
              child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: noOfColumns(orders), childAspectRatio: 0.90),
                itemBuilder: (context, index) {
                  return OrderSummary(
                    recallPageBloc: widget.recallPageBloc,
                    order: orders[index],
                  );
                },
                itemCount: orders.length,
              ));
        },
      ));

    //Setteled Orders
    if (widget.recallPageBloc.setteldOrders == true)
      views.add(Column(
        children: <Widget>[
          Container(
            height: 70,
            padding: const EdgeInsets.all(4),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: 200,
                  child: DatePicker(
                    selectedDate: DateTime.now(),
                    selectDate: (newValue) {
                      selectedDate = newValue;
                    },
                  ),
                ),
                Container(
                  width: 80,
                  child: PrimaryButton(
                    text: "Go",
                    onTap: () {
                      widget.recallPageBloc.eventSink.add(LoadPaidOrders(selectedDate));
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: widget.recallPageBloc.paidOrder.stream,
              initialData: widget.recallPageBloc.paidOrder.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<MiniOrder> orders = widget.recallPageBloc.paidOrder.value!;
                if (orders == null) return Container(color: Colors.white, child: const Center(child: const CircularProgressIndicator()));

                return Container(
                    color: Colors.white,
                    child: GridView.builder(
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: noOfColumns(orders), childAspectRatio: 0.90),
                      itemBuilder: (context, index) {
                        return OrderSummary(
                          recallPageBloc: widget.recallPageBloc,
                          order: orders[index],
                        );
                      },
                      itemCount: orders.length,
                    ));
              },
            ),
          )
        ],
      ));

    return TabBarView(
      controller: tabController,
      children: views,
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
