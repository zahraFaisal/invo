import 'dart:async';

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/settings/cloud_form_page/cloud_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/cloud_form_page/cloud_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/cloud_form_page/cloud_form_state.dart';
import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_state.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/widgets/check_box.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class CloudForm extends StatefulWidget {
  CloudForm({Key? key}) : super(key: key);

  @override
  _CloudFormState createState() => _CloudFormState();
}

class _CloudFormState extends State<CloudForm> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late CloudFormBloc cloudFormBloc;

  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cloudFormBloc = new CloudFormBloc();
    cloudFormBloc.loadServices();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    if (_timer != null) _timer!.cancel();

    super.dispose();

    cloudFormBloc.dispose();
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _formStateKey.currentState!.save();
    cloudFormBloc.eventSink.add(SaveCloud());
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Form(
      key: _formStateKey,
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: StreamBuilder(
          stream: cloudFormBloc.services.stream,
          initialData: cloudFormBloc.services.value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget saveBox = Center();

            if (cloudFormBloc.services.value is CloudIsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (cloudFormBloc.services.value is CloudIsLoading) {
            } else if (cloudFormBloc.services.value is CloudIsSaving) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    "Saving...",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ],
              ));
            } else if (cloudFormBloc.services.value is CloudSaved) {
              saveBox = FadeTransition(
                opacity: _animation,
                child: Container(
                  height: 50,
                  color: Colors.green,
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context)!.translate("Save Successfully"),
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )),
                ),
              );

              _controller.reset();
              _controller.forward();
            }

            return Column(
              children: <Widget>[
                saveBox,
                Expanded(child: orientation == Orientation.portrait ? portrait() : landscape()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget portrait() {
    return ListView(
      children: <Widget>[
        cloudSettings(),
        SizedBox(
          height: 20,
        ),
        actionsButtons(),
      ],
    );
  }

  Widget landscape() {
    return ListView(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: cloudSettings(),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        actionsButtons(),
      ],
    );
  }

  Widget cloudSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              "Invo Web",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('server'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton<String>(
            value: cloudFormBloc.cloudSettings.value!.server,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Server")),
            onChanged: (newValue) {
              setState(() {
                cloudFormBloc.cloudSettings.value!.server = newValue!.trim();
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: cloudFormBloc.serverList.value!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value != "" ? value : "NONE"),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Restaurant Slug'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: cloudFormBloc.cloudSettings.value!.restSlug,
          onSaved: (value) {
            cloudFormBloc.cloudSettings.value!.restSlug = value!.trim();
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Branch Name'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: cloudFormBloc.cloudSettings.value!.branch_name,
          onSaved: (value) {
            cloudFormBloc.cloudSettings.value!.branch_name = value!.trim();
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Password'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: cloudFormBloc.cloudSettings.value!.password,
          onSaved: (value) {
            cloudFormBloc.cloudSettings.value!.password = value!.trim();
          },
          obscureText: true,
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget actionsButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(left: 8.0),
            child: ButtonTheme(
              height: 70,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                child: Text(
                  AppLocalizations.of(context)!.translate('Save'),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                onPressed: () {
                  save();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
