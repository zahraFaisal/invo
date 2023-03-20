import 'package:flutter/material.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';

typedef Discount2VoidFunc = void Function(Discount);

class DiscountList extends StatefulWidget {
  final List<Discount> discounts;
  final Discount2VoidFunc onDiscountClick;
  final Void2VoidFunc onCancel;
  DiscountList({Key? key, required this.discounts, required this.onDiscountClick, required this.onCancel}) : super(key: key);

  @override
  _DiscountListState createState() => _DiscountListState();
}

class _DiscountListState extends State<DiscountList> {
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
                "Select Discount",
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
                itemCount: widget.discounts.length,
                itemBuilder: (context, index) {
                  return PrimaryButton(
                      onTap: () {
                        if (widget.onDiscountClick != null) widget.onDiscountClick(widget.discounts[index]);
                      },
                      text: widget.discounts[index].name);
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
