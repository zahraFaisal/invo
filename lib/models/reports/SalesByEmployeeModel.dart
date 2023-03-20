import '../Number.dart';

class SalesByEmployeeModel {
  int employeeId;
  String employee;
  int totalOrder; //ordersqty;
  double itemsQty; //itemtotal;
  double sumOrder; //ItemTotal;
  double grandTotal; //orderTotal;

  SalesByEmployeeModel({this.employee = "", this.employeeId = 0, this.grandTotal = 0, this.itemsQty = 0, this.sumOrder = 0, this.totalOrder = 0});

  factory SalesByEmployeeModel.fromMap(Map<String, dynamic> map) {
    SalesByEmployeeModel salesByEmployeeModel = SalesByEmployeeModel();
    salesByEmployeeModel.employeeId = map['employeeId'] ?? 0;
    salesByEmployeeModel.employee = map['employee'] ?? "";
    salesByEmployeeModel.itemsQty = map['itemsQty'] ?? 0.0;
    salesByEmployeeModel.sumOrder = map['sumOrder'] ?? 0.0;
    salesByEmployeeModel.grandTotal = map['grandTotal'] ?? 0.0;
    salesByEmployeeModel.totalOrder = map['totalOrder'] ?? 0;
    return salesByEmployeeModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'employeeId': employeeId,
      'employee': employee,
      'items_total': itemsQty,
      'sum_order': sumOrder,
      'grandTotal': grandTotal,
      'total_order': totalOrder
    };
    return map;
  }

  String get orderTotalPrice {
    return Number.formatCurrency(sumOrder);
  }

  String get grandTotalPrice {
    return Number.formatCurrency(grandTotal);
  }
}
