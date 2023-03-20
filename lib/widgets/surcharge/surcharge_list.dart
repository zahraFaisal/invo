import 'package:flutter/material.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

typedef Surcharge2VoidFunc = void Function(Surcharge);

class SurchargeList extends StatefulWidget {
  final List<Surcharge> surcharges;
  final Surcharge2VoidFunc? onSurchargeClick;
  final Void2VoidFunc? onCancel;
  SurchargeList({Key? key, required this.surcharges, this.onSurchargeClick, this.onCancel}) : super(key: key);

  @override
  _SurchargeListState createState() => _SurchargeListState();
}

class _SurchargeListState extends State<SurchargeList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                "Select Surcharge",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: GridView.builder(
                padding: EdgeInsets.all(3.5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 7,
                  crossAxisCount: MediaQuery.of(context).size.shortestSide < 500 ? 2 : 4,
                  childAspectRatio: 1.5,
                ),
                scrollDirection: Axis.vertical,
                itemCount: widget.surcharges.length,
                itemBuilder: (context, index) {
                  return PrimaryButton(
                      onTap: () {
                        if (widget.onSurchargeClick != null) widget.onSurchargeClick!(widget.surcharges[index]);
                      },
                      text: widget.surcharges[index].name);
                },
              )),
          Container(
            height: 100,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    height: 70,
                    width: 200,
                    child: PrimaryButton(
                      text: "Cancel",
                      onTap: widget.onCancel,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
