import 'dart:convert';

import 'package:invo_mobile/blocs/back_office/reports/report_page_event.dart';
import 'package:invo_mobile/blocs/invo_connection/invo_connection_bloc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:http/http.dart' as http;

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
import 'package:invo_mobile/repositories/interface/Report/IReportService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportInvoService implements IReportService {
  String? ip;
  String? deviceId;
  Map<String, String>? headers;

  ReportInvoService() {}

  loadPerf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("Invo_IP");
    deviceId = prefs.getString("DeviceID");
    baseUrl = "http://" + "$ip:8081";
    headers = new Map<String, String>();
    headers!["DeviceID"] = deviceId ?? ""; // this.device.uuid
    headers!["Device-Type"] = "1";
    headers!["Content-Type"] = "application/json";
  }

  String baseUrl = "";

  //
  @override
  Future<CashierReportModel?> cashierDetailReport(id) async {
    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/Cashier/Get_CashierReport/" + id.toString()), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      print(json.decode(response.body));
      return CashierReportModel.fromJson(json.decode(response.body));
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  //Get_Cashiers/{date_time}  // YYYY-MM-DD-HH-MM-SS
  @override
  Future<List<CashierModel>?> getCashiers(DateTime dateTime) async {
    await loadPerf();

    String _dateTime = dateTime.year.toString() +
        "-" +
        dateTime.month.toString() +
        "-" +
        dateTime.day.toString() +
        "-" +
        dateTime.hour.toString() +
        "-" +
        dateTime.minute.toString() +
        "-" +
        dateTime.second.toString();
    final response = await http.get(Uri.parse("$baseUrl/Cashier/Get_Cashiers/" + _dateTime.toString()), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }

      List<CashierModel> list = List<CashierModel>.empty(growable: true);
      for (var item in json.decode(response.body)) {
        //print(CashierModel.fromJson(item));
        list.add(CashierModel.fromJson(item));
      }

      return list;

      // If server returns an OK response, parse the JSON.
      // return CashierModel.fromJson(json.decode(response.body));
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  //Reports/DailyClosingReport/{date_time}
  @override
  Future<DailyClosingModel?> closingSalesReport(DateTime dateTime) async {
    await loadPerf();

    String _dateTime = dateTime.year.toString() +
        "-" +
        dateTime.month.toString() +
        "-" +
        dateTime.day.toString() +
        "-" +
        dateTime.hour.toString() +
        "-" +
        dateTime.minute.toString() +
        "-" +
        dateTime.second.toString();
    final response = await http.get(Uri.parse("$baseUrl/Reports/DailyClosingReport/" + _dateTime.toString()), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }

      print(json.decode(response.body));
      return DailyClosingModel.fromJson(json.decode(response.body));

      // If server returns an OK response, parse the JSON.
      // return CashierModel.fromJson(json.decode(response.body));
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  @override
  Future<List<DailySalesModel>> dailySales(DateTime from, DateTime to) {
    // TODO: implement dailySales
    throw UnimplementedError();
  }

  @override
  Future<List<DiscountModel>> discountSales(DateTime from, DateTime to) {
    // TODO: implement discountSales
    throw UnimplementedError();
  }

  @override
  Future<List<DriverSummaryModel>> driverSummary(DateTime from, DateTime to) {
    // TODO: implement driverSummary
    throw UnimplementedError();
  }

  @override
  Future<List<OrderTotalDetailsModel>> orderTotalDetail(DateTime from, DateTime to) {
    // TODO: implement orderTotalDetail
    throw UnimplementedError();
  }

  @override
  Future<List<PaymentMethodSalesModel>> paymentMethodsales(DateTime from, DateTime to) {
    // TODO: implement paymentMethodsales
    throw UnimplementedError();
  }

  @override
  Future<List<SalesByCategoryModel>> salesByCategory(DateTime from, DateTime to) {
    // TODO: implement salesByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<SalesByEmployeeModel>> salesByEmployee(DateTime from, DateTime to) {
    // TODO: implement salesByEmployee
    throw UnimplementedError();
  }

  @override
  Future<List<SalesByHoursModel>> salesByHours(DateTime from, DateTime to) {
    // TODO: implement salesByHours
    throw UnimplementedError();
  }

  @override
  Future<List<SalesByItemModel>> salesByItem(DateTime from, DateTime to) {
    // TODO: implement salesByItem
    throw UnimplementedError();
  }

  @override
  Future<List<SalesBySectionTableModel>> salesBySectionTable(DateTime from, DateTime to) {
    // TODO: implement salesBySectionTable
    throw UnimplementedError();
  }

  @override
  Future<List<SalesByServiceModel>> salesByService(DateTime from, DateTime to) {
    // TODO: implement salesByService
    throw UnimplementedError();
  }

  @override
  Future<List<SalesByTableModel>> salesByTable(DateTime from, DateTime to) {
    // TODO: implement salesByTable
    throw UnimplementedError();
  }

  @override
  Future<SummaryModel> summarySales(DateTime from, DateTime to) {
    // TODO: implement summarySales
    throw UnimplementedError();
  }

  @override
  Future<List<VoidReportModel>> voidReport(DateTime from, DateTime to) {
    // TODO: implement voidReport
    throw UnimplementedError();
  }

  @override
  Future<List<CategorySalesModel>> categorysales(DateTime from, DateTime to) {
    // TODO: implement categorysales
    throw UnimplementedError();
  }

  @override
  Future<DashBoardModel> dashBoardReport(DateTime date) {
    // TODO: implement dashBoardReport
    throw UnimplementedError();
  }

  @override
  Future<List<TaxReportModel>> taxReport(DateTime from, DateTime to) {
    // TODO: implement taxReport
    throw UnimplementedError();
  }

  @override
  Future<List<CashierReportDetails>> shortOverReport(DateTime from, DateTime to) {
    // TODO: implement shortOverReport
    throw UnimplementedError();
  }

  @override
  Future<List<SalesByItemDetails>> salesByItemDetails(DateTime from, DateTime to) {
    // TODO: implement salesByItemDetails
    throw UnimplementedError();
  }

  @override
  Future<List<Orderly>> hourlyOrderList(DateTime from, DateTime to, hour) {
    // TODO: implement hourlyOrderList
    throw UnimplementedError();
  }

  @override
  Future<List<Orderly>> dailyOrderList(DateTime from, DateTime to) {
    // TODO: implement dailyOrderList
    throw UnimplementedError();
  }
}
