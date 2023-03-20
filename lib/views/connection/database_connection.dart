import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/database_connection/database_connection_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/views/blocProvider.dart';

import '../../service_locator.dart';

class DataBaseConnection extends StatefulWidget {
  DataBaseConnection({Key? key}) : super(key: key);

  @override
  _DataBaseConnectionState createState() => _DataBaseConnectionState();
}

class _DataBaseConnectionState extends State<DataBaseConnection> {
  late DatabaseConnectionBloc databaseConnectionBloc;

  @override
  void initState() {
    super.initState();
    databaseConnectionBloc = new DatabaseConnectionBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  void dispose() {
    super.dispose();
    databaseConnectionBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(image: AssetImage("assets/icons/logo.png"), width: 200.0, height: 200.0),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
