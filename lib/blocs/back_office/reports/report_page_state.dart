import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailySalesModel.dart';
import 'package:invo_mobile/models/reports/DriverSummaryModel.dart';
import 'package:invo_mobile/models/reports/OrderTotalDetailModel.dart';
import 'package:invo_mobile/models/reports/SalesByCategoryModel.dart';
import 'package:invo_mobile/models/reports/SalesByEmployeeModel.dart';
import 'package:invo_mobile/models/reports/SalesByHoursModel.dart';

import 'package:invo_mobile/models/reports/SalesByItemModel.dart';
import 'package:invo_mobile/models/reports/SalesBySectionTableModel.dart';
import 'package:invo_mobile/models/reports/SalesByServiceModel.dart';
import 'package:invo_mobile/models/reports/SalesByTableModel.dart';
import 'package:invo_mobile/models/reports/SalesSummaryModels.dart';
import 'package:invo_mobile/models/reports/TaxReportModel.dart';
import 'package:invo_mobile/models/reports/VoidReportModel.dart';

abstract class ReportPageState {}

class SalesSummaryReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesByServiceModel> services;
  List<CategorySalesModel> data;
  List<PaymentMethodSalesModel> methods;
  SummaryModel summary;
  List<CashierReportDetails> shortOver;
  List<DiscountModel> discount;
  SalesSummaryReport(this.from, this.to, this.data, this.methods, this.services,
      this.summary, this.discount, this.shortOver);
}

class DailySalesReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<DailySalesModel> data;
  DailySalesReport(this.from, this.to, this.data);
}

class SalesByHoursReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesByHoursModel> data;
  SalesByHoursReport(this.from, this.to, this.data);
}

class SalesByServiceReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesByServiceModel> data;

  SalesByServiceReport(this.from, this.to, this.data);
}

class SalesByTableReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesByTableModel> data;

  SalesByTableReport(this.from, this.to, this.data);
}

class SalesBySectionTableReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesBySectionTableModel> data;
  SalesBySectionTableReport(this.from, this.to, this.data);
}

class SalesByItemReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesByItemModel> data;
  SalesByItemReport(this.from, this.to, this.data);
}

class SalesByCategoryReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesByCategoryModel> data;
  List<OrderTotalDetailsModel> details;
  SalesByCategoryReport(this.from, this.to, this.data, this.details);
}

class Tax implements ReportPageState {
  DateTime from;
  DateTime to;
  List<TaxReportModel> data;
  Tax(this.from, this.to, this.data);
}

class SalesByEmployeeReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<SalesByEmployeeModel> data;
  List<OrderTotalDetailsModel> details;
  SalesByEmployeeReport(this.from, this.to, this.data, this.details);
}

class DriverSummaryReport implements ReportPageState {
  DateTime from;
  DateTime to;
  List<DriverSummaryModel> data;
  DriverSummaryReport(this.from, this.to, this.data);
}

class Voidorders implements ReportPageState {
  DateTime from;
  DateTime to;
  List<VoidReportModel> data;
  Voidorders(this.from, this.to, this.data);
}
