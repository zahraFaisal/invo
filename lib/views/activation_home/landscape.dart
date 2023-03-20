import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/activation_home/activation_home_bloc.dart';
import 'package:invo_mobile/blocs/activation_home/activation_home_event.dart';
import '../blocProvider.dart';
import '../../service_locator.dart';

class ActivationHomeLandscape extends StatefulWidget {
  ActivationHomeLandscape({Key? key}) : super(key: key);

  @override
  _ActivationHomeLandscapeState createState() => _ActivationHomeLandscapeState();
}

class _ActivationHomeLandscapeState extends State<ActivationHomeLandscape> {
  ActivationHomeBloc? activationHomeBloc;

  @override
  void initState() {
    super.initState();
    activationHomeBloc = locator.get<ActivationHomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 250.0,
            height: 50.0,
            child: ElevatedButton(
              child: Text(
                'Demo',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(5),
              ),
              onPressed: () {
                activationHomeBloc?.eventSink.add(GoToActivationFormPage());
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              "using invo POS for 30 days only",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 250.0,
            height: 50.0,
            child: ElevatedButton(
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(5),
              ),
              onPressed: () {
                activationHomeBloc!.eventSink.add(GoToActivationRegisterPage());
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              "register the software using serial number",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 250.0,
            height: 50.0,
            child: ElevatedButton(
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(5),
              ),
              onPressed: () {
                activationHomeBloc!.eventSink.add(GoBack());
              },
            ),
          ),
        ],
      ),
    );
  }
}
