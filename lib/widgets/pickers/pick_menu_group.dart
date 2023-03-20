import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuGroupList/menu_group_list_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/views/blocProvider.dart';

class PickMenuGroup extends StatefulWidget {
  final List<int>? selectedIds;
  PickMenuGroup({Key? key, this.selectedIds}) : super(key: key);

  @override
  _PickMenuGroupState createState() => _PickMenuGroupState();
}

class _PickMenuGroupState extends State<PickMenuGroup> {
  late MenuGroupListBloc menuGroupListBloc;
  bool firstpress = false;

  void initState() {
    super.initState();
    menuGroupListBloc = MenuGroupListBloc(BlocProvider.of<NavigatorBloc>(context));
    menuGroupListBloc.loadList(widget.selectedIds!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    menuGroupListBloc.dispose();
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
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Pick Menu Groups",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    InkWell(child: Text("save", style: TextStyle(color: Colors.white, fontSize: 20)), onTap: () {})
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
                                    menuGroupListBloc.filterSearchResults(value);
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
                  TextButton(
                      onPressed: () {
                        setState(() {
                          for (var item in menuGroupListBloc.list.value!) {
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
                    stream: menuGroupListBloc.list.stream,
                    initialData: List.empty(growable: true),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            MenuGroup menuitem = menuGroupListBloc.list.value![index];
                            return Container(
                              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              decoration: BoxDecoration(
                                color: (menuitem.isSelected == true) ? Colors.orange[200] : Colors.white,
                                border: Border.all(width: 2),
                              ),
                              child: ListTile(
                                onTap: () {
                                  menuitem.isSelected = !menuitem.isSelected;
                                  setState(() {});
                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        menuitem.name,
                                        style: TextStyle(
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
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(List<MenuGroup>.empty(growable: true));
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
                          Navigator.of(context).pop(menuGroupListBloc.list.value!.where((f) => f.isSelected).toList());
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
