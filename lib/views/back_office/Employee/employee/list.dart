import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Employee_list_page/employee_list_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Employee_list_page/employee_list_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/employee_list.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import '../../../blocProvider.dart';
import 'form.dart';

class EmployeesListPage extends StatefulWidget {
  @override
  _EmployeesListPageState createState() => _EmployeesListPageState();
}

class _EmployeesListPageState extends State<EmployeesListPage> {
  EmployeeListPageBloc? employeeListBloc;
  void initState() {
    super.initState();

    employeeListBloc = new EmployeeListPageBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  void dispose() {
    super.dispose();
    employeeListBloc?.dispose();
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
            margin: EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                                employeeListBloc?.filterSearchResults(value);
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
                                  return EmployeeFormPage();
                                },
                              );
                              employeeListBloc?.eventSink!.add(LoadEmployee());
                            },
                          ),
                        ))
                    : Center(),
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
      margin: EdgeInsets.only(left: 10, right: 10),
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
                                    return EmployeeFormPage(id: 0);
                                  },
                                );
                                employeeListBloc?.eventSink!.add(LoadEmployee());
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
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EmployeeFormPage(id: employeeListBloc?.list!.value![_selectedIndex!].id);
                                  },
                                );
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
                                if (_selectedIndex != null) {
                                  if (employeeListBloc?.list!.value![_selectedIndex!].id == 1) return;
                                  employeeListBloc!.deleteEmployee(employeeListBloc!.list!.value![_selectedIndex!].id);
                                }
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
              Container(
                width: 150,
                child: Text(
                  AppLocalizations.of(context)!.translate('Role'),
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
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: StreamBuilder(
                stream: employeeListBloc?.list!.stream,
                initialData: employeeListBloc?.list!.value,
                builder: (context, snapshot) {
                  return employeeListBloc?.list!.value != null
                      ? ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemExtent: 60,
                          itemCount: employeeListBloc?.list!.value!.length,
                          itemBuilder: (context, index) {
                            EmployeeList? employee = employeeListBloc?.list!.value![index];
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
                                        employee!.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          (employee.role != null && employee.role != "") ? employee.role : "",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
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
        ),
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
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return EmployeeFormPage(id: employeeListBloc!.list!.value![index].id);
                      },
                    );
                    employeeListBloc!.eventSink!.add(LoadEmployee());
                    Navigator.pop(context);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Delete'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    if (employeeListBloc!.list!.value![index].id == 1) return;
                    employeeListBloc!.deleteEmployee(employeeListBloc!.list!.value![index].id);
                  },
                )
              ]));
    }
    _onSelected(index);
  }
}
