import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Role_list_page/Role_list_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Role_list_page/Role_list_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/views/back_office/Employee/role/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class RolesListPage extends StatefulWidget {
  @override
  _RolesListPageState createState() => _RolesListPageState();
}

class _RolesListPageState extends State<RolesListPage> {
  late RoleListPageBloc roleListBloc;
  void initState() {
    super.initState();
    roleListBloc = RoleListPageBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  void dispose() {
    super.dispose();
    roleListBloc.dispose();
  }

  int? _selectedIndex;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search, size: 30),
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                roleListBloc.filterSearchResults(value);
                              },
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search'))),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                orientation == Orientation.portrait
                    ? Container(
                        width: 100,
                        child: ButtonTheme(
                          height: 55,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                            child: Text(
                              AppLocalizations.of(context)!.translate('ADD'),
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RoleForm();
                                },
                              );
                              roleListBloc.eventSink!.add(LoadRole());
                            },
                          ),
                        ))
                    : Center(),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: orientation == Orientation.portrait ? portrait() : landscape(),
          )
        ],
      ),
    );
  }

  Widget portrait() {
    return Container(
      margin: EdgeInsets.only(left: 4, right: 8),
      child: list(),
    );
  }

  Widget landscape() {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: list(),
              ),
              SizedBox(width: 10),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: ButtonTheme(
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('ADD'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RoleForm();
                                  },
                                );
                                roleListBloc.eventSink!.add(LoadRole());
                              },
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 100,
                          child: ButtonTheme(
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Edit'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                if (roleListBloc.list!.value![_selectedIndex!].id == 1) return;
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RoleForm(id: roleListBloc.list!.value![_selectedIndex!].id);
                                  },
                                );
                                roleListBloc.eventSink!.add(LoadRole());
                              },
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 100,
                          child: ButtonTheme(
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Delete'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                if (roleListBloc.list!.value![_selectedIndex!].id == 1) return;
                                roleListBloc.deleteRole(roleListBloc.list!.value![_selectedIndex!].id);
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget list() {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Name'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: StreamBuilder(
                stream: roleListBloc.list!.stream,
                initialData: roleListBloc.list!.value,
                builder: (context, snapshot) {
                  return roleListBloc.list!.value != null
                      ? ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemExtent: 60,
                          itemCount: roleListBloc.list!.value!.length,
                          itemBuilder: (context, index) {
                            RoleList role = roleListBloc.list!.value![index];
                            return Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                color: (_selectedIndex != null && _selectedIndex == index) ? Colors.orange[200] : Colors.white,
                              ),
                              child: ListTile(
                                onTap: () {
                                  listItemTapped(index);
                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        role.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ),
        )
      ],
    );
  }

  void listItemTapped(int index) {
    if (orientation == Orientation.portrait) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) =>
              CupertinoActionSheet(title: Text(AppLocalizations.of(context)!.translate('Select an action')), actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context)!.translate('Edit')),
                  onPressed: () async {
                    if (roleListBloc.list!.value![index].id == 1) return;
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RoleForm(id: roleListBloc.list!.value![index].id);
                      },
                    );
                    roleListBloc.eventSink!.add(LoadRole());
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Delete'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    if (roleListBloc.list!.value![index].id == 1) return;
                    roleListBloc.deleteRole(roleListBloc.list!.value![index].id);
                  },
                )
              ]));
    }
    _onSelected(index);
  }
}
