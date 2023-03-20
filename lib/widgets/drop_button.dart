import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>>? items;
  final dynamic initalDisplay;
  DropDownList({Key? key, this.initalDisplay, this.items}) : super(key: key);

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  dynamic typeValue;

  @override
  void initState() {
    super.initState();
    typeValue = widget.initalDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      value: typeValue,
      items: widget.items,
      onChanged: (_) {
        setState(() {
          typeValue = _;
        });
      },
    );
  }
}

class DropDownListItem {
  dynamic value;
  late String display;
}
