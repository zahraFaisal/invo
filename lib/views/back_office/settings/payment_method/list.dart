import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/settings/payment_method_list_page/payment_method_list_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/payment_method_list_page/payment_method_list_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/payment_method_list.dart';
import 'package:invo_mobile/views/back_office/settings/payment_method/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class PaymentMethodListPage extends StatefulWidget {
  const PaymentMethodListPage({Key? key}) : super(key: key);

  @override
  _PaymentMethodListState createState() => _PaymentMethodListState();
}

class _PaymentMethodListState extends State<PaymentMethodListPage> {
  late PaymentMethodListBloc paymentMethodListBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    paymentMethodListBloc = new PaymentMethodListBloc(BlocProvider.of<NavigatorBloc>(context));
    paymentMethodListBloc.loadList();
  }

  @override
  void dispose() {
    super.dispose();
    paymentMethodListBloc.dispose();
  }

  int? _selectedIndex;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search, size: 30),
                        Expanded(
                          child: searchField(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                orientation == Orientation.portrait
                    ? Container(
                        width: 100,
                        child: ButtonTheme(
                          height: 55,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ))),
                            child: Text(
                              AppLocalizations.of(context)!.translate('ADD'),
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PaymentMethodForm();
                                },
                              );
                              paymentMethodListBloc.eventSink.add(LoadPaymentMethod());
                            },
                          ),
                        ))
                    : Center(),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: orientation == Orientation.portrait ? portrait() : landscape(),
          )
        ],
      ),
    );
  }

  Widget portrait() {
    return Container(
      margin: EdgeInsets.only(left: 4, right: 8),
      child: list(),
    );
  }

  Widget landscape() {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: list(),
              ),
              SizedBox(width: 10),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: ButtonTheme(
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('ADD'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PaymentMethodForm();
                                  },
                                );
                                paymentMethodListBloc.eventSink.add(LoadPaymentMethod());
                              },
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 100,
                          child: ButtonTheme(
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Edit'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PaymentMethodForm(
                                      id: paymentMethodListBloc.list.value![_selectedIndex!].id,
                                    );
                                    // return AddPaymentMethod(id: id);
                                  },
                                );
                                paymentMethodListBloc.eventSink.add(LoadPaymentMethod());
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget list() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Name'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Symbol'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: StreamBuilder(
                stream: paymentMethodListBloc.list.stream,
                initialData: paymentMethodListBloc.list.value,
                builder: (context, snapshot) {
                  return paymentMethodListBloc.list.value != null
                      ? ListView.builder(
                          itemExtent: 60,
                          padding: EdgeInsets.all(0),
                          itemCount: paymentMethodListBloc.list.value!.length,
                          itemBuilder: (context, index) {
                            PaymentMethodList method = paymentMethodListBloc.list.value![index];
                            return Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                color: (_selectedIndex != null && _selectedIndex == index) ? Colors.orange[200] : Colors.white,
                              ),
                              child: ListTile(
                                onTap: () {
                                  listItemTapped(index);
                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: AutoSizeText(
                                        (method.name == null) ? "" : method.name,
                                        style: TextStyle(
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      child: Center(
                                        child: Text(
                                          (method.symbol == null) ? "" : method.symbol,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ),
        )
      ],
    );
  }

  Widget searchField() {
    return TextField(
        onChanged: (value) {
          paymentMethodListBloc.filterSearchResults(value);
        },
        style: new TextStyle(fontSize: 20),
        decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search')));
  }

  void listItemTapped(int index) {
    if (orientation == Orientation.portrait) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) =>
              CupertinoActionSheet(title: Text(AppLocalizations.of(context)!.translate('Select an action')), actions: <Widget>[
                CupertinoActionSheetAction(
                    child: Text(AppLocalizations.of(context)!.translate('Edit')),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PaymentMethodForm(id: paymentMethodListBloc.list.value![index].id);
                        },
                      );

                      paymentMethodListBloc.eventSink.add(LoadPaymentMethod());
                      Navigator.of(context).pop();
                    }),
              ]));
    }
    _onSelected(index);
  }
}
