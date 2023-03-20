import 'dart:async';
import 'dart:math' as math;

import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/dineIn_image.dart';
import 'package:invo_mobile/models/dineIn_group.dart';

import 'custom/table_status.dart';

class DineInTable {
  int id;
  String name;
  String postion;
  bool in_active;
  double min_charge;
  int max_seat;
  double charge_per_hour;
  int charge_after;
  int image_type;
  int? surcharge_id;
  int table_group_id;
  bool isSelected;

  DineInGroup? group;

  DineInTable({this.id = 0, this.name = "", this.postion = "", this.in_active = false, this.min_charge = 0, this.max_seat = 0, this.charge_per_hour = 0, this.charge_after = 0, this.table_group_id = 0, this.image_type = 0, this.surcharge_id, this.isSelected = false});

  factory DineInTable.fromJson(Map<String, dynamic> json) {
    return DineInTable(
      id: json['id'] ?? 0,
      name: json['name'].toString(),
      postion: json['postion'].toString(),
      in_active: json['in_active'] ?? false,
      min_charge: double.parse((json['min_charge'] == null) ? "0" : json['min_charge'].toString()),
      max_seat: json['max_seat'] ?? 1,
      charge_per_hour: double.parse((json['charge_per_hour'] == null) ? "0" : json['charge_per_hour'].toString()),
      charge_after: int.parse((json['charge_after'] == null) ? "0" : json['charge_after'].toString()),
      image_type: json['image_type'],
      surcharge_id: json['surcharge_id'],
      table_group_id: 0,
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'position': postion,
      'in_active': in_active == true ? 1 : 0,
      'min_charge': min_charge,
      'max_seat': max_seat != null ? max_seat : 1,
      'charge_per_hour': charge_per_hour,
      'charge_after': charge_after,
      'table_group_id': table_group_id,
      'image_type': image_type,
      'surcharge_id': surcharge_id,
    };
    return map;
  }

  factory DineInTable.fromMap(Map<String, dynamic> map) {
    DineInTable dineInTable = DineInTable();
    dineInTable.id = map['id'];
    dineInTable.name = map['name'];
    dineInTable.postion = map['position'];
    dineInTable.in_active = map['in_active'] == 1 ? true : false;
    dineInTable.min_charge = map['min_charge'];
    dineInTable.max_seat = map['max_seat'];
    dineInTable.charge_per_hour = map['charge_per_hour'];
    dineInTable.charge_after = map['charge_after'];
    dineInTable.table_group_id = map['table_group_id'];
    dineInTable.image_type = map['image_type'];
    dineInTable.surcharge_id = map['surcharge_id'];
    return dineInTable;
  }
  TableStatus? tableStatus;

  final _tableStatusController = StreamController<TableStatus>.broadcast();
  Sink<TableStatus?> get tableStatusSink => _tableStatusController.sink;
  Stream<TableStatus> get tableStatusStream => _tableStatusController.stream;

  Property<bool>? duration = new Property<bool>();

  // void dispose() {
  //   _tableStatusController.close();
  //   duration.dispose();
  // }

  TableImage get tableImage {
    List<TableImage> images = DineInImageSetup.getImages();
    return images.firstWhere((f) => f.type == this.image_type, orElse: () => images[0]);
  }

  double get X {
    if (postion != "" && postion != null) {
      double? x = double.tryParse(postion.split(',')[0]);
      return x == null ? 0 : x;
    }

    return 0;
  }

  double get Y {
    if (postion != "" && postion != null) {
      double y = double.parse(postion.split(',')[1].split(':')[0]);
      return y == null ? 0 : y;
    }
    return 0;
  }

  void savePostion(double x, double y) {
    postion = x.toString() + "," + y.toString() + ":" + "0";
  }

  double get angle {
    if (postion != "" && postion != null) {
      int angle = int.parse(postion.split(',')[1].split(':')[1]);
      switch (angle) {
        case 90:
          return math.pi / 2;
        case 180:
          return -math.pi;
          break;
        case 270:
          return -math.pi / 2;
          break;
        default:
          return 0;
      }
    }

    return 0;
  }
}
