// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/settings/dineinList/dinein_table_list_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/dineinList/dinein_table_list_event.dart';
import 'package:invo_mobile/models/dineIn_table.dart';

class TablePicker extends StatefulWidget {
  List<int>? selectedIds = [];
  int groupId;

  TablePicker(this.groupId, {Key? key, this.selectedIds}) : super(key: key);

  @override
  State<TablePicker> createState() => _TablePickerState();
}

class _TablePickerState extends State<TablePicker> {
  late DineinTableListBloc dineinTableListBloc;
  bool isSelected = false;

  void initState() {
    super.initState();
    dineinTableListBloc = DineinTableListBloc(widget.groupId);
    dineinTableListBloc.loadList(widget.selectedIds);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dineinTableListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Pick Table",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 80,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                        height: 55,
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.search, size: 30),
                            Expanded(
                              child: TextField(
                                  onChanged: (value) {
                                    dineinTableListBloc.filterSearchResults(value);
                                  },
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(border: InputBorder.none, hintText: "Search")),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: const BorderRadius.only(topLeft: const Radius.circular(15), topRight: Radius.circular(15))),
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Name',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        isSelected = !isSelected;
                        setState(() {
                          for (var item in dineinTableListBloc.list.value!) {
                            if (isSelected == true)
                              item.isSelected = true;
                            else
                              item.isSelected = false;
                          }
                        });
                      },
                      child: (isSelected == true) ? const Text("UnSelect", style: const TextStyle(color: Colors.white)) : const Text("Select", style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: StreamBuilder(
                    stream: dineinTableListBloc.list.stream,
                    initialData: List.empty(growable: true),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            DineInTable table = dineinTableListBloc.list.value![index];
                            return Container(
                              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              decoration: BoxDecoration(
                                color: (table.isSelected == true) ? Colors.orange[200] : Colors.white,
                                border: Border.all(width: 2),
                              ),
                              child: ListTile(
                                onTap: () {
                                  table.isSelected = !table.isSelected;
                                  setState(() {});
                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        table.name,
                                        style: const TextStyle(
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ),
            Container(
              color: Colors.grey[100],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    margin: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      height: 70,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                        child: const Text(
                          'Cancel',
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    margin: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      height: 70,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ))),
                        child: const Text(
                          'Pick',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          if (dineinTableListBloc.list.value!.where((f) => f.isSelected).toList().length > 0) {
                            dineinTableListBloc.eventSink.add(Save());
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
