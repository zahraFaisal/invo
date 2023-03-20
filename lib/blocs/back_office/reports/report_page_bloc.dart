import 'dart:async';

import 'package:invo_mobile/blocs/back_office/reports/report_page_event.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart' show BlocBase;
import 'package:invo_mobile/blocs/property.dart';
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
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../service_locator.dart';

class ReportPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;

  final _eventController = StreamController<ReportPageEvent>.broadcast();
  Sink<ReportPageEvent> get eventSink => _eventController.sink;

  Property<ReportPageState> report = Property<ReportPageState>();

  ReportPageBloc() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ReportPageEvent event) async {
    if (event is SalesSummary) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesSummaryReport(
            event.from,
            event.to,
            List<CategorySalesModel>.empty(growable: true),
            List<PaymentMethodSalesModel>.empty(growable: true),
            List<SalesByServiceModel>.empty(growable: true),
            SummaryModel(0, 0, 0, 0, 0, 0, 0, 0),
            List<DiscountModel>.empty(growable: true),
            List<CashierReportDetails>.empty(growable: true)));
        return;
      }
      SummaryModel summary = await connectionRepository!.reportService!.summarySales(event.from, event.to.add(Duration(days: 1)));
      List<SalesByServiceModel> services = await connectionRepository!.reportService!.salesByService(event.from, event.to.add(Duration(days: 1)));
      List<CategorySalesModel> temp = await connectionRepository!.reportService!.categorysales(event.from, event.to.add(Duration(days: 1)));
      List<DiscountModel> discount = await connectionRepository!.reportService!.discountSales(event.from, event.to.add(Duration(days: 1)));
      List<PaymentMethodSalesModel> methods =
          await connectionRepository!.reportService!.paymentMethodsales(event.from, event.to.add(Duration(days: 1)));
      List<CashierReportDetails> shortOver = await connectionRepository!.reportService!.shortOverReport(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesSummaryReport(event.from, event.to, temp, methods, services, summary, discount, shortOver));
    } else if (event is SalesByService) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesByServiceReport(event.from, event.to, List<SalesByServiceModel>.empty(growable: true)));
        return;
      }
      List<SalesByServiceModel> temp = await connectionRepository!.reportService!.salesByService(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesByServiceReport(event.from, event.to, temp));
    } else if (event is SalesByTable) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesByTableReport(event.from, event.to, List<SalesByTableModel>.empty(growable: true)));
        return;
      }
      List<SalesByTableModel> temp = await connectionRepository!.reportService!.salesByTable(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesByTableReport(event.from, event.to, temp));
    } else if (event is SalesBySectionTable) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesByTableReport(event.from, event.to, List<SalesByTableModel>.empty(growable: true)));
        return;
      }
      List<SalesBySectionTableModel> temp =
          await connectionRepository!.reportService!.salesBySectionTable(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesBySectionTableReport(event.from, event.to, temp));
    } else if (event is SalesByItem) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesByItemReport(event.from, event.to, List<SalesByItemModel>.empty(growable: true)));
        return;
      }
      List<SalesByItemModel> temp = await connectionRepository!.reportService!.salesByItem(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesByItemReport(event.from, event.to, temp));
    } else if (event is SalesByCategory) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesByCategoryReport(
            event.from, event.to, List<SalesByCategoryModel>.empty(growable: true), List<OrderTotalDetailsModel>.empty(growable: true)));
        return;
      }
      List<SalesByCategoryModel> temp = await connectionRepository!.reportService!.salesByCategory(event.from, event.to.add(Duration(days: 1)));
      List<OrderTotalDetailsModel> detials = await connectionRepository!.reportService!.orderTotalDetail(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesByCategoryReport(event.from, event.to, temp, detials));
    } else if (event is TaxReport) {
      if (event.from == null || event.to == null) {
        report.sinkValue(Tax(event.from, event.to, List<TaxReportModel>.empty(growable: true)));
        return;
      }
      List<TaxReportModel> temp = await connectionRepository!.reportService!.taxReport(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(Tax(event.from, event.to, temp));
    } else if (event is SalesByEmployee) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesByEmployeeReport(
            event.from, event.to, List<SalesByEmployeeModel>.empty(growable: true), List<OrderTotalDetailsModel>.empty(growable: true)));
        return;
      }
      List<SalesByEmployeeModel> temp = await connectionRepository!.reportService!.salesByEmployee(event.from, event.to.add(Duration(days: 1)));
      List<OrderTotalDetailsModel> details = await connectionRepository!.reportService!.orderTotalDetail(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesByEmployeeReport(event.from, event.to, temp, details));
    } else if (event is DriverSummary) {
      if (event.from == null || event.to == null) {
        report.sinkValue(DriverSummaryReport(event.from, event.to, List<DriverSummaryModel>.empty(growable: true)));
        return;
      }
      List<DriverSummaryModel> temp = await connectionRepository!.reportService!.driverSummary(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(DriverSummaryReport(event.from, event.to, temp));
    } else if (event is VoidReport) {
      if (event.from == null || event.to == null) {
        report.sinkValue(Voidorders(event.from, event.to, List<VoidReportModel>.empty(growable: true)));
        return;
      }
      List<VoidReportModel> temp = await connectionRepository!.reportService!.voidReport(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(Voidorders(event.from, event.to, temp));
    } else if (event is DailySales) {
      if (event.from == null || event.to == null) {
        report.sinkValue(DailySalesReport(event.from, event.to, List<DailySalesModel>.empty(growable: true)));
        return;
      }
      List<DailySalesModel> temp = await connectionRepository!.reportService!.dailySales(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(DailySalesReport(event.from, event.to, temp));
    } else if (event is SalesByHours) {
      if (event.from == null || event.to == null) {
        report.sinkValue(SalesByHoursReport(event.from, event.to, List<SalesByHoursModel>.empty(growable: true)));
        return;
      }
      List<SalesByHoursModel> temp = await connectionRepository!.reportService!.salesByHours(event.from, event.to.add(Duration(days: 1)));
      report.sinkValue(SalesByHoursReport(event.from, event.to, temp));
    }
  }

  @override
  void dispose() {
    _eventController.close();
    report.dispose();
  }
}
