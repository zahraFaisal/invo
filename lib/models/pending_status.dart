import 'dart:convert';
import 'dart:core';

class PendingStatus {
  String id;
  int type;
  String status;
  bool is_sent;
  bool server_sent;

  PendingStatus({this.id = "", this.type = 0, this.status = "", this.is_sent = false, this.server_sent = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == "" ? null : id,
      'type': type,
      'is_sent': is_sent == true ? 1 : 0,
      'status': status,
      'server_sent': server_sent == true ? 1 : 0,
    };
    return map;
  }

  factory PendingStatus.fromMap(Map<String, dynamic> map) {
    PendingStatus pendingStatus = PendingStatus();
    pendingStatus.id = "${map['id']}";
    pendingStatus.type = map['type'];
    pendingStatus.status = map['status'];
    pendingStatus.is_sent = map['is_sent'] == 1 ? true : false;
    pendingStatus.server_sent = map['server_sent'] == 1 ? true : false;
    return pendingStatus;
  }
}
