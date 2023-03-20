import 'package:invo_mobile/models/order/employee_reference.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';

class OrderStatus {
  String id_; //it is _id from the server [server id]
  int id;
  int ticket_number;
  int status;

  String GUID;
  DateTime? depature_time;
  DateTime? arrival_time;

  List<OrderTransaction>? transactions;
  EmployeeReference? driver;
  String branch_token;
  OrderStatus(
      {this.id = 0,
      this.id_ = "",
      this.ticket_number = 0,
      this.status = 0,
      this.depature_time,
      this.arrival_time,
      this.GUID = "",
      this.branch_token = "",
      this.transactions});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      '_id': id_,
      'id_': id_,
      'ticket_number': ticket_number,
      'status': status,
      'GUID': GUID,
      'branch_token': branch_token,
      'depature_time': depature_time,
      'arrival_time': arrival_time,
      'transactions': transactions
    };
    return map;
  }

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json['id'] ?? 0,
      id_: json['id_'] ?? "",
      ticket_number: json['ticket_number'] ?? 0,
      status: json['status'] ?? 0,
      GUID: json['GUID'] ?? "",
      branch_token: json['branch_token'] ?? "",
      depature_time: json['depature_time'],
      arrival_time: json['arrival_time'],
    );
  }
}
