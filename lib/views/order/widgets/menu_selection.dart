import 'package:flutter/material.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/models/menu_selection.dart';
import 'package:invo_mobile/views/order/widgets/popup_modifiers.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:collection/collection.dart';

import 'item.dart';

typedef MenuItem2VoidFunc = void Function(mi.MenuItem);

class MenuSelectionPanel extends StatefulWidget {
  final mi.MenuItem? item;
  final MenuItem2VoidFunc? onItemClicked;
  final Bool2VoidFunc? onCancel;
  final int level;
  final int? selected;
  MenuSelectionPanel({Key? key, this.item, this.level = 1, this.selected, this.onItemClicked, this.onCancel}) : super(key: key);

  @override
  _MenuSelectionPanelState createState() => _MenuSelectionPanelState();
}

class _MenuSelectionPanelState extends State<MenuSelectionPanel> {
  @override
  Widget build(BuildContext context) {
    MenuSelection? menuSelection = widget.item!.selections!.firstWhereOrNull((f) => f.level == widget.level);

    if (menuSelection == null) {
      widget.onCancel!(false);
      return Center();
    } else
      // ignore: curly_braces_in_flow_control_structures
      return Container(
        child: Column(
          children: <Widget>[
            // item text
            Container(
              height: 50,
              child: Center(
                child: Text(
                  "Choose any " + (menuSelection.no_of_selection - (widget.selected! - 1)).toString() + " items for " + widget.item!.name!,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // modifiers related to item

            Expanded(
              flex: 5,
              child: GridView.builder(
                // ignore: prefer_const_constructors
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 7,
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(3.5),
                itemCount: menuSelection.Selections!.length,
                itemBuilder: (context, index) {
                  return Item(
                    onTap: () {
                      if (widget.onItemClicked != null) widget.onItemClicked!(menuSelection.Selections![index].menuItem!);
                    },
                    item: menuSelection.Selections![index].menuItem!,
                  );
                },
              ),
            ),

            Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 70,
                      width: 200,
                      child: PrimaryButton(
                        text: "Cancel",
                        onTap: () {
                          if (widget.onCancel != null) widget.onCancel!(true);
                        },
                      ),
                    ),
                  )),
            )
          ],
        ),
      );
  }
}
