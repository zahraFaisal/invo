import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_state.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

import 'modifier_button.dart';

class ModifierList extends StatefulWidget {
  final Void2VoidFunc? onFinish;
  final OrderPageBloc orderPageBloc;
  ModifierList({Key? key, required this.orderPageBloc, this.onFinish}) : super(key: key);

  @override
  _ModifierListState createState() => _ModifierListState();
}

class _ModifierListState extends State<ModifierList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(2),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                // Container(
                //   width: 150,
                //   padding: EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     border: Border(
                //       right: BorderSide(
                //         width: 6,
                //         color: Theme.of(context).primaryColor,
                //       ),
                //     ),
                //   ),
                //   child: ListView.builder(
                //     itemCount: widget.orderPageBloc.modifierListFilters.length,
                //     itemBuilder: (context, index) {
                //       return Container(
                //         height: 60,
                //         child: SecondaryButton(
                //           text: widget.orderPageBloc.modifierListFilters[index],
                //         ),
                //       );
                //     },
                //   ),
                // ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: StreamBuilder(
                      stream: widget.orderPageBloc.order.value!.itemSelected.stream,
                      initialData: widget.orderPageBloc.order.value!.itemSelected.value,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.shortestSide < 500 ? 2 : 5,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: widget.orderPageBloc.modifiers.length,
                          itemBuilder: (context, index) {
                            return ModifierButton(
                              modifier: widget.orderPageBloc.modifiers[index],
                              transaction: widget.orderPageBloc.order.value!.itemSelected.value,
                              onSelect: () {
                                widget.orderPageBloc.eventSink
                                    .add(AddTransactionModifier(widget.orderPageBloc.modifiers[index], selectedTranscation: true));
                              },
                              // onDeSelect: () {
                              //   widget.orderPageBloc.eventSink.add(
                              //       RemoveTransactionModifier(
                              //           widget.orderPageBloc.modifiers[index],
                              //           selectedTranscation: true));
                              // },
                              //text: widget.orderPageBloc.modifiers[index].display,
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 6,
                ),
              ),
            ),
            child: Center(
              child: Container(
                width: 160,
                height: 80,
                color: Colors.white,
                child: PrimaryButton(
                  onTap: () {
                    widget.onFinish!();
                  },
                  text: "Finish",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
