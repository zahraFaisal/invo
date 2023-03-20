import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/dinein_page/dinein_page_bloc.dart';
import 'package:invo_mobile/blocs/dinein_page/dinein_page_events.dart';
import 'package:invo_mobile/helpers/dineIn_image.dart';
import 'package:invo_mobile/models/custom/table_status.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/views/order/index.dart';

class SectionFloor extends StatefulWidget {
  final DineInPageBloc dineInPageBloc;
  final List<DineInTable> tables;
  final FloorType type;
  SectionFloor({required this.dineInPageBloc, required this.tables, required this.type});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SectionFloorState();
  }
}

enum FloorType {
  gridView,
  positionView,
}

class _SectionFloorState extends State<SectionFloor> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 30;
    width = MediaQuery.of(context).size.width;
    // TODO: implement build
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    bool mobileLayout = shortestSide < 600;

    if (widget.type == FloorType.gridView) {
      return GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: mobileLayout ? 2 : 3),
        itemCount: widget.tables.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: InkWell(
              onTap: () {
                widget.dineInPageBloc.eventSink.add(TableClick(widget.tables[index]));
              },
              child: tableWidget(widget.tables[index], 150, 150),
            ),
          );
        },
      );
    }

    // return GridView.count(
    //   crossAxisCount: 7,

    //   childAspectRatio: 1.5 ,
    //   children: <Widget>[
    //     Image.asset("assets/table_icons/1_Person/1_Person_S_G.png"),
    //     Image.asset("assets/table_icons/2_Persons/2_Person_S_R.png"),
    //     Image.asset("assets/table_icons/4_Persons/4_Person_C_G.png"),
    //     Image.asset("assets/table_icons/6_Persons/6_Persons_C_G.png"),
    //     Image.asset("assets/table_icons/8_Persons/8_Persons_C_G.png"),
    //     Image.asset("assets/table_icons/10_Persons/10_Persons_R_G.png"),
    //   ],
    // );
    List<Widget> tables = List<Widget>.empty(growable: true);
    for (var item in widget.tables) {
      tables.add(
        Positioned(
          left: getLeftPosition(item.X),
          top: item.Y,
          child: InkWell(
            onTap: () {
              widget.dineInPageBloc.eventSink.add(TableClick(item));
            },
            child: tableWidget(item, item.tableImage.width!, item.tableImage.height!),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        height: 600,
        width: 1024,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: tables,
        ),
      ),
    );
  }

  Widget tableWidget(DineInTable item, double width, double height) {
    return Stack(
      children: <Widget>[
        Transform.rotate(
          angle: item.angle,
          child: StreamBuilder(
            stream: item.tableStatusStream,
            initialData: item.tableStatus,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              TableStatus? temp = snapshot.data;
              String imagePath = "";
              if (temp == null) {
                imagePath = item.tableImage.image_green!;
              } else {
                switch (temp.tableStatus) {
                  case 2:
                    imagePath = item.tableImage.image_red!;
                    break;
                  case 4:
                    imagePath = item.tableImage.image_white!;
                    break;
                  case 1:
                    imagePath = item.tableImage.image_green!;
                    break;
                  default:
                    imagePath = item.tableImage.image_green!;
                    break;
                }
              }
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(imagePath),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: width,
          height: height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: item.tableStatusStream,
                  initialData: item.tableStatus,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    TableStatus? temp = snapshot.data;
                    if (temp == null || temp.orderCount == 0)
                      return SizedBox(
                        height: 0,
                      );
                    return Text(
                      temp.orderCount.toString() + " Ticket",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: item.duration!.stream,
                  initialData: item.duration!.value,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    TableStatus? temp = item.tableStatus;
                    if (temp == null || temp.orderCount == 0)
                      return SizedBox(
                        height: 0,
                      );

                    return Text(
                      temp.openOrderSince.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getTopPosition(double y) {
    double percentage = y / 768;
    return height * percentage;
  }

  getLeftPosition(double i) {
    double percentage = i / 1024;
    return width * percentage;
  }

  getTableHeight(double defaultHeight) {
    double percentage = defaultHeight / 768;
    return height * percentage;
  }
}
