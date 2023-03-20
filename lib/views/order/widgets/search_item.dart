import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/order_page/order_page_state.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import 'modifier_button.dart';

class SeachItem extends StatefulWidget {
  final Void2VoidFunc? onFinish;
  final OrderPageBloc orderPageBloc;
  SeachItem({Key? key, required this.orderPageBloc, this.onFinish}) : super(key: key);

  @override
  _SeachItemState createState() => _SeachItemState();
}

class _SeachItemState extends State<SeachItem> {
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(2),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                          height: 55,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.search, size: 30),
                              Expanded(
                                child: TextField(
                                    onChanged: (value) {
                                      widget.orderPageBloc.filterSearchResults(value);
                                    },
                                    controller: editingController,
                                    style: new TextStyle(fontSize: 20),
                                    decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context)!.translate('Search'))),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: list(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 6,
                ),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 80,
                    margin: EdgeInsets.only(right: 8),
                    color: Colors.white,
                    child: PrimaryButton(
                      onTap: () {
                        widget.onFinish!();
                      },
                      text: "Cancel",
                    ),
                  ),
                  Container(
                    width: 160,
                    height: 80,
                    color: Colors.white,
                    child: PrimaryButton(
                      onTap: () {
                        widget.orderPageBloc.eventSink.add(MenuItemClicked(widget.orderPageBloc.menuItemsList.value![_selectedIndex].menu_item!));
                        widget.onFinish!();
                      },
                      text: "Pick",
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget list() {
    return Column(children: [
      Container(
        height: 50,
        decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
              stream: widget.orderPageBloc.menuItemsList.stream,
              initialData: widget.orderPageBloc.menuItemsList.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return widget.orderPageBloc.menuItemsList.value != null
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemExtent: 60,
                        itemCount: widget.orderPageBloc.menuItemsList.value!.length,
                        itemBuilder: (context, index) {
                          mi.MenuItem item = widget.orderPageBloc.menuItemsList.value![index].menu_item!;
                          return Container(
                            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              color: (_selectedIndex != null && _selectedIndex == index) ? Colors.orange[200] : Colors.white,
                            ),
                            child: ListTile(
                              onTap: () {
                                _onSelected(index);
                              },
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: AutoSizeText(
                                      item.barcode ?? "",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      item.name ?? "",
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
                                          Number.getNumber(item.default_price),
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
}
