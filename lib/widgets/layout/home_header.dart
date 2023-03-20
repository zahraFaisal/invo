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

class HomeHeader extends StatefulWidget {
  HomeHeader({Key? key}) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late MainBloc mainBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = locator.get<MainBloc>();
    mainBloc.updateConnection();
    mainBloc.getLogo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Column(
            children: [
              // Center(
              //   child: Container(
              //     padding: EdgeInsets.only(top: 0.5),
              //     child: StreamBuilder(
              //       stream: mainBloc.currentDate.stream,
              //       initialData: mainBloc.currentDate.value,
              //       builder: (BuildContext context, AsyncSnapshot snapshot) {
              //         return Text(
              //           // time and date
              //           DateFormat('h:mm a EEEE  MMM d')
              //               .format(mainBloc.currentDate.value),
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              Stack(children: [
                Container(
                  color: Colors.black54,
                  height: 80,
                  margin: const EdgeInsets.only(
                    top: 35,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            // Power Button
                            margin: const EdgeInsets.all(7.5),
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
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 0.5),
                                child: StreamBuilder(
                                  stream: mainBloc.currentDate.stream,
                                  initialData: mainBloc.currentDate.value,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    return Text(
                                      // time and date
                                      DateFormat('EEEE  MMM d').format(mainBloc.currentDate.value!),
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 0.5),
                                child: StreamBuilder(
                                  stream: mainBloc.currentDate.stream,
                                  initialData: mainBloc.currentDate.value,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    return Text(
                                      // time and date
                                      DateFormat('h:mm a').format(mainBloc.currentDate.value!),
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                            ],
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
                                        margin: const EdgeInsets.only(right: 20),
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
                                                style: const TextStyle(
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
                                        margin: const EdgeInsets.only(right: 30),
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
                                                style: const TextStyle(
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
                                return const SizedBox();
                              }
                            },
                          ),
                          StreamBuilder(
                            stream: mainBloc.employeeName.stream,
                            initialData: mainBloc.employeeName.value,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return Text(
                                mainBloc.employeeName.value!,
                                style: const TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          Container(margin: const EdgeInsets.all(7.5), child: UserSetting()),
                        ],
                      ),
                    ],
                  ),
                ),
                mainBloc.logo_.value!.isNotEmpty
                    ? Center(
                        child: StreamBuilder(
                            stream: mainBloc.logo_.stream,
                            initialData: mainBloc.logo_.value,
                            builder: (context, snapshot) {
                              return Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                                child: Image.memory(mainBloc.logo_.value!, fit: BoxFit.cover),
                              );
                            }),
                      )
                    : Container(),
              ])
            ],
          );
        });
  }
}
