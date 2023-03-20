import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/modifierList/menu_modifier_list_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/views/blocProvider.dart';

import '../../service_locator.dart';

class PickModifier extends StatefulWidget {
  PickModifier({
    Key? key,
  }) : super(key: key);

  @override
  _PickModifierState createState() => _PickModifierState();
}

class _PickModifierState extends State<PickModifier> {
  late MenuModifierListBloc menuModifierListBloc;

  late Color tabColor;

  bool firstpress = false;

  void initState() {
    super.initState();

    locator.registerSingleton<MenuModifierListBloc>(MenuModifierListBloc(BlocProvider.of<NavigatorBloc>(context)));
    menuModifierListBloc = locator.get<MenuModifierListBloc>();
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
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(List<ModifierList>.empty(growable: true));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Pick Modifier",
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
                            Icon(Icons.search, size: 30),
                            Expanded(
                              child: TextField(
                                  onChanged: (value) {
                                    menuModifierListBloc.filterSearchResults(value);
                                  },
                                  style: new TextStyle(fontSize: 20),
                                  decoration: InputDecoration(border: InputBorder.none, hintText: "Search")),
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
              decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Center(
                        child: Text(
                          'Price',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          for (var item in menuModifierListBloc.list.value!) {
                            if (firstpress == true)
                              item.isSelected = true;
                            else
                              item.isSelected = false;
                          }
                        });
                        firstpress = !firstpress;
                      },
                      child: (firstpress == true) ? Text("UnSelect", style: TextStyle(color: Colors.white)) : Text("Select", style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: StreamBuilder(
                    stream: menuModifierListBloc.list.stream,
                    initialData: List.empty(growable: true),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                ModifierList modifier = menuModifierListBloc.list.value![index];
                                return Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  decoration: BoxDecoration(
                                    color: (modifier.isSelected == true) ? Colors.orange[200] : Colors.white,
                                    border: Border.all(width: 2),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      modifier.isSelected = !modifier.isSelected;

                                      setState(() {});
                                    },
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            modifier.name,
                                            style: TextStyle(
                                              fontSize: 23,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 60),
                                              child: Text(
                                                Number.getNumber(modifier.price),
                                                style: TextStyle(
                                                  fontSize: 23,
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
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(List<ModifierList>.empty(growable: true));
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
                        child: Text(
                          'Pick',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(menuModifierListBloc.list.value!.where((f) => f.isSelected).toList());
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
