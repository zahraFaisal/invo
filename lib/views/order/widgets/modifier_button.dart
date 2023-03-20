import 'package:flutter/material.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/widgets/buttons/secondary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

import '../../../repositories/connection_repository.dart';
import '../../../service_locator.dart';

class ModifierButton extends StatefulWidget {
  final Void2VoidFunc? onSelect;
  final Void2VoidFunc? onDeSelect;
  final OrderTransaction? transaction;
  final MenuModifier? modifier;
  ModifierButton({Key? key, this.transaction, this.modifier, this.onSelect, this.onDeSelect}) : super(key: key);

  @override
  _ModifierButtonState createState() => _ModifierButtonState();
}

class _ModifierButtonState extends State<ModifierButton> {
  bool exist = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exist = false;
  }

  @override
  void didUpdateWidget(ModifierButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.transaction != null && widget.transaction!.modifiers!.where((f) => f.modifier!.id == widget.modifier!.id).length > 0) {
      exist = true;
    } else {
      exist = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    if (exist) color = Colors.blueAccent;

    String secondaryLang = locator.get<ConnectionRepository>().preference!.secondary_lang_code;
    String lang = locator.get<ConnectionRepository>().terminal!.langauge ?? "";

    String? displayName = widget.modifier!.display;
    if (lang == secondaryLang && widget.modifier!.secondary_display_name != null && widget.modifier!.secondary_display_name!.isNotEmpty) {
      displayName = widget.modifier?.secondary_display_name!;
    }

    return SecondaryButton(
      color: color,
      onTap: () {
        if (exist) {
          exist = false;
          if (widget.onDeSelect != null) {
            widget.onDeSelect!();
          }
        } else {
          exist = true;
          if (widget.onSelect != null) {
            widget.onSelect!();
          }
        }
        setState(() {});
      },
      text: displayName ?? "",
      isBorderRounded: true,
    );
  }
}
