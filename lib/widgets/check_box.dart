import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class CheckBox extends StatefulWidget {
  final String? title;
  final Widget? child;
  final double? size;
  final bool? isSelected;
  final Void2VoidFunc? onTap;

  CheckBox(this.title, {this.child, this.size = 30, this.isSelected, this.onTap});
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    Widget text;
    if (widget.child == null) {
      text = Text(
        widget.title!,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      );
    } else {
      text = widget.child!;
    }

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              child: Icon(
                widget.isSelected! ? Icons.check_circle : Icons.cancel,
                size: widget.size,
                color: widget.isSelected! ? Colors.green : Colors.red,
              ),
            ),
            Expanded(child: text),
          ],
        ),
      ),
    );
  }
}
