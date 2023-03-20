import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/models/menu_group.dart';

import '../../../repositories/connection_repository.dart';
import '../../../service_locator.dart';

class ListOfGroups extends StatefulWidget {
  final OrderPageBloc bloc;
  final int numberOfRows;

  const ListOfGroups({Key? key, required this.numberOfRows, required this.bloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListOfGroupsState();
  }
}

class _ListOfGroupsState extends State<ListOfGroups> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    String secondaryLang = locator.get<ConnectionRepository>().preference!.secondary_lang_code;
    String lang = locator.get<ConnectionRepository>().terminal!.langauge ?? "";

    return StreamBuilder(
        stream: widget.bloc.selectedMenuGroup.stream,
        initialData: widget.bloc.selectedMenuGroup.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          MenuGroup selected = widget.bloc.selectedMenuGroup.value ?? MenuGroup();

          List<MenuGroup> list = widget.bloc.groups.value!;
          list.sort((prev, next) {
            if (prev == null || next == null) return 0;
            if (prev.index == null) prev.index = 0;
            if (next.index == null) next.index = 0;
            if (prev.index > next.index) {
              return 1;
            } else {
              return -1;
            }
          });

          //print(list.first.toMap().toString());

          return GridView.builder(
            itemCount: list.length,
            padding: EdgeInsets.all(3.5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisSpacing: 7,
              crossAxisCount: widget.numberOfRows == null ? 2 : widget.numberOfRows,
              childAspectRatio: 0.40, // 1 / 3
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              double borderWidth = 0;
              if (selected != null) {
                if (selected.id == list[index].id) borderWidth = 4;
              }
              String groupName = list[index].name;
              if (lang == secondaryLang && list[index].secondary_name.isNotEmpty) {
                groupName = list[index].secondary_name;
              }

              return InkWell(
                onTap: () {
                  widget.bloc.eventSink.add(MenuGroupClicked(list[index]));
                  // setState(() {
                  //   widget.bloc.eventSink.add(MenuGroupClicked(list[index]));
                  // });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(
                        list[index].getColorFromHex(),
                      ),
                      border: Border.all(
                        width: borderWidth,
                        color: Colors.red,
                      )),
                  child: Center(
                    child: Text(
                      groupName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
