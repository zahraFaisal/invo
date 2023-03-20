import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class SecondaryButton extends StatefulWidget {
  final String text;
  final Color? color;
  final Void2VoidFunc? onTap;
  final bool isBorderRounded;

  const SecondaryButton({Key? key, required this.text, this.onTap, this.color, this.isBorderRounded = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SecondaryButtonState();
  }
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.isBorderRounded == true ? Color(0xFF9A9A9C) : Color(0xFFBFBFBF);

    if (widget.color != null) color = widget.color!;

    return InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.only(right: 1, bottom: 1),
          child: Container(
              width: 130,
              alignment: Alignment.center,
              //color : Color(0xFFC7C6C5) ,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: color,
                  width: 5.0,
                ),
                borderRadius: widget.isBorderRounded == true ? BorderRadius.circular(19) : BorderRadius.circular(0),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, height: 1, color: Colors.black54, fontSize: 14),
                ),
              )),
        ));
  }
}
