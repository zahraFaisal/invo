import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import 'package:invo_mobile/widgets/user_setting/userSetting.dart';

import '../../service_locator.dart';

class Header extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HeaderState();
  }
}

class _HeaderState extends State<Header> {
  late MainBloc mainBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = locator.get<MainBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.black45,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  "assets/icons/logo-2.png",
                  width: 120,
                  height: 70,
                ),
                SizedBox()
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                mainBloc.isINVOConnection.value!
                    ? StreamBuilder(
                        stream: mainBloc.connection.stream,
                        initialData: mainBloc.connection.value,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return Container(
                            margin: EdgeInsets.only(right: 20),
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
                      )
                    : Center(),
                StreamBuilder(
                  stream: mainBloc.employeeName.stream,
                  initialData: mainBloc.employeeName.value,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Text(
                      mainBloc.employeeName.value!,
                      style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                Container(margin: EdgeInsets.all(7.5), height: 40, width: 30, child: UserSetting()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
