import '../Number.dart';

class VoidReportModel {
  String employeeName;
  String reasons;
  String itemName;
  DateTime? date;
  double amount;
  int orderId;
  int transaction_id;

  VoidReportModel(
      {this.amount = 0, this.date, this.employeeName = "", this.itemName = "", this.orderId = 0, this.reasons = "", this.transaction_id = 0});
  factory VoidReportModel.fromMap(Map<String, dynamic> map) {
    VoidReportModel voidReportModel = VoidReportModel();
    voidReportModel.employeeName = map['employeeName'];
    voidReportModel.reasons = map['reasons'];
    voidReportModel.itemName = map['itemName'];
    voidReportModel.date = map['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['date']);
    voidReportModel.amount = map['amount'];
    voidReportModel.orderId = map['orderId'];
    voidReportModel.transaction_id = map['transaction_id'];
    return voidReportModel;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'employee_name': employeeName,
      'reasons': reasons,
      'itemName': itemName,
      'date_time': (date == null) ? null : "/Date(" + (date?.millisecondsSinceEpoch).toString() + ")/",
      'amount': amount,
      'order_id': orderId,
      'transaction_id': transaction_id
    };
    return map;
  }

  String get orderAmount {
    return Number.formatCurrency(amount);
  }
}
