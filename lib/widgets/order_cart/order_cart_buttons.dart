import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_state.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class OrderCartButtons extends StatefulWidget {
  final OrderPageBloc orderPageBloc;
  OrderCartButtons(this.orderPageBloc);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderCartButtonsState();
  }
}

class _OrderCartButtonsState extends State<OrderCartButtons> {
  double buttonsPaddding = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          // first row include 2 buttons
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.all(buttonsPaddding),
            //     child: SizedBox(
            //       height: 50,
            //       child: PrimaryButton(
            //         text: AppLocalizations.of(context)!.translate("Exact Cash"),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(buttonsPaddding),
                  child: SizedBox(
                    height: 50,
                    child: PrimaryButton(
                      onTap: () {
                        widget.orderPageBloc.eventSink.add(SaveOrder());
                      },
                      text: AppLocalizations.of(context)!.translate("Save & Send"),
                    ),
                  )),
            )
          ],
        ),
        Row(
          // second row include 4 buttons
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //           Expanded(
            //             child: Padding(
            //               padding: EdgeInsets.all(buttonsPaddding),
            //               child: InkWell(
            //                 onTap: (){
            //                   Navigator.of(context).pop() ;
            //                 },
            //                 child:                Container(
            //   height: 50,
            //         color: Colors.transparent,
            //         child:  Container(
            //             decoration:  BoxDecoration(
            //                 color: Theme.of(context).primaryColor ,
            //                  borderRadius:  BorderRadius.all(Radius.circular(5))),

            //             child:  Center(
            //               child: Image.asset("assets/icons/x.png" , height: 30 , width: 30 ,),
            //             )),
            //       ),
            //               ),

            // //               Container(
            // // // decoration: new BoxDecoration(
            // // //                       color: Colors.blue,
            // // //                       borderRadius: new BorderRadius.only(
            // // //                           topLeft:  const  Radius.circular(40.0),
            // // //                           topRight: const  Radius.circular(40.0))
            // // //                   ),
            // //                 color: Theme.of(context).primaryColor,

            // //                 child: Image.asset("assets/icons/x.png" , height: 30 , width: 30 ,)
            // //                 //  PrimaryButton(
            // //                 //   text: AppLocalizations.of(context)!.translate("Cancel"),
            // //                 //   onTap: () {
            // //                 //     Navigator.of(context).pop();
            // //                 //   },
            // //                 // ),
            // //               ),
            //             ),
            //           ),

            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(buttonsPaddding),
                  child: SizedBox(
                    height: 50,
                    child: PrimaryButton(
                      text: AppLocalizations.of(context)!.translate("Cancel"),
                      onTap: () {
                        widget.orderPageBloc.eventSink.add(GoBack());
                      },
                    ),
                  )),
            ),

            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(buttonsPaddding),
                  child: SizedBox(
                    height: 50,
                    child: PrimaryButton(
                      onTap: () {
                        widget.orderPageBloc.option.sinkValue(OrderPageOption());
                      },
                      text: AppLocalizations.of(context)!.translate("Options"),
                    ),
                  )),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(buttonsPaddding),
                  child: SizedBox(
                    height: 50,
                    child: PrimaryButton(
                      onTap: () {
                        widget.orderPageBloc.eventSink.add(SaveAndPrintOrder());
                      },
                      text: AppLocalizations.of(context)!.translate("Print"),
                    ),
                  )),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(buttonsPaddding),
                child: SizedBox(
                  height: 50,
                  child: PrimaryButton(
                    onTap: () {
                      widget.orderPageBloc.eventSink.add(PayOrder());
                    },
                    text: AppLocalizations.of(context)!.translate("Pay"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
