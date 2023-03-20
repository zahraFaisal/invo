import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuForm/menu_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuForm/menu_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class MenuTypeForm extends StatefulWidget {
  final int id;
  MenuTypeForm(this.id, {Key? key}) : super(key: key);

  @override
  _MenuTypeFormState createState() => _MenuTypeFormState();
}

class _MenuTypeFormState extends State<MenuTypeForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late MenuType menu;
  late MenuTypeFormBloc menuTypeFormBloc;
  @override
  void initState() {
    super.initState();

    menuTypeFormBloc = MenuTypeFormBloc(BlocProvider.of<NavigatorBloc>(context));
    menuTypeFormBloc.loadMenu(widget.id);
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    menuTypeFormBloc.nameValidation = "";
    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await menuTypeFormBloc.asyncValidate(menu)) {
        menuTypeFormBloc.eventSink.add(SaveMenu(menu));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          AppLocalizations.of(context)!.translate('Menu'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.translate("Save"),
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              save();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder(
          stream: menuTypeFormBloc.menu.stream,
          initialData: menuTypeFormBloc.menu.value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (menuTypeFormBloc.menu.value == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            menu = menuTypeFormBloc.menu.value!;
            return Form(
              key: _formStateKey,
              child: ListView(
                children: <Widget>[
                  nameField(),
                  startTimeField(),
                  SizedBox(
                    height: 20,
                  ),
                  priceLableField(),
                  SizedBox(
                    height: 20,
                  ),
                  actionsButtons(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget actionsButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ButtonTheme(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                child: Text(
                  AppLocalizations.of(context)!.translate('Cancel'),
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                onPressed: () {
                  cancel();
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ButtonTheme(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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

  Widget nameField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            AppLocalizations.of(context)!.translate('Name'),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: TextFormField(
            onSaved: (value) {
              menu.name = value!;
            },
            initialValue: menu.name,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              } else if (menuTypeFormBloc.nameValidation != "") {
                return menuTypeFormBloc.nameValidation;
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  bool isStartTimeEnabled = false;
  Widget startTimeField() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('Start Time'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              onChanged: (value) {
                setState(() {
                  isStartTimeEnabled = !isStartTimeEnabled;
                });
              },
              value: isStartTimeEnabled,
            ),
          ],
        ),
        TextFormField(
          readOnly: true,
          initialValue: "",
          enabled: isStartTimeEnabled,
          onSaved: (value) {},
          onTap: () {
            DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              onConfirm: (time) {},
            );
          },
          decoration: InputDecoration(fillColor: isStartTimeEnabled ? Colors.white : Colors.grey, filled: true, labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget priceLableField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(
        AppLocalizations.of(context)!.translate('Apply this price'),
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
        child: DropdownButton<int>(
          value: menuTypeFormBloc.labelId,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          hint: Text(AppLocalizations.of(context)!.translate("Select Price")),
          onChanged: (int? newValue) {
            setState(() {
              menu.price_id = newValue!;
            });
          },
          style: TextStyle(color: Colors.black),
          underline: Container(
            color: Colors.white,
          ),
          items: menuTypeFormBloc.labels.value!.map<DropdownMenuItem<int>>((PriceLabel value) {
            return DropdownMenuItem<int>(
              value: value.id,
              child: Text(value.name!),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
