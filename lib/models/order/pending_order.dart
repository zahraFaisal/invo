class PendingOrder {
  int id;
  String order;
  int status;
  int type;
  String ticketNumber;
  String pending_date_time;

  PendingOrder({this.id = 0, this.order = "", this.status = 0, this.ticketNumber = "", this.type = 0, this.pending_date_time = ""});

  factory PendingOrder.fromMap(Map<String, dynamic> map) {
    PendingOrder pendingOrder = PendingOrder();
    pendingOrder.id = map['id'] ?? 0;
    pendingOrder.order = map['order'] ?? "";
    pendingOrder.status = map['status'] ?? 0;
    pendingOrder.type = map['type'] ?? 0;
    pendingOrder.ticketNumber = map['ticketNumber'] ?? "";
    return pendingOrder;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'order': order,
      'status': status,
      'type': type,
      'pending_date_time': pending_date_time,
      'ticketNumber': ticketNumber
    };
    return map;
  }
}
