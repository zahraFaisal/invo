import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:invo_mobile/blocs/back_office/Menu/DiscountList/discount_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/DiscountList/discount_list_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';

import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/views/back_office/Menu_items/discount/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class DiscountListPage extends StatefulWidget {
  @override
  _DiscountListPageState createState() => _DiscountListPageState();
}

class _DiscountListPageState extends State<DiscountListPage> with SingleTickerProviderStateMixin {
  late DiscountListBloc discountListBloc;
  late String dropdownValue;
  late String dropdownValueTaxes;
  bool isSwitched = false;
  void initState() {
    super.initState();
    discountListBloc = DiscountListBloc(BlocProvider.of<NavigatorBloc>(context));
  }

  @override
  void dispose() {
    super.dispose();
    discountListBloc.dispose();
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
                                discountListBloc.filterSearchResults(value);
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
                                  return DiscountForm();
                                },
                              );
                              discountListBloc.eventSink.add(LoadDiscount());
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
                                    return DiscountForm();
                                  },
                                );
                                discountListBloc.eventSink.add(LoadDiscount());
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
                                if (_selectedIndex! > -1) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DiscountForm(
                                        id: discountListBloc.list.value![_selectedIndex!].id,
                                      );
                                    },
                                  );

                                  discountListBloc.eventSink.add(LoadDiscount());
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
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Copy'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_selectedIndex! > -1) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DiscountForm(id: discountListBloc.list.value![_selectedIndex!].id, isCopy: true);
                                    },
                                  );

                                  discountListBloc.eventSink.add(LoadDiscount());
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
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ))),
                              child: Text(
                                AppLocalizations.of(context)!.translate('Delete'),
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              onPressed: () {
                                discountListBloc.deleteDiscount(discountListBloc.list.value![_selectedIndex!].id);
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Container(
              width: 150,
              child: Text(
                AppLocalizations.of(context)!.translate('Amount'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: StreamBuilder(
              stream: discountListBloc.list.stream,
              initialData: discountListBloc.list.value,
              builder: (context, snapshot) {
                return discountListBloc.list.value != null
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemExtent: 60,
                        itemCount: discountListBloc.list.value!.length,
                        itemBuilder: (context, index) {
                          DiscountList discount = discountListBloc.list.value![index];
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
                                      (discount.name == null) ? "" : discount.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    child: Text(
                                      discount.is_percentage ? '${discount.amount}%' : Number.getNumber(discount.amount),
                                      style: TextStyle(
                                        fontSize: 25,
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
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DiscountForm(
                          id: discountListBloc.list.value![index].id,
                        );
                      },
                    );
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context)!.translate('Copy')),
                  onPressed: () async {
                    if (_selectedIndex! > -1) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DiscountForm(id: discountListBloc.list.value![_selectedIndex!].id, isCopy: true);
                        },
                      );

                      discountListBloc.eventSink.add(LoadDiscount());
                      Navigator.pop(context, 'Copy');
                    }
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Delete'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    discountListBloc.deleteDiscount(discountListBloc.list.value![index].id);
                  },
                )
              ]));
    }
    _onSelected(index);
  }
}
