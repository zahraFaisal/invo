import 'package:flutter/material.dart';
import 'landscape.dart';
import 'portrait.dart';

class ActivationForm extends StatefulWidget {
  ActivationForm({Key? key}) : super(key: key);

  @override
  _ActivationFormState createState() => _ActivationFormState();
}

class _ActivationFormState extends State<ActivationForm> {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return SafeArea(
        child: Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Container(
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
              border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 5,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: orientation == Orientation.portrait ? ActivationFormPortrait() : ActivationFormLandscape(),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
