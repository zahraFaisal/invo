import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/settings/price_managment_list_page/price_managment_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/price_managment_list_page/price_managment_list_page.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/price_managment_list.dart';
import 'package:invo_mobile/views/back_office/settings/price_managment/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class PriceManagmentListPage extends StatefulWidget {
  PriceManagmentListPage({Key? key}) : super(key: key);

  @override
  _PriceManagmentListPageState createState() => _PriceManagmentListPageState();
}

class _PriceManagmentListPageState extends State<PriceManagmentListPage> {
  late PriceManagmentListPageBloc priceManagmentBloc;
  late ScrollController scrollController;
  late PriceManagementList tempPrice;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    priceManagmentBloc = new PriceManagmentListPageBloc(BlocProvider.of<NavigatorBloc>(context));
    priceManagmentBloc.loadList();
    scrollController = new ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    priceManagmentBloc.dispose();
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
            height: 70,
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 55,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search, size: 30),
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                priceManagmentBloc.filterSearchResults(value);
                              },
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate("Search"))),
                        ),
                      ],
                    ),
                  ),
                ),
                orientation == Orientation.portrait
                    ? Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 10),
                        child: ButtonTheme(
                          height: 45,
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
                                  return PriceManagmentForm();
                                },
                              );
                              priceManagmentBloc.eventSink.add(LoadPriceManagment());
                            },
                          ),
                        ))
                    : Center(),
                Container(
                  margin: EdgeInsets.only(left: 10),
                ),
              ],
            ),
          ),
          Expanded(
            child: orientation == Orientation.portrait ? portrait() : landscape(),
          ),
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
                  margin: EdgeInsets.only(top: 70),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
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
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return PriceManagmentForm();
                                },
                              );
                              priceManagmentBloc.eventSink.add(LoadPriceManagment());
                            },
                          ),
                        ),
                      ),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(bottom: 8),
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
                                if (_selectedIndex != null && tempPrice != null) {
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return PriceManagmentForm(
                                        id: tempPrice.id,
                                      );
                                    },
                                  );
                                  priceManagmentBloc.eventSink.add(LoadPriceManagment());
                                }
                              },
                            ),
                          )),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(bottom: 8),
                          child: ButtonTheme(
                            height: 55,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Delete'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                priceManagmentBloc.deletePriceManagment(tempPrice.id);
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
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blueGrey[900]!, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            padding: EdgeInsets.only(left: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Name'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Discount'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Surcharge'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Price'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: priceManagmentBloc.list.stream,
                initialData: priceManagmentBloc.list.value,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return priceManagmentBloc.list.value != null
                      ? ListView.builder(
                          itemExtent: 60,
                          padding: EdgeInsets.all(0),
                          itemCount: priceManagmentBloc.list.value!.length,
                          itemBuilder: (context, index) {
                            PriceManagementList priceManagement = priceManagmentBloc.list.value![index];
                            return Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              decoration: BoxDecoration(
                                color: (_selectedIndex != null && _selectedIndex == index) ? Colors.orange[200] : Colors.white,
                                border: Border.all(width: 2),
                              ),
                              child: InkWell(
                                onTap: () {
                                  listItemTapped(priceManagmentBloc.list.value![index], index);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          (priceManagement.name != null) ? priceManagement.name : "",
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: AutoSizeText(
                                          priceManagement.discount == null ? "" : priceManagement.discount.toString(),
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 23,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Center(
                                            child: AutoSizeText(
                                              priceManagement.surcharge == null ? "" : priceManagement.surcharge.toString(),
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 23,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Center(
                                            child: AutoSizeText(
                                              priceManagement.price_label == null ? "" : priceManagement.price_label.toString(),
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 23,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Center(child: CircularProgressIndicator());
                }),
          )
        ],
      ),
    );
  }

  void listItemTapped(PriceManagementList priceManagement, int index) {
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
                        return PriceManagmentForm(id: priceManagement.id);
                      },
                    );
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Delete'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    priceManagmentBloc.deletePriceManagment(priceManagement.id);
                  },
                )
              ]));
    }
    tempPrice = priceManagement;
    _onSelected(index);
  }
}
