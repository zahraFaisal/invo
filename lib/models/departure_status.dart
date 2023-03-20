import 'dart:core';
import 'package:invo_mobile/models/order/employee_reference.dart';

class DepartureStatus {
  int id;
  String server_id; // replace for _id
  DateTime? date_time;
  EmployeeReference? driver;
  int status;
  DateTime? depature_time;
  DateTime? arrival_time;

  DepartureStatus({this.id = 0, this.date_time, this.server_id = "", this.driver, this.status = 0, this.depature_time, this.arrival_time});

  Map<String, dynamic> toMap() {
    int? _dateTime = (date_time == null || date_time!.toUtc().millisecondsSinceEpoch == null) ? null : date_time!.toUtc().millisecondsSinceEpoch;
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'date_time': _dateTime,
      'server_id': server_id,
      'status': status,
      'driver': driver,
      'depature_time': depature_time,
      'arrival_time': arrival_time
    };
    return map;
  }
}
