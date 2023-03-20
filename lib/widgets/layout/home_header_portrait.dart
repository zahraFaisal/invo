import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import 'package:invo_mobile/blocs/main/main_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/sqlLite/sqlite_repository.dart';
import 'package:invo_mobile/services/InvoCloud/webSocket_IO.dart';
import 'package:invo_mobile/widgets/user_setting/userSetting.dart';

import '../../service_locator.dart';

class HomeHeaderPortrait extends StatefulWidget {
  HomeHeaderPortrait({Key? key}) : super(key: key);

  @override
  State<HomeHeaderPortrait> createState() => _HomeHeaderPortraitState();
}

class _HomeHeaderPortraitState extends State<HomeHeaderPortrait> {
  late MainBloc mainBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = locator.get<MainBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.only(top: 0.5),
            child: StreamBuilder(
              stream: mainBloc.currentDate.stream,
              initialData: mainBloc.currentDate.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Text(
                  // time and date
                  DateFormat('h:mm a EEEE  MMM d').format(mainBloc.currentDate.value!),
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
        Container(
          color: Colors.black54,
          height: 80,
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    // Power Button
                    margin: EdgeInsets.all(7.5),
                    child: StreamBuilder(
                        stream: mainBloc.isINVOConnection.stream,
                        initialData: mainBloc.isINVOConnection.value,
                        builder: (context, snapshot) {
                          return InkWell(
                            onTap: () async {
                              // printerManager.startScan(Duration(minutes: 1));

                              mainBloc.eventSink.add(PowerOff());
                            },
                            child: Image.asset("assets/icons/Power.png"),
                          );
                        }),
                  ),
                ],
              ),
              Row(
                // user Profile
                children: <Widget>[
                  StreamBuilder(
                    stream: mainBloc.isINVOConnection.stream,
                    initialData: mainBloc.isINVOConnection.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (mainBloc.isINVOConnection.value != null) {
                        if (mainBloc.isINVOConnection.value == false)
                          // return Center();
                          return StreamBuilder(
                            stream: mainBloc.webSocketIO!.online.stream,
                            initialData: mainBloc.webSocketIO!.online.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Container(
                                margin: EdgeInsets.only(right: 20),
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: (mainBloc.webSocketIO!.online.value!) ? Colors.green : Colors.red,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                  child: StreamBuilder(
                                    stream: mainBloc.pendingOrderQtyStream,
                                    initialData: 0,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return Text(
                                        snapshot.data.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        else
                          return StreamBuilder(
                            stream: mainBloc.connection.stream,
                            initialData: mainBloc.connection.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Container(
                                margin: EdgeInsets.only(right: 30),
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: (mainBloc.connection.value!) ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                  child: StreamBuilder(
                                    stream: mainBloc.queueNumber.stream,
                                    initialData: mainBloc.queueNumber.value,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return Text(
                                        mainBloc.queueNumber.value.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: mainBloc.employeeName.stream,
                    initialData: mainBloc.employeeName.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Text(
                        mainBloc.employeeName.value!,
                        style: TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  Container(margin: EdgeInsets.all(7.5), child: UserSetting()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
