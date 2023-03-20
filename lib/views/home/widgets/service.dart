import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

class ServiceBtn extends StatefulWidget {
  final String? image;
  final String initName;
  final Stream<String> streamName;
  final Stream<int> streamInt;
  final Void2VoidFunc tab;
  const ServiceBtn({Key? key, this.image, required this.tab, required this.streamName, required this.initName, required this.streamInt})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ServiceBtnState();
  }
}

class _ServiceBtnState extends State<ServiceBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.tab,
      child: Container(
        // height: 350,
        // width: 280,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / (MediaQuery.of(context).orientation == Orientation.portrait ? 3.5 : 6),
              // height: 350,
              // width: 280,
              // width: MediaQuery.of(context).size.width / 2.5,
              margin: EdgeInsets.only(top: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Image.asset(
                    widget.image!,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.20,
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.all(Radius.circular(7))),
                    padding: EdgeInsets.all(5.0),
                    child: StreamBuilder(
                      stream: widget.streamName,
                      initialData: widget.initName,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return Text(
                          snapshot.data,
                          style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: StreamBuilder(
                  stream: widget.streamInt,
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == 0) {
                      return Center();
                    } else
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          //color: Colors.red,
                          color: Color(0xffff1234),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(width: 3, color: Colors.white),
                        ),
                        child: Center(
                            child: Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        )),
                      );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
