import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';
import 'package:invo_mobile/widgets/user_setting/userSetting.dart';

import '../../service_locator.dart';

class HeaderLandscape extends StatefulWidget {
  final double? height;

  const HeaderLandscape({Key? key, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HeaderLandscapeState();
  }
}

class _HeaderLandscapeState extends State<HeaderLandscape> {
  late MainBloc mainBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = locator.get<MainBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.black45,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  // logo
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Image.asset(
                    "assets/icons/logo-2.png",
                    width: 100,
                    height: 50,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                    stream: mainBloc.currentDate.stream,
                    initialData: mainBloc.currentDate.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Text(
                        // time and date
                        DateFormat('h:mm a EEEE  MMM M').format(mainBloc.currentDate.value!),
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 10),
                //   child: Icon(
                //     Icons.info,
                //     color: Colors.white,
                //     size: 27,
                //   ),
                // )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                mainBloc.isINVOConnection.value!
                    ? StreamBuilder(
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
                      )
                    : Center(),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: StreamBuilder(
                    stream: mainBloc.employeeName.stream,
                    initialData: mainBloc.employeeName.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Text(
                        mainBloc.employeeName.value!,
                        style: TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),

                Container(margin: EdgeInsets.all(9.5), height: 40, width: 40, child: UserSetting())
                // FlatButton(
                //   onPressed: null,
                //   child: Image.asset(
                //     "assets/icons/profile_icon.png",
                //     height: 40,
                //     width: 40,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
