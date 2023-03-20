import 'dart:math';

import 'package:flutter/material.dart';
import 'package:invo_mobile/models/Menu_popup_mod.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:collection/collection.dart';

import 'modifier_button.dart';

typedef Bool2VoidFunc = void Function(bool);
typedef Modifier2VoidFunc = void Function(MenuModifier, {required bool isForced});

class PopUpModifiers extends StatefulWidget {
  final mi.MenuItem item;
  final Modifier2VoidFunc onModifierClicked;
  final Bool2VoidFunc onCancel;
  PopUpModifiers({Key? key, required this.item, required this.onCancel, required this.onModifierClicked});
  @override
  State<StatefulWidget> createState() {
    return _PopUpModifiersState();
  }
}

class _PopUpModifiersState extends State<PopUpModifiers> {
  int level = 1;
  int repeated = 0;
  late MenuPopupMod? popupMod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadParentModifier();
  }

  void _increaseRepeat() {
    repeated++;
    if (popupMod!.repeat <= repeated) {
      _next();
    }
  }

  void _next() {
    level++;
    _loadParentModifier();
  }

  void _loadParentModifier() {
    popupMod = widget.item.popup_mod!.isNotEmpty ? widget.item.popup_mod!.firstWhereOrNull((f) => f.level == level) : null;
    repeated = 0;

    if (popupMod == null) {
      widget.onCancel(false);
      level = 1;
      repeated = 0;
    } else {
      debugPrint("next test");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (popupMod == null) _loadParentModifier();

    if (popupMod != null) {
      popupMod?.modifiers = popupMod!.modifiers.where((element) => element.modifier != null).toList();

      return Container(
        child: Column(
          children: <Widget>[
            // item text
            Container(
              height: 65,
              padding: EdgeInsets.all(6),
              child: Center(
                child: Text(
                  (popupMod!.description == null || popupMod!.description == "") ? "How do you want the " + widget.item.name! : popupMod!.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // modifiers related to item

            Expanded(
                flex: 5,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 7,
                    crossAxisCount: MediaQuery.of(context).size.shortestSide < 500 ? 2 : 4,
                    childAspectRatio: 2.0,
                  ),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(3.5),
                  itemCount: popupMod!.modifiers.length,
                  itemBuilder: (context, index) {
                    return ModifierButton(
                      key: Key(Random().nextInt(10000000).toString()),
                      modifier: popupMod!.modifiers[index].modifier,
                      onSelect: () {
                        widget.onModifierClicked(popupMod!.modifiers[index].modifier!, isForced: popupMod!.is_forced);
                        _increaseRepeat();
                      },
                      //text: widget.orderPageBloc.modifiers[index].display,
                    );
                    //       PrimaryButton(
                    // onTap: () {
                    //   widget.onModifierClicked(
                    //       popupMod.modifiers[index].modifier,
                    //       isForced: popupMod.is_forced);
                    //   _increaseRepeat();
                    // },
                    // text: popupMod.modifiers[index].modifier.display);
                  },
                )),

            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: SizedBox(
                            height: 70,
                            child: PrimaryButton(
                              text: AppLocalizations.of(context)!.translate('Cancel'),
                              onTap: () {
                                widget.onCancel(true);
                              },
                            ),
                          ))),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: SizedBox(
                            height: 70,
                            child: PrimaryButton(
                              onTap: () {
                                if (popupMod!.is_forced) return;
                                _next();
                              },
                              isEnabled: !popupMod!.is_forced,
                              text: AppLocalizations.of(context)!.translate('Next'),
                            ),
                          ))),
                ],
              ),
            )
          ],
        ),
      );
    } else
      return Container();
  }
}
