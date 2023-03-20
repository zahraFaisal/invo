import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invo_mobile/blocs/invo_connection/invo_connection_bloc.dart';
import 'package:invo_mobile/blocs/invo_connection/invo_connection_events.dart';
import 'package:invo_mobile/blocs/invo_connection/invo_connection_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/views/home/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoConnectionPage extends StatefulWidget {
  final String? ip;
  InvoConnectionPage(this.ip);
  @override
  _InvoConnectionState createState() => new _InvoConnectionState();
}

class _InvoConnectionState extends State<InvoConnectionPage> {
  late InvoConnectionBloc invoConnectionBloc;
  int focusedTextField = 0;
  TextEditingController firstCtr = TextEditingController();
  TextEditingController secondCtr = TextEditingController();
  TextEditingController thirdCtr = TextEditingController();
  TextEditingController fourthCtr = TextEditingController();

  setDeviceOrientations(BuildContext context) {
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    var width = MediaQuery.of(context).size.width * devicePixelRatio;
    var height = MediaQuery.of(context).size.height * devicePixelRatio;
    Orientation orientation = MediaQuery.of(context).orientation;

    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool mobileLayout = shortestSide < 500;

    SystemChrome.setEnabledSystemUIOverlays([]);

    if (mobileLayout) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      if (shortestSide <= 800) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
        ]);
    }
  }

  Widget ipField(BuildContext context) {
    FocusNode secondPart = new FocusNode();
    FocusNode thirdPart = new FocusNode();
    FocusNode fourthPart = new FocusNode();

    // return BlocBuilder<InvoConnectEvent, InvoConnectionState>(
    //   bloc: invoConnectionBloc,
    //   builder: (
    //     BuildContext context,
    //     InvoConnectionState state,
    //   ) {

    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
      Text(
        "Enter IP Address".toUpperCase(),
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      Container(
          margin: EdgeInsets.all(30.0),
          width: 600,
          padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.grey[200],
          ),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Colors.white),
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: TextField(
                            controller: firstCtr,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (newValue) {
                              newValue = newValue.trim();

                              if (newValue.contains(".")) {
                                print("dot clicked");
                                newValue = newValue.substring(0, newValue.length - 1);
                                firstCtr.text = newValue;
                                FocusScope.of(context).requestFocus(secondPart);
                                return;
                              }

                              if (int.parse(newValue) > 255) {
                                firstCtr.text = "255";
                              }

                              if (newValue.length == 3) {
                                FocusScope.of(context).requestFocus(secondPart);
                              } else if (newValue.length > 3) {
                                newValue = newValue.substring(0, newValue.length - 1);
                                firstCtr.text = newValue;
                                FocusScope.of(context).requestFocus(secondPart);
                              }
                            },
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(secondPart);
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ))),
                  Text("."),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Colors.white),
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: TextField(
                            controller: secondCtr,
                            focusNode: secondPart,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (newValue) {
                              newValue = newValue.trim();
                              if (newValue.contains(".")) {
                                newValue = newValue.substring(0, newValue.length - 1);
                                secondCtr.text = newValue;
                                FocusScope.of(context).requestFocus(thirdPart);
                                return;
                              }

                              if (int.parse(newValue) > 255) {
                                secondCtr.text = "255";
                              }

                              if (newValue.length == 3) {
                                FocusScope.of(context).requestFocus(thirdPart);
                              } else if (newValue.length > 3) {
                                newValue = newValue.substring(0, newValue.length - 1);
                                secondCtr.text = newValue;
                                FocusScope.of(context).requestFocus(thirdPart);
                              }
                            },
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(thirdPart);
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ))),
                  Text("."),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Colors.white),
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: TextField(
                            focusNode: thirdPart,
                            controller: thirdCtr,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (newValue) {
                              newValue = newValue.trim();
                              if (newValue.contains(".")) {
                                newValue = newValue.substring(0, newValue.length - 1);
                                thirdCtr.text = newValue;
                                FocusScope.of(context).requestFocus(fourthPart);
                                return;
                              }

                              if (int.parse(newValue) > 255) {
                                thirdCtr.text = "255";
                              }
                              if (newValue.contains(".")) {
                                newValue = newValue.substring(0, newValue.length - 1);
                                thirdCtr.text = newValue;
                                FocusScope.of(context).requestFocus(fourthPart);
                                return;
                              }
                              if (newValue.length == 3) {
                                FocusScope.of(context).requestFocus(fourthPart);
                              } else if (newValue.length > 3) {
                                newValue = newValue.substring(0, newValue.length - 1);
                                thirdCtr.text = newValue;
                                FocusScope.of(context).requestFocus(fourthPart);
                              }
                            },
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(fourthPart);
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ))),
                  Text("."),
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Colors.white),
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: TextField(
                            controller: fourthCtr,
                            focusNode: fourthPart,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (newValue) {
                              newValue = newValue.trim();
                              if (newValue.contains(".")) {
                                newValue = newValue.substring(0, newValue.length - 1);
                                fourthCtr.text = newValue;
                                //_connectButtonPressed();
                                return;
                              }

                              if (int.parse(newValue) > 255) {
                                fourthCtr.text = "255";
                              }

                              if (newValue.length == 3) {
                                //_connectButtonPressed();
                              }
                            },
                            onSubmitted: (value) {
                              _connectButtonPressed();
                            },
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ))),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //     child: Text("BACK"),
                  //     onPressed: () async {
                  //       SharedPreferences prefs = await SharedPreferences.getInstance();
                  //       prefs.setString("connectionType", "");
                  //       // prefs.setString("Invo_IP", null);
                  //       prefs.setString("Invo_IP", "");

                  //       invoConnectionBloc.invoConnectionEventSink.add(ConnectionGoBack());
                  //     }),
                  // SizedBox(
                  //   width: 22,
                  // ),
                  ElevatedButton(
                      child: Text("CONNECT"),
                      onPressed: () {
                        invoConnectionBloc.invoConnectionEventSink.add(ConnectButtonPressed(part1: firstCtr.text, part2: secondCtr.text, part3: thirdCtr.text, part4: fourthCtr.text));
                        // invoConnectionBloc.invoConnectionEventSink.add(
                        //     ConnectButtonPressed(
                        //         part1: firstCtr.text,
                        //         part2: secondCtr.text,
                        //         part3: thirdCtr.text,
                        //         part4: fourthCtr.text));
                      }),
                ],
              )
            ],
          ))
    ]);

    //   },
    // );
  }

  @override
  void initState() {
    invoConnectionBloc = new InvoConnectionBloc(BlocProvider.of<NavigatorBloc>(context));

    super.initState();
    getIP();
  }

  getIP() async {
    String? ip = widget.ip;

    if (widget.ip == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ip = prefs.getString("Invo_IP");
    }
    if (ip != null) {
      List<String> parts = ip.split('.');
      if (parts.length == 4) {
        firstCtr.text = parts[0];
        secondCtr.text = parts[1];
        thirdCtr.text = parts[2];
        fourthCtr.text = parts[3];

        invoConnectionBloc.invoConnectionEventSink.add(ConnectButtonPressed(part1: firstCtr.text, part2: secondCtr.text, part3: thirdCtr.text, part4: fourthCtr.text));
      }
    }
  }

  @override
  void dispose() {
    //invoConnectionBloc.;
    super.dispose();
    invoConnectionBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setDeviceOrientations(context);

    double viewBottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          invoConnectionBloc.invoConnectionEventSink.add(ConnectionGoBack());
          return Future.value(false);
        },
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: StreamBuilder(
            stream: invoConnectionBloc.currentStateStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget x;
              if (snapshot.data is IsLoading) {
                x = Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    (snapshot.data as IsLoading).progress != null
                        ? Text(
                            (snapshot.data as IsLoading).progress.toString() + "%",
                            style: TextStyle(fontSize: 25),
                          )
                        : Text("")
                  ],
                );
              } else if (snapshot.data is ConnectionError) {
                x = Column(
                  children: <Widget>[
                    ipField(context),
                    Text(
                      (snapshot.data as ConnectionError).error,
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                );
              } else {
                x = ipField(context);
              }

              Widget bottom = Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[Image(image: AssetImage("/assets/icons/powerdby.png"), width: 100.0, height: 50.0, fit: BoxFit.cover)],
              ));

              // if (viewBottom > 0) {
              //   bottom = SizedBox(
              //     height: 0,
              //   );
              // }

              return Column(children: [
                Expanded(flex: 2, child: Image(image: AssetImage("assets/icons/logo.png"), width: 200.0, height: 200.0)),
                Expanded(flex: 4, child: Center(child: x)),
              ]);
            },
          ),
        ),
      ),
    );

    // return BlocProvider<InvoConnectionBloc>(
    //   builder: (BuildContext context) => invoConnectionBloc,
    //   child: BlocListener(
    //     bloc: invoConnectionBloc,
    //     listener: (BuildContext context, InvoConnectionState state) async {

    //       if (state is ConnectComplete) {
    //         SharedPreferences prefs = await SharedPreferences.getInstance();
    //         prefs.setString("Invo_IP", state.ip);

    //         Navigator.of(context)
    //             .push(MaterialPageRoute(builder: (context) => HomePage()));
    //       }

    //     },
    //     child:

    // new Scaffold(
    //       body: Container(
    //         margin: const EdgeInsets.all(10.0),
    //         child: BlocBuilder<InvoConnectEvent, InvoConnectionState>(
    //           bloc: invoConnectionBloc,
    //           condition: (prevState, currentState) {
    //             if (currentState is ConnectButtonPressed) {
    //               return false;
    //             }
    //             return true;
    //           },
    //           builder: (BuildContext context, InvoConnectionState state) {
    //             Widget x = CircularProgressIndicator();

    //             if (state is! ConnectLoading) {
    //               x = ipField(context);
    //             }

    //             Widget bottom = Expanded(
    //                 child: Column(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: <Widget>[
    //                 Image(
    //                     image: AssetImage("assets/powerdby.png"),
    //                     width: 100.0,
    //                     height: 50.0,
    //                     fit: BoxFit.cover)
    //               ],
    //             ));

    //             if (viewBottom > 0) {
    //               bottom = SizedBox(
    //                 height: 0,
    //               );
    //             }

    //             return Column(children: [
    //               Expanded(
    //                   flex: 2,
    //                   child: Image(
    //                       image: AssetImage("assets/logo.png"),
    //                       width: 200.0,
    //                       height: 200.0)),
    //               Expanded(flex: 4, child: Center(child: x)),
    //               bottom
    //             ]);
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  _connectButtonPressed() {
    invoConnectionBloc.invoConnectionEventSink.add(ConnectButtonPressed(part1: firstCtr.text, part2: secondCtr.text, part3: thirdCtr.text, part4: fourthCtr.text));
  }
}
