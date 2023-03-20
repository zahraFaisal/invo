import 'package:flutter/material.dart';

class MessageDialog extends StatefulWidget {
  final String title;
  final String description;
  final String firstButtonText;

  const MessageDialog({
    required Key key,
    required this.title,
    required this.description,
    required this.firstButtonText,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MessageDialogState();
  }
}

class _MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: double.infinity,
        height: 130,
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 17.5),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(widget.firstButtonText),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
