import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuitemList/menu_item_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuitemList/menu_item_list_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';

import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:invo_mobile/views/back_office/Menu_items/menu_items/form.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class MenuItemsListPage extends StatefulWidget {
  @override
  _MenuItemsListPageState createState() => _MenuItemsListPageState();
}

class _MenuItemsListPageState extends State<MenuItemsListPage> with SingleTickerProviderStateMixin {
  TextEditingController editingController = TextEditingController();
  late MenuItemListBloc menuItemListBloc;

  void initState() {
    super.initState();
    menuItemListBloc = MenuItemListBloc(BlocProvider.of<NavigatorBloc>(context));
    menuItemListBloc.loadList(null);
  }

  @override
  void dispose() {
    super.dispose();
    menuItemListBloc.dispose();
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
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    height: 55,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search, size: 30),
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                menuItemListBloc.filterSearchResults(value);
                              },
                              controller: editingController,
                              style: new TextStyle(fontSize: 20),
                              decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search'))),
                        ),
                      ],
                    ),
                  ),
                ),
                orientation == Orientation.portrait
                    ? Row(
                        children: [
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(left: 10),
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
                                      return MenuItemForm();
                                    },
                                  );
                                  menuItemListBloc.eventSink.add(LoadMenuItem());
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ButtonTheme(
                                    height: 55,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ))),
                                        onPressed: () async {
                                          String isImport = "";
                                          isImport = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                child: Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                  padding: EdgeInsets.all(8),
                                                  height: 150,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(context, rootNavigator: true).pop("Import");
                                                              },
                                                              child: Text(
                                                                AppLocalizations.of(context)!.translate('Import from CSV'),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontSize: 20, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(context, rootNavigator: true).pop("download");
                                                              },
                                                              child: Text(
                                                                AppLocalizations.of(context)!.translate('Download Menu Item Template'),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontSize: 20, color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          if (isImport != "") menuItemListBloc.eventSink.add(ImportMenuItem(isImport));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('Import'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20, color: Colors.white),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(),
                Container(
                  margin: EdgeInsets.only(left: 10),
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 16),
          //   color: Colors.white,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: ElevatedButton(
          //             padding: EdgeInsets.all(4),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //             color: Colors.blueGrey[900],
          //             onPressed: () async {
          //               String isImport = "";
          //               isImport = await showDialog(
          //                 context: context,
          //                 child: Dialog(
          //                   child: Container(
          //                     decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(10)),
          //                     padding: EdgeInsets.all(8),
          //                     height: 150,
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         Row(
          //                           children: [
          //                             Expanded(
          //                               child: ElevatedButton(
          //                                 color: Colors.blueGrey[900],
          //                                 onPressed: () {
          //                                   Navigator.of(context,
          //                                           rootNavigator: true)
          //                                       .pop("Import");
          //                                 },
          //                                 child: Text(
          //                                   AppLocalizations.of(context)
          //                                       !.translate('Import from CSV'),
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       fontSize: 20,
          //                                       color: Colors.white),
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                         Row(
          //                           children: [
          //                             Expanded(
          //                               child: ElevatedButton(
          //                                 color: Colors.blueGrey[900],
          //                                 onPressed: () {
          //                                   Navigator.of(context,
          //                                           rootNavigator: true)
          //                                       .pop("download");
          //                                 },
          //                                 child: Text(
          //                                   AppLocalizations.of(context)!.translate(
          //                                       'Download Menu Item Template'),
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       fontSize: 20,
          //                                       color: Colors.white),
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               );
          //               if (isImport != "")
          //                 menuItemListBloc.eventSink
          //                     .add(ImportMenuItem(isImport));
          //             },
          //             child: Text(
          //               AppLocalizations.of(context)!.translate('Import'),
          //               textAlign: TextAlign.center,
          //               style: TextStyle(fontSize: 20, color: Colors.white),
          //             )),
          //       )
          //     ],
          //   ),
          // ),
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
                                      return MenuItemForm();
                                    },
                                  );
                                  menuItemListBloc.eventSink.add(LoadMenuItem());
                                }),
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
                              if (_selectedIndex != null && _selectedIndex! > -1) {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MenuItemForm(id: menuItemListBloc.list.value![_selectedIndex!].id);
                                  },
                                );

                                menuItemListBloc.eventSink.add(LoadMenuItem());
                              }
                            },
                          ),
                        ),
                      ),
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
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MenuItemForm(id: menuItemListBloc.list.value![_selectedIndex!].id, isCopy: true);
                                },
                              );

                              menuItemListBloc.eventSink.add(LoadMenuItem());
                            },
                          ),
                        ),
                      ),
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
                              menuItemListBloc.deleteMenuItem(menuItemListBloc.list.value![_selectedIndex!].id);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ButtonTheme(
                                height: 55,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ))),
                                    onPressed: () async {
                                      String isImport = "";
                                      isImport = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                              padding: EdgeInsets.all(8),
                                              height: 150,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context, rootNavigator: true).pop("Import");
                                                          },
                                                          child: Text(
                                                            AppLocalizations.of(context)!.translate('Import from CSV'),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context, rootNavigator: true).pop("download");
                                                          },
                                                          child: Text(
                                                            AppLocalizations.of(context)!.translate('Download Menu Item Template'),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      if (isImport != "") menuItemListBloc.eventSink.add(ImportMenuItem(isImport));
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.translate('Import'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  AppLocalizations.of(context)!.translate('Barcode'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 4),
                child: Text(
                  AppLocalizations.of(context)!.translate('Price'),
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
          margin: EdgeInsets.only(bottom: 10),
          child: StreamBuilder(
              stream: menuItemListBloc.list.stream,
              initialData: menuItemListBloc.list.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return menuItemListBloc.list.value != null
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemExtent: 60,
                        itemCount: menuItemListBloc.list.value!.length,
                        itemBuilder: (context, index) {
                          MenuItemList item = menuItemListBloc.list.value![index];
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: AutoSizeText(
                                      item.barcode,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      item.name,
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                        child: AutoSizeText(
                                          Number.getNumber(item.price),
                                          style: TextStyle(
                                            fontSize: 18,
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
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MenuItemForm(
                          id: menuItemListBloc.list.value![index].id,
                        );
                      },
                    );

                    Navigator.of(context).pop();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context)!.translate('Copy')),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MenuItemForm(id: menuItemListBloc.list.value![_selectedIndex!].id, isCopy: true);
                      },
                    );

                    menuItemListBloc.eventSink.add(LoadMenuItem());
                    Navigator.pop(context, 'Copy');
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    AppLocalizations.of(context)!.translate('Delete'),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    menuItemListBloc.deleteMenuItem(menuItemListBloc.list.value![index].id);

                    Navigator.of(context).pop();
                  },
                )
              ]));
    }
    _onSelected(index);
  }
}
