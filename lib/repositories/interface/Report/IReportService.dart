import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/DailyClosingModel.dart';
import 'package:invo_mobile/models/reports/DailySalesModel.dart';
import 'package:invo_mobile/models/reports/DashBoardReportModel.dart';
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

abstract class IReportService {
  Future<List<SalesByServiceModel>> salesByService(DateTime from, DateTime to);
  Future<List<SalesByTableModel>> salesByTable(DateTime from, DateTime to);
  Future<List<SalesBySectionTableModel>> salesBySectionTable(DateTime from, DateTime to);
  Future<List<SalesByItemModel>> salesByItem(DateTime from, DateTime to);
  Future<List<SalesByCategoryModel>> salesByCategory(DateTime from, DateTime to);
  Future<List<SalesByEmployeeModel>> salesByEmployee(DateTime from, DateTime to);
  Future<List<VoidReportModel>> voidReport(DateTime from, DateTime to);
  Future<List<DriverSummaryModel>> driverSummary(DateTime from, DateTime to);
  Future<List<SalesByHoursModel>> salesByHours(DateTime from, DateTime to);
  Future<List<Orderly>> hourlyOrderList(DateTime from, DateTime to, hour);
  Future<List<DailySalesModel>> dailySales(DateTime from, DateTime to);
  Future<List<OrderTotalDetailsModel>> orderTotalDetail(DateTime from, DateTime to);
  Future<List<CategorySalesModel>> categorysales(DateTime from, DateTime to);
  Future<List<PaymentMethodSalesModel>> paymentMethodsales(DateTime from, DateTime to);
  Future<SummaryModel> summarySales(DateTime from, DateTime to);
  Future<List<DiscountModel>> discountSales(DateTime from, DateTime to);
  Future<DailyClosingModel?> closingSalesReport(DateTime dateTime);
  Future<List<CashierModel>?> getCashiers(DateTime dateTime);
  Future<CashierReportModel?> cashierDetailReport(id);
  Future<DashBoardModel> dashBoardReport(DateTime date);
  Future<List<TaxReportModel>> taxReport(DateTime from, DateTime to);
  Future<List<CashierReportDetails>> shortOverReport(DateTime from, DateTime to);
  Future<List<Orderly>> dailyOrderList(DateTime from, DateTime to);
  Future<List<SalesByItemDetails>> salesByItemDetails(DateTime from, DateTime to);
}
