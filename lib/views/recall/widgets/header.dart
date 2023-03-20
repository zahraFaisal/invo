import 'package:flutter/material.dart';

class RecallPageHeaderLandscape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return // header of page
        Row(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/icons/logo-2.png",
                width: 120,
                height: 70,
              ),
              Icon(Icons.info),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                "Owner",
                style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(7.5),
                child: TextButton(
                  onPressed: null,
                  child: Image.asset(
                    "assets/icons/profile_icon.png",
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
