import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invo_mobile/blocs/activation_register/activation_register_bloc.dart';
import 'package:invo_mobile/views/activation_register/card_formatter.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';

class ActivationRegisterPortrait extends StatefulWidget {
  ActivationRegisterPortrait({Key? key}) : super(key: key);

  @override
  State<ActivationRegisterPortrait> createState() => _ActivationRegisterPortraitState();
}

class _ActivationRegisterPortraitState extends State<ActivationRegisterPortrait> {
  ActivationRegisterBloc? activationRegisterBloc;
  String? sKey;

  @override
  void initState() {
    super.initState();
    activationRegisterBloc = new ActivationRegisterBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  Widget build(BuildContext context) {
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
          // color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Serial Number",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                inputFormatters: [LengthLimitingTextInputFormatter(19), CardFormatter(sample: 'xxxx-xxxx-xxxx-xxxx', separator: '-')],
                onChanged: (value) {
                  sKey = value;
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350.0,
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                    elevation: MaterialStateProperty.all<double>(5),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey[300],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350.0,
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                    elevation: MaterialStateProperty.all<double>(5),
                  ),
                  child: Text(
                    'Activate',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[300],
                    ),
                  ),
                  onPressed: () {
                    if (sKey != null) if (sKey!.length == 19) save();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void save() {
    activationRegisterBloc?.save(sKey);
  }
}
