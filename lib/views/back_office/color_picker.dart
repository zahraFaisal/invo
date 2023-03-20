import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';

class ColorPicker extends StatefulWidget {
  final String initColor;
  final String2VoidFunc onChange;
  ColorPicker({Key? key, required this.initColor, required this.onChange}) : super(key: key);
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  void initState() {
    super.initState();
    backcolor = widget.initColor;
  }

  late String backcolor;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#FDAC2F";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Color(0xFFFDAC2F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: backcolor == "#FDAC2F"
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Center(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#FF7732";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 55,
                  decoration: BoxDecoration(color: Color(0xFFFF7732), borderRadius: BorderRadius.circular(10)),
                  child: backcolor == "#FF7732"
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Center(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#CA0050";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 55,
                  decoration: BoxDecoration(color: Color(0xFFCA0050), borderRadius: BorderRadius.circular(10)),
                  child: backcolor == "#CA0050"
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Center(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#007BE6";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 55,
                  decoration: BoxDecoration(color: Color(0xFF007BE6), borderRadius: BorderRadius.circular(10)),
                  child: backcolor == "#007BE6"
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Center(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#006FBD";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 55,
                  decoration: BoxDecoration(color: Color(0xFF006FBD), borderRadius: BorderRadius.circular(10)),
                  child: backcolor == "#006FBD"
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Center(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#3C2EB0";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 55,
                  decoration: BoxDecoration(color: Color(0xFF3C2EB0), borderRadius: BorderRadius.circular(10)),
                  child: backcolor == "#3C2EB0"
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Center(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#74B62E";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 100,
                    height: 55,
                    decoration: BoxDecoration(color: Color(0xFF74B62E), borderRadius: BorderRadius.circular(10)),
                    child: backcolor == "#74B62E"
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Center()),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#009623";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 100,
                    height: 55,
                    decoration: BoxDecoration(color: Color(0xFF009623), borderRadius: BorderRadius.circular(10)),
                    child: backcolor == "#009623"
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Center()),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#008387";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 100,
                    height: 55,
                    decoration: BoxDecoration(color: Color(0xFF008387), borderRadius: BorderRadius.circular(10)),
                    child: backcolor == "#008387"
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Center()),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  backcolor = "#692C07";
                  if (widget.onChange != null) widget.onChange(backcolor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 100,
                    height: 55,
                    decoration: BoxDecoration(color: Color(0xFF692C07), borderRadius: BorderRadius.circular(10)),
                    child: backcolor == "#692C07"
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Center()),
              ),
            ),
          ],
        ));
  }
}
