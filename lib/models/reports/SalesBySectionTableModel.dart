import '../Number.dart';

class SalesBySectionTableModel {
  int groupId;
  String groupName;
  double orderSum;
  int totalOrder;
  double average;

  SalesBySectionTableModel({this.average = 0, this.groupId = 0, this.groupName = "", this.orderSum = 0, this.totalOrder = 0});

  factory SalesBySectionTableModel.fromMap(Map<String, dynamic> map) {
    SalesBySectionTableModel salesBySectionTableModel = SalesBySectionTableModel();
    salesBySectionTableModel.groupId = map['groupId'];
    salesBySectionTableModel.groupName = map['groupName'];
    salesBySectionTableModel.orderSum = map['orderSum'];
    salesBySectionTableModel.totalOrder = map['totalOrder'];
    salesBySectionTableModel.average = map['average'];
    return salesBySectionTableModel;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{'groupId': groupId, 'name': groupName, 'order_sum': orderSum, 'total_order': totalOrder, 'average': average};
    return map;
  }

  String get orderTotalPrice {
    return Number.formatCurrency(orderSum);
  }
}
