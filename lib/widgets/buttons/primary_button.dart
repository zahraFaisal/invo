import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final bool isEnabled;
  final Void2VoidFunc? onTap;
  final double fontSize;
  const PrimaryButton({Key? key, required this.text, this.onTap, this.isEnabled = true, this.fontSize = 21}) : super(key: key);

  State<StatefulWidget> createState() {
    return _PrimaryButtonState();
  }
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    String txt = widget.text;
    if (widget.text.length > 20) {
      txt = widget.text.substring(0, 20);
    }
    return InkWell(
        onTap: () {
          if (widget.isEnabled && widget.onTap != null) widget.onTap!();
        },
        child: Container(
          decoration: BoxDecoration(
              color: (widget.isEnabled) ? Theme.of(context).primaryColor : Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(7.0),
              )),
          // color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(txt,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, height: 1, fontWeight: FontWeight.w900, fontSize: widget.fontSize)),
          ),
        ));
  }
}
