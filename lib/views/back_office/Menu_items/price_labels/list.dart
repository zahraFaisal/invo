import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/PricesList/prices_list_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/views/back_office/Menu_items/price_labels/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import '../../../blocProvider.dart';
import 'package:invo_mobile/blocs/back_office/Menu/pricesList/prices_list_bloc.dart';

class PriceLabelListPage extends StatefulWidget {
  PriceLabelListPage({Key? key}) : super(key: key);

  @override
  _PriceLabelListPageState createState() => _PriceLabelListPageState();
}

class _PriceLabelListPageState extends State<PriceLabelListPage> {
  late PriceListBloc priceListBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    priceListBloc = PriceListBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  void dispose() {
    super.dispose();
    priceListBloc.dispose();
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
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    height: 55,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search, size: 30),
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                priceListBloc.filterSearchResults(value);
                              },
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search'))),
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
                                  return PriceLabelForm();
                                },
                              );
                              priceListBloc.eventSink.add(LoadPrice());
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
      margin: EdgeInsets.only(left: 10, right: 10),
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
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
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
                                    return PriceLabelForm();
                                  },
                                );
                                priceListBloc.eventSink.add(LoadPrice());
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
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Edit'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_selectedIndex! > -1) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PriceLabelForm(id: priceListBloc.list.value![_selectedIndex!].id!);
                                    },
                                  );
                                  priceListBloc.eventSink.add(LoadPrice());
                                }
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
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Copy'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PriceLabelForm(id: priceListBloc.list.value![_selectedIndex!].id!, isCopy: true);
                                  },
                                );
                                priceListBloc.eventSink.add(LoadPrice());
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
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Delete'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                if (_selectedIndex! > -1) {
                                  priceListBloc.deletePrice(priceListBloc.list.value![_selectedIndex!].id!);
                                }
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
    return Column(children: [
      Container(
        height: 50,
        decoration:
            BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
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
          ],
        ),
      ),
      Expanded(
        child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: StreamBuilder(
                stream: priceListBloc.list.stream,
                initialData: priceListBloc.list.value,
                builder: (context, snapshot) {
                  return priceListBloc.list.value != null
                      ? ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemExtent: 60,
                          itemCount: priceListBloc.list.value!.length,
                          itemBuilder: (context, index) {
                            PriceLabel price = priceListBloc.list.value![index];

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
                                        price.name!,
                                        style: TextStyle(
                                          fontSize: 23,
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
                })),
      )
    ]);
  }

  void listItemTapped(int index) {
    if (orientation == Orientation.portrait) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) =>
              CupertinoActionSheet(title: Text(AppLocalizations.of(context)!.translate('Select an action')), actions: <Widget>[
                CupertinoActionSheetAction(
                    child: Text(AppLocalizations.of(context)!.translate('Edit')),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PriceLabelForm(id: priceListBloc.list.value![index].id!);
                        },
                      );
                    }),
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context)!.translate('Copy')),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PriceLabelForm(id: priceListBloc.list.value![_selectedIndex!].id!, isCopy: true);
                      },
                    );
                    priceListBloc.eventSink.add(LoadPrice());
                    Navigator.pop(context, 'Copy');
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Delete'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    priceListBloc.deletePrice(priceListBloc.list.value![index].id!);
                  },
                )
              ]));
    }
    _onSelected(index);
  }
}
