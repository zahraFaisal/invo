import 'package:flutter/material.dart';

class FooterLandscape extends StatefulWidget {
  final double? height;
  final double? deviceSize;
  final bool isSelected = true;

  const FooterLandscape({Key? key, this.height, this.deviceSize}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FooterLandscapeState();
  }
}

class _FooterLandscapeState extends State<FooterLandscape> {
  double paddingBetweenIconsInFooter = 35;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      height: widget.height,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Image.asset(
                    "assets/icons/setting.png",
                    width: 30,
                    height: 30,
                  ),
                ),
                widget.isSelected == true
                    ? Padding(
                        padding: EdgeInsets.only(left: paddingBetweenIconsInFooter),
                        child: Image.asset(
                          "assets/icons/lock.png",
                          width: 30,
                          height: 30,
                        ),
                      )
                    : Image.asset(""),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                widget.isSelected == true
                    ? Padding(
                        padding: EdgeInsets.only(right: paddingBetweenIconsInFooter),
                        child: Image.asset(
                          "assets/icons/cash_drawer.png",
                          width: 45,
                          height: 45,
                        ),
                      )
                    : Image.asset(""),
                Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Image.asset(
                    "assets/icons/search.png",
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
