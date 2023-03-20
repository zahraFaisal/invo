import 'package:flutter/material.dart';

class OrderCartCloseButton extends StatefulWidget {
  final bool isOrderCartInDailog;

  const OrderCartCloseButton({Key? key, this.isOrderCartInDailog = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OrderCartCloseButtonState();
  }
}

class _OrderCartCloseButtonState extends State<OrderCartCloseButton> {
  @override
  Widget build(BuildContext context) {
    // if order cart in dialog show close button else return null
    return widget.isOrderCartInDailog == true
        ? Container(
            width: 55,
            height: 35,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFA00000)),
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Icon(
                  Icons.close,
                  //size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          )

        // else return Empty Container
        : Container();
  }
}
