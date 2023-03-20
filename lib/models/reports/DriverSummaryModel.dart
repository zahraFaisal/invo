import '../Number.dart';

class DriverSummaryModel {
  late String name;
  late double orderTotal;
  late int orderQty;
  late int avgDeliveryTime;
  DriverSummaryModel({this.name = "", this.orderQty = 0, this.orderTotal = 0, this.avgDeliveryTime = 0});
  factory DriverSummaryModel.fromMap(Map<String, dynamic> map) {
    DriverSummaryModel driverSummaryModel = DriverSummaryModel();
    driverSummaryModel.name = map['name'];
    driverSummaryModel.orderTotal = map['orderTotal'];
    driverSummaryModel.orderQty = map['orderQty'];
    driverSummaryModel.avgDeliveryTime = map['avgDeliveryTime'].toUtc().millisecondsSinceEpoch;
    return driverSummaryModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'name': name,
      'order_total': orderTotal,
      'order_qty': orderQty,
      'AvgDeliveryTime': avgDeliveryTime,
    };
    return map;
  }

  String get orderPrice {
    return Number.formatCurrency(orderTotal);
  }
}
