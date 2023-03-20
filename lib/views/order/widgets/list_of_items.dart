import "package:flutter/material.dart";
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:invo_mobile/blocs/order_page/order_page_bloc.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/views/order/widgets/item.dart';
import 'package:collection/collection.dart';

class ListOfItems extends StatefulWidget {
  final OrderPageBloc bloc;
  ListOfItems({required this.bloc});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListOfItemsState();
  }
}

class _ListOfItemsState extends State<ListOfItems> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: widget.bloc.items.stream,
      initialData: widget.bloc.items.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var shortestSide = MediaQuery.of(context).size.shortestSide;
        bool mobileLayout = shortestSide < 500;

        if (getDeviceTypeInLandscape(context) == "7 Inch or less") {
          List<MenuItemGroup> list = snapshot.data;
          if (list != null) {
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

            for (var item in list.toList()) {
              if (item.menu_item == null) list.remove((item));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: mobileLayout ? 3 : 4, childAspectRatio: 0.9),
              itemBuilder: (context, index) {
                if (list[index].menu_item != null)
                  // ignore: curly_braces_in_flow_control_structures
                  return Padding(
                    padding: EdgeInsets.only(left: 3, right: 3, bottom: 3),
                    child: Item(
                      item: list[index].menu_item!,
                      onTap: () {
                        widget.bloc.eventSink.add(MenuItemClicked(list[index].menu_item!));
                      },
                    ),
                  );
                else
                  return Center();
              },
              itemCount: list.length,
            );
          } else {
            return Center(
              child: Text("No Menu Items"),
            );
          }
        } else {
          List<MenuItemGroup> list = snapshot.data;
          if (list == null) list = List<MenuItemGroup>.empty(growable: true);

          MenuItemGroup? temp;
          for (var i = 0; i < 36; i++) {
            if (list.where((f) => f.index == i).length == 0) {
              list.add(new MenuItemGroup(
                index: i,
              ));
            }
          }

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

          try {
            for (var item in list.where((f) => f.menu_item != null).toList()) {
              if (item.index == null) item.index = 0;

              // temp = list.firstWhereOrNull((f) => f.index == item.index,
              //     orElse: () => null);
              // if (temp != null && temp.menu_item == null) list.remove(temp);

              if (item.double_height) {
                temp = list.firstWhereOrNull((f) => f.index == item.index + 6);
                if (temp != null && temp.menu_item == null) list.remove(temp);
              }

              if (item.double_width) {
                temp = list.firstWhereOrNull((f) => f.index == item.index + 1);
                if (temp != null && temp.menu_item == null) list.remove(temp);
              }

              if (item.double_height && item.double_width) {
                temp = list.firstWhereOrNull((f) => f.index == item.index + 7);
                if (temp != null && temp.menu_item == null) list.remove(temp);
              }
            }
            //print("list length : ${list.length}");
          } catch (e) {
            print("error :" + e.toString());
          }

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
          return StaggeredGridView.countBuilder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            crossAxisCount: 6,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              if (list[index] != null && list[index].menu_item != null) {
                return Item(
                  onTap: () => widget.bloc.eventSink.add(MenuItemClicked(list[index].menu_item!)),
                  item: list[index].menu_item!,
                );
              } else {
                return Center();
              }
            },
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            staggeredTileBuilder: (int index) {
              temp = list[index];
              if (temp != null && temp!.menu_item != null) {
                return StaggeredTile.count(temp!.double_width ? 2 : 1, temp!.double_height ? 2 : 1);
              } else
                return StaggeredTile.count(1, 1);
            },
          );
        }
      },
    );
  }

  String getDeviceTypeInLandscape(BuildContext context) {
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    var width = MediaQuery.of(context).size.width * devicePixelRatio;
    var height = MediaQuery.of(context).size.height * devicePixelRatio;
    Orientation orientation = MediaQuery.of(context).orientation;

    var deviceType;

    if (orientation == Orientation.portrait) {
      deviceType = "7 Inch or less";
    } else {
      if (width <= 1280 && height <= 800) {
        deviceType = "7 Inch or less";
      } else if (width >= 2048 && height <= 1536 && height > 1400) {
        deviceType = "8.9 Inch or more";
      } else {
        deviceType = "unknow type";
      }
    }

    print(deviceType + " width:" + width.toString() + " height:" + height.toString());

    return "$deviceType";
  }
}
