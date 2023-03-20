import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class OrderCartFooterButton extends StatefulWidget {
  final String name;
  final Void2VoidFunc? tap;

  const OrderCartFooterButton({Key? key, this.name = "", this.tap}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderCartFooterButtonState();
  }
}

class _OrderCartFooterButtonState extends State<OrderCartFooterButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: widget.tap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                //                   <--- left side
                color: Colors.black,
                width: 3.0,
              ),
              top: BorderSide(
                //                    <--- top side
                color: Colors.black,
                width: 3.0,
              ),
            ),
          ),
        ));
  }
}
