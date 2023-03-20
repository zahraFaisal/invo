import 'package:invo_mobile/models/order/order_header.dart';
import 'dart:convert';

class OrderRequest {
  String from;
  String to;
  String request;
  OrderHeader? order;

  OrderRequest({this.from = "", this.to = "", this.request = "", this.order});

  factory OrderRequest.fromMap(Map<String, dynamic> map) {
    OrderRequest orderRequest = OrderRequest();
    OrderHeader _order = OrderHeader(transaction: [], payments: [], service_id: 0, employee_id: 0);
    if (map.containsKey('order') && map['order'] != null) {
      _order = OrderHeader.fromJson(map['order']);
      _order.serverId = map['order']['_id'];
    }

    orderRequest.from = map['from'] ?? "";
    orderRequest.to = map['to'] ?? "";
    orderRequest.request = map['request'] ?? "";
    orderRequest.order = _order;

    return orderRequest;
  }
}
