import 'package:auto_size_text/auto_size_text.dart';
import "package:flutter/material.dart";

typedef Void2VoidFunc = void Function();

class KeypadButton extends StatefulWidget {
  final String text;
  final Void2VoidFunc onTap;
  final bool isButtonLight;

  const KeypadButton({Key? key, required this.text, required this.onTap, this.isButtonLight = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeypadButtonState();
  }
}

class _KeypadButtonState extends State<KeypadButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
          padding: EdgeInsets.all(1),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> state) {
                  if (state.contains(MaterialState.disabled)) {
                    return widget.isButtonLight == true ? Colors.white : Theme.of(context).primaryColor;
                  } else {
                    return Colors.white;
                  }
                }),
                foregroundColor: MaterialStateProperty.all(widget.isButtonLight == true ? Colors.black : Colors.white),
                shape: MaterialStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: Colors.grey)))),
            onPressed: null,
            child: AutoSizeText(
              widget.text,
              maxLines: 1,
              softWrap: true,
              //   overflow : TextOverflow.clip ,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, height: 1),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
