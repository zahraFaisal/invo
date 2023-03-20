import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'dart:convert';

class MiniOrder {
  int id;
  int ticketNumber;
  int status;
  String? customerName;
  String customer_contact;
  String employeeName;
  String? printTime;
  DateTime? date_time;
  DateTime? prepared_date;
  int driverId;
  int employeeId;
  double grandPrice;
  String table_name;
  DateTime? depature_time;
  DateTime? arrival_time;
  bool isSelected;
  String server_id;
  String Label;

  Property<bool>? updated;

  MiniOrder(
      {this.id = 0,
      this.ticketNumber = 0,
      this.status = 0,
      this.customerName = "",
      this.employeeName = "",
      this.printTime,
      this.date_time,
      this.driverId = 0,
      this.employeeId = 0,
      this.depature_time,
      this.customer_contact = "",
      this.arrival_time,
      this.prepared_date,
      this.grandPrice = 0,
      this.Label = "",
      this.isSelected = false,
      this.server_id = "",
      this.table_name = ""}) {
    updated = Property<bool>();
  }

  factory MiniOrder.fromJson(Map<String, dynamic> json) {
    DateTime? _depatureTime = (json.containsKey('depature_time') && json['depature_time'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['depature_time'].substring(6, json['depature_time'].length - 7)))
        : null;

    DateTime? _arrivalTime = (json.containsKey('arrival_time') && json['arrival_time'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['arrival_time'].substring(6, json['arrival_time'].length - 7)))
        : null;

    DateTime? _dateTime = (json.containsKey('date_time') && json['date_time'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['date_time'].substring(6, json['date_time'].length - 7)))
        : null;
    DateTime? _prepared_date = (json.containsKey('prepared_date') && json['prepared_date'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['prepared_date'].substring(6, json['prepared_date'].length - 7)))
        : null;
    return MiniOrder(
        id: json['id'] ?? 0,
        ticketNumber: json['ticket_number'] ?? 0,
        status: json['status'] ?? 0,
        customerName: json['Customer_name'] ?? "",
        employeeName: json['Employee_name'] ?? "",
        customer_contact: json['customer_contact'] ?? "",
        printTime: json['_print_time'],
        date_time: _dateTime,
        driverId: json['driver_id'] ?? 0,
        depature_time: _depatureTime,
        arrival_time: _arrivalTime,
        prepared_date: _prepared_date,
        table_name: json['table_name'] ?? "",
        employeeId: json['employee_id'] ?? 0,
        grandPrice: json.containsKey('grand_price') ? double.parse(json['grand_price'].toString()) : 0);
  }

  String get orderSince {
    DateTime currentDate = DateTime.now();
    DateTime? orderDate = date_time;
    Duration difference = currentDate.difference(orderDate!);

    return Misc.sinceDate(difference);
  }

  int? get imageStatus {
    if (status == 6) return 6;
    if (status == 3) return 3;

    if (depature_time != null) return 4;
    if (printTime != null) return 2;
    return status;
  }

  factory MiniOrder.fromMap(Map<String, dynamic> map) {
    MiniOrder miniOrder = MiniOrder();
    miniOrder.id = map['id'] ?? 0;
    miniOrder.ticketNumber = map['ticket_number'] ?? 0;
    miniOrder.Label = map['Label'] ?? "";
    miniOrder.status = map['status'] ?? 0;
    if (map['customer'] != null) {
      miniOrder.customerName = map['customer']['name'];
    } else {
      miniOrder.customerName = map['Customer_name'] ?? "";
    }

    miniOrder.employeeName = map['Employee_name'] ?? "";
    miniOrder.customer_contact = map['customer_contact'] ?? "";
    miniOrder.prepared_date = map['prepared_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['prepared_date']);
    miniOrder.printTime = map['print_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['print_time']).toString();

    if (map['date_time'].toString().contains(':')) {
      miniOrder.date_time = DateTime.parse(map['date_time']);
    } else {
      miniOrder.date_time = map['date_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['date_time']);
    }

    miniOrder.driverId = map['driver_id'] ?? 0;
    miniOrder.depature_time = map['departure_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['departure_time']);
    miniOrder.arrival_time = map['arrival_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['arrival_time']);
    miniOrder.employeeId = map['employee_id'] ?? 0;
    miniOrder.grandPrice = map.containsKey('grand_price') ? double.parse(map['grand_price'].toString()) : 0;
    miniOrder.updated = Property<bool>();

    return miniOrder;
  }

  set serverId(String value) {
    this.server_id = value;
  }

  String get serverId {
    return server_id;
  }

  dispose() {
    updated?.dispose();
  }
}
