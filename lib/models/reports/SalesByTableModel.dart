import '../Number.dart';

class SalesByTableModel {
  int tableId;
  String tableName;
  int guest;
  double avgarageGuest;
  double orderSum;
  int totalOrder;
  double average;
  SalesByTableModel(
      {this.average = 0, this.avgarageGuest = 0, this.guest = 1, this.orderSum = 0, this.tableId = 0, this.tableName = "", this.totalOrder = 0});
  factory SalesByTableModel.fromMap(Map<String, dynamic> map) {
    SalesByTableModel salesByTableModel = SalesByTableModel();
    salesByTableModel.tableId = map['tableId'];
    salesByTableModel.tableName = (map['tableName'] == null) ? "" : map['tableName'];
    salesByTableModel.guest = map['guest'];
    salesByTableModel.avgarageGuest = map['avgarageGuest'];
    salesByTableModel.orderSum = map['orderSum'];
    salesByTableModel.totalOrder = map['totalOrder'];
    salesByTableModel.average = map['average'];
    return salesByTableModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'tableId': tableId,
      'name': tableName,
      'guest': guest,
      'avg_guest': avgarageGuest,
      'order_sum': orderSum,
      'total_order': totalOrder,
      'average': average
    };
    return map;
  }

  String get orderTotalPrice {
    return Number.formatCurrency(orderSum);
  }
}
