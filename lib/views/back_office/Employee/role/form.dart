import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Role_form_page/Role_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Role_form_page/Role_form_event.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Role_form_page/Role_form_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/widgets/check_box.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../../service_locator.dart';
import '../../../blocProvider.dart';

class RoleForm extends StatefulWidget {
  int? id;
  RoleForm({Key? key, this.id}) : super(key: key);

  @override
  _RoleFormState createState() => _RoleFormState();
}

class _RoleFormState extends State<RoleForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  RoleFormPageBloc? roleFormBloc;
  int tabindex = 0;
  Role? role;
  List<String> list = ['Security', 'Report', 'Notification'];

  void initState() {
    super.initState();
    role = Role();
    roleFormBloc = RoleFormPageBloc(BlocProvider.of<NavigatorBloc>(context));
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    roleFormBloc!.dispose();
  }

  void loadData() async {
    await roleFormBloc!.loadRole(widget.id!);
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await roleFormBloc!.asyncValidate(role!)) {
        roleFormBloc!.eventSink!.add(SaveRole(role!));
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
        body: StreamBuilder(
            stream: roleFormBloc!.roles!.stream,
            initialData: roleFormBloc!.roles!.value,
            builder: (BuildContext context, AsyncSnapshot<RoleLoadState> snapshot) {
              if (roleFormBloc!.roles!.value is RoleIsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (roleFormBloc!.roles!.value is RoleIsLoaded) role = (roleFormBloc!.roles!.value as RoleIsLoaded).role;
              return Form(
                key: _formStateKey,
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[900],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context)!.translate("Roles"),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                  InkWell(
                                      child:
                                          Text(AppLocalizations.of(context)!.translate("Save"), style: TextStyle(color: Colors.white, fontSize: 20)),
                                      onTap: () {
                                        save();
                                      })
                                ],
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppLocalizations.of(context)!.translate('Role'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: (role != null) ? role!.name : "",
                                    onSaved: (value) {
                                      role!.name = value!;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter some text';
                                      } else if (roleFormBloc!.nameValidation != "") {
                                        return roleFormBloc!.nameValidation;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: FormField(
                                          onSaved: (bool? value) {
                                            role!.in_active = value!;
                                          },
                                          validator: null,
                                          initialValue: role!.in_active,
                                          builder: (FormFieldState<bool> state) {
                                            return SwitchListTile(
                                              activeColor: Colors.green,
                                              title: Text(
                                                AppLocalizations.of(context)!.translate('In Active'),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              value: state.value!,
                                              onChanged: (bool value) => state.didChange(value),
                                            );
                                          })),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
                                  //   child: Container(
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.blueGrey[900],
                                  //         borderRadius: BorderRadius.only(
                                  //           topLeft: Radius.circular(20),
                                  //           topRight: Radius.circular(20),
                                  //         ),
                                  //       ),
                                  //       height: 80,
                                  //       child: ListView.builder(
                                  //           itemCount: list.length,
                                  //           scrollDirection: Axis.horizontal,
                                  //           itemBuilder: (context, index) {
                                  //             return Row(
                                  //               children: <Widget>[
                                  //                 InkWell(
                                  //                   onTap: () {
                                  //                     setState(() {
                                  //                       tabindex = index;
                                  //                     });
                                  //                   },
                                  //                   child: Container(
                                  //                     margin: EdgeInsets.only(left: 10, top: 10),
                                  //                     decoration: BoxDecoration(
                                  //                       color: Colors.white,
                                  //                       borderRadius: BorderRadius.only(
                                  //                         topLeft: Radius.circular(20),
                                  //                         topRight: Radius.circular(20),
                                  //                       ),
                                  //                       border: Border.all(width: 0, color: Colors.white),
                                  //                     ),
                                  //                     width: 120,
                                  //                     height: 80,
                                  //                     child: Center(
                                  //                       child: Text(list[index],
                                  //                           textAlign: TextAlign.center,
                                  //                           style:
                                  //                               TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             );
                                  //           })),
                                  // ),
                                  // (tabindex == 0) ? securityTab() : Container(),
                                  // (tabindex == 1) ? reportTap() : Container(),
                                  // (tabindex == 2) ? notificationTab() : Container(),
                                  securityTab()
                                ],
                              )),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ButtonTheme(
                                  height: 70,
                                  minWidth: 150,
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
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ButtonTheme(
                                  height: 70,
                                  minWidth: 150,
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  securityTab() {
    List<Widget> widgets = List<Widget>.empty(growable: true);
    Map<String, bool>? temp = role!.getSecurityList();

    temp!.forEach((key, _value) {
      if (key.toString().startsWith('*')) return;

      if (searchController.text != null && searchController.text != "") {
        if (!key.toString().toLowerCase().contains(searchController.text.toLowerCase())) {
          return;
        }
      }

      widgets.add(Container(
          margin: EdgeInsets.only(left: 8, right: 8),
          padding: EdgeInsets.only(left: 5, right: 5),
          height: 50,
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Text(
                    key.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
              Expanded(
                child: Center(
                  child: CheckBox(
                    "",
                    isSelected: temp[key],
                    size: 40,
                    onTap: () {
                      setState(() {
                        temp[key] = !temp[key]!;
                      });
                    },
                  ),
                ),
              ),
            ],
          )));
    });

    //  {
    //
    // }

    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
              height: 55,
              child: Row(
                children: <Widget>[
                  Icon(Icons.search, size: 30),
                  Expanded(
                    child: TextField(
                        controller: searchController,
                        style: new TextStyle(fontSize: 20),
                        onChanged: (String v) {
                          setState(() {});
                        },
                        decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search'))),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
                color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      AppLocalizations.of(context)!.translate('This Employee Can Perform the Following:'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Access'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ],
      ),
    );
  }

  reportTap() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 0, color: Colors.white),
              left: BorderSide(width: 0, color: Colors.black),
              right: BorderSide(width: 0, color: Colors.black),
              bottom: BorderSide(width: 0, color: Colors.black))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
              height: 55,
              child: Row(
                children: <Widget>[
                  Icon(Icons.search, size: 30),
                  Expanded(
                    child: TextField(
                        style: new TextStyle(fontSize: 20),
                        decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search'))),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
                color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      AppLocalizations.of(context)!.translate('Name'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('Allow'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.translate('Deny'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center),
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales by Item"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(
                          child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.cancel,
                          size: 40,
                          color: Colors.red,
                        ),
                      )),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Employee"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: () {})),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Period"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Category"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Type"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Table"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Log Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Daily Closing Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Cashier History"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Treminal"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Table Group"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Cashier Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Menu"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Group"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Category By Item"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("MenuItem Vs MenuMdifier"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Service Vs Modifier"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Employee Attendence"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Employee Vs Item"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("PayOut Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Driver Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Purchase Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Account Balance"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Payment History"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Guest Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("CountDown List"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Item Movement"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("General Invenetory Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales Vs Usage"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Inventory Usage"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Payment Method Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Discount Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Surcharge Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Minimum charge Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Charge Per Hour Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Table Usage"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Void Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Tax Report"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Sales By Delivery Area"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                      Expanded(child: IconButton(icon: Icon(Icons.cancel, size: 40), onPressed: null)),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  notificationTab() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 0, color: Colors.white),
              left: BorderSide(width: 0, color: Colors.black),
              right: BorderSide(width: 0, color: Colors.black),
              bottom: BorderSide(width: 0, color: Colors.black))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
              height: 55,
              child: Row(
                children: <Widget>[
                  Icon(Icons.search, size: 30),
                  Expanded(
                    child: TextField(
                        style: new TextStyle(fontSize: 20),
                        decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search'))),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
                color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      AppLocalizations.of(context)!.translate('Name'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('No'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.translate('Instantly'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.translate('Daily'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center),
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Discount Notification"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(child: IconButton(icon: Icon(Icons.check_circle, size: 40, color: Colors.green), onPressed: () {})),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Void Notification"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: () {})),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Change Price Notification"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Cashier Report Notification"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Text(
                            AppLocalizations.of(context)!.translate("Closing Report Notification"),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                      Expanded(child: Text("")),
                      Expanded(
                          child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
