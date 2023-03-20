import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/MenuGroupForm/Menu_group_state.dart';
import 'package:invo_mobile/blocs/back_office/Menu/MenuGroupForm/menu_group_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/MenuGroupForm/menu_group_form_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../../service_locator.dart';
import '../../../blocProvider.dart';

class MenuGroupForm extends StatefulWidget {
  final int id;
  final int menuId;
  MenuGroupForm(this.id, this.menuId, {Key? key}) : super(key: key);

  @override
  _MenuGroupFormState createState() => _MenuGroupFormState();
}

class _MenuGroupFormState extends State<MenuGroupForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late MenuGroup group;
  late MenuGroupFormBloc menuGroupFormBloc;
  @override
  void initState() {
    super.initState();

    locator.registerSingleton<MenuGroupFormBloc>(MenuGroupFormBloc(BlocProvider.of<NavigatorBloc>(context)));

    menuGroupFormBloc = locator.get<MenuGroupFormBloc>();
    menuGroupFormBloc.loadMenuGroup(widget.id, widget.menuId);
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    menuGroupFormBloc.nameValidation = "";
    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await menuGroupFormBloc.asyncValidate(group)) {
        menuGroupFormBloc.eventSink.add(SaveMenuGroup(group));
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
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: menuGroupFormBloc.group.stream,
          initialData: menuGroupFormBloc.group.value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (menuGroupFormBloc.group.value is MenuGroupIsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (menuGroupFormBloc.group.value is MenuGroupIsLoaded) {
              group = (menuGroupFormBloc.group.value as MenuGroupIsLoaded).menuGroup!;
              return Form(
                key: _formStateKey,
                child: ListView(
                  children: <Widget>[
                    nameField(),
                    colorField(),
                    actionsButtons(),
                  ],
                ),
              );
            }

            return Center();
          },
        ),
      ),
    );
  }

  Widget nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            onSaved: (String? value) {
              group.name = value!;
            },
            initialValue: group.name,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              } else if (menuGroupFormBloc.nameValidation != "") {
                return menuGroupFormBloc.nameValidation;
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget colorField() {
    return Container(
        child: Wrap(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              group.backcolor = "#FDAC2F";
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
              child: group.backcolor == "#FDAC2F"
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
              group.backcolor = "#FF7732";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 55,
              decoration: BoxDecoration(color: Color(0xFFFF7732), borderRadius: BorderRadius.circular(10)),
              child: group.backcolor == "#FF7732"
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
              group.backcolor = "#CA0050";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 55,
              decoration: BoxDecoration(color: Color(0xFFCA0050), borderRadius: BorderRadius.circular(10)),
              child: group.backcolor == "#CA0050"
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
              group.backcolor = "#007BE6";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 55,
              decoration: BoxDecoration(color: Color(0xFF007BE6), borderRadius: BorderRadius.circular(10)),
              child: group.backcolor == "#007BE6"
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
              group.backcolor = "#006FBD";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 55,
              decoration: BoxDecoration(color: Color(0xFF006FBD), borderRadius: BorderRadius.circular(10)),
              child: group.backcolor == "#006FBD"
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
              group.backcolor = "#3C2EB0";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 55,
              decoration: BoxDecoration(color: Color(0xFF3C2EB0), borderRadius: BorderRadius.circular(10)),
              child: group.backcolor == "#3C2EB0"
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
              group.backcolor = "#74B62E";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 100,
                height: 55,
                decoration: BoxDecoration(color: Color(0xFF74B62E), borderRadius: BorderRadius.circular(10)),
                child: group.backcolor == "#74B62E"
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
              group.backcolor = "#009623";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 100,
                height: 55,
                decoration: BoxDecoration(color: Color(0xFF009623), borderRadius: BorderRadius.circular(10)),
                child: group.backcolor == "#009623"
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
              group.backcolor = "#008387";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 100,
                height: 55,
                decoration: BoxDecoration(color: Color(0xFF008387), borderRadius: BorderRadius.circular(10)),
                child: group.backcolor == "#008387"
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
              group.backcolor = "#692C07";
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 100,
                height: 55,
                decoration: BoxDecoration(color: Color(0xFF692C07), borderRadius: BorderRadius.circular(10)),
                child: group.backcolor == "#692C07"
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

  Widget actionsButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          margin: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            height: 70,
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
        Container(
          width: 150,
          margin: const EdgeInsets.all(8.0),
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
      ],
    );
  }
}
