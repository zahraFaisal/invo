import 'package:invo_mobile/models/reports/DailySalesModel.dart';
import 'package:invo_mobile/models/reports/SalesByEmployeeModel.dart';
import 'package:invo_mobile/models/reports/SalesByServiceModel.dart';

class DashBoardModel {
  double total_sale;
  double total_income;
  double total_order;
  List<SalesByEmployeeModel>? employee_report;
  List<SalesByServiceModel>? service_report;
  List<DailySalesModel>? daily_report;

  DashBoardModel({this.total_sale = 0, this.total_income = 0, this.total_order = 0, this.employee_report, this.service_report, this.daily_report}) {
    this.employee_report = List<SalesByEmployeeModel>.empty(growable: true);
    this.service_report = List<SalesByServiceModel>.empty(growable: true);
    this.daily_report = List<DailySalesModel>.empty(growable: true);
  }

  factory DashBoardModel.fromMap(Map<String, dynamic> map) {
    DashBoardModel dashBoardModel = DashBoardModel();
    dashBoardModel.total_sale = map['Total'] == null ? 0.0 : double.parse(map['Total'].toString());
    dashBoardModel.total_order = map['qty'] == null ? 0.0 : double.parse(map['qty'].toString());
    return dashBoardModel;
  }
}
