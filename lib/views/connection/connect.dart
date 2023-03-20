import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/connect_page/connect_bloc.dart';
import 'package:invo_mobile/blocs/connect_page/connect_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/custom/database_list.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectPage extends StatefulWidget {
  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<ConnectPage> {
  displayInfo(BuildContext context, String title, String description) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget connectMethods(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
      Text(
        "Choose connecting method".toUpperCase(),
        style: const TextStyle(fontSize: 16.0),
      ),
      const SizedBox(height: 10.0),
      Container(
          height: 160.0,
          padding: const EdgeInsets.only(bottom: 2.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            color: Colors.grey[200],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(child: TextButton(onPressed: _invoConnect, child: const Image(image: AssetImage("assets/icons/logo.png"), width: 60.0, height: 80.0))),
                  Container(
                      padding: const EdgeInsets.all(5.0),
                      child: const Text(
                        "Invo POS Pro",
                        style: const TextStyle(fontSize: 16.0),
                      )),
                  TextButton(onPressed: () => displayInfo(context, "Invo Info", "connect to invopos system"), child: const Image(image: AssetImage("assets/icons/info.png"), width: 30.0, height: 30.0))
                ],
              ),
              Column(
                children: <Widget>[
                  Expanded(
                      child: TextButton(
                    onPressed: _databaseConnect,
                    child: const Image(image: AssetImage("assets/icons/database.png"), width: 60.0, height: 80.0),
                  )),
                  Container(
                      padding: const EdgeInsets.all(5.0),
                      child: const Text(
                        "Local Data",
                        style: const TextStyle(fontSize: 16.0),
                      )),
                  TextButton(onPressed: () => displayInfo(context, "Database Info", "Create your own local database on this device"), child: const Image(image: AssetImage("assets/icons/info.png"), width: 30.0, height: 30.0))
                ],
              ),
              Column(
                children: <Widget>[
                  Expanded(
                      child: TextButton(
                          onPressed: () async {
                            //restore
                            await loadList();
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                  content: Container(height: MediaQuery.of(context).size.height / 2, child: dbPicker(context)),
                                );
                              },
                            );
                          },
                          child: const Image(image: const AssetImage("assets/icons/setting.png"), width: 60.0, height: 80.0))),
                  Container(
                      padding: const EdgeInsets.all(5.0),
                      child: const Text(
                        "Restore Database",
                        style: const TextStyle(fontSize: 16.0),
                      )),
                  TextButton(onPressed: () => displayInfo(context, "Restore", "Restore your Database from your google drive"), child: const Image(image: AssetImage("assets/icons/info.png"), width: 30.0, height: 30.0))
                ],
              ),
              /* Column(
                    children: <Widget>[
                      Expanded(
                          child: FlatButton(
                              onPressed: demoConnect,
                              child: Image(
                                  image: AssetImage("assets/icons/demo.png"),
                                  width: 60.0,
                                  height: 80.0))),
                      Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            "Demo",
                            style: TextStyle(fontSize: 16.0),
                          )),
                      FlatButton(
                          onPressed: () => displayInfo(context, "Demo Info",
                              "check the app for 30 days"),
                          child: Image(
                              image: AssetImage("assets/icons/info.png"),
                              width: 30.0,
                              height: 30.0))
                    ],
                  ), */
            ],
          ))
    ]);
  }

  late ConnectBloc connectBloc;
  late SqliteRepository sqliteRepository;
  late DatabaseList selectedDb;
  Property<List<DatabaseList>> databases = Property<List<DatabaseList>>();
  @override
  void initState() {
    super.initState();
    checkDefaultConnection();
    connectBloc = ConnectBloc(BlocProvider.of<NavigatorBloc>(context));
    sqliteRepository = SqliteRepository();
  }

  loadList() async {
    databases.value = await sqliteRepository.listDB();
  }

  checkDefaultConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("connectionType") ?? "";
    if (type == "INVO") {
      connectBloc.eventSink.add(ConnectToInvoPos());
    } else if (type == "SQLLITE") {
      connectBloc.eventSink.add(ConnectToDatabase());
    }
  }

  void dispose() {
    super.dispose();
    connectBloc.dispose();
    databases.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Image(image: const AssetImage("assets/icons/logo.png"), width: 200.0, height: 200.0),
            Center(child: connectMethods(context)),
          ],
        ),
      ),
    );
  }

  void _invoConnect() {
    connectBloc.eventSink.add(ConnectToInvoPos());
  }

  void _databaseConnect() {
    connectBloc.eventSink.add(ConnectToDatabase());
  }

  void _restartApp() {
    connectBloc.eventSink.add(Restart());
  }

  void demoConnect() {
    connectBloc.eventSink.add(ConnectToDemoDatabase());
  }

  Widget dbPicker(BuildContext context) {
    return StreamBuilder(
        stream: databases.stream,
        builder: (context, snapshot) {
          if (databases.value == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return StatefulBuilder(builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Database Restore",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Choose a Database",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: DropdownButton(
                                hint: const Text("Select Database"),
                                isExpanded: true,
                                value: selectedDb,
                                onChanged: (value) {
                                  snapshot(() {
                                    selectedDb = value as DatabaseList;
                                  });
                                },
                                items: databases.value!.map((db) {
                                  return DropdownMenuItem(
                                    value: db,
                                    onTap: () {
                                      snapshot(() {
                                        selectedDb = db;
                                      });
                                    },
                                    child: Text(
                                      db.name,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: PrimaryButton(
                              text: "Cancel",
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: PrimaryButton(
                              text: "Restore",
                              onTap: () async {
                                if (await sqliteRepository.restoreDB(selectedDb)) {
                                  Navigator.of(context).pop();
                                  _restartApp();
                                  _databaseConnect();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            });
        });
  }
}
