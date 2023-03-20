import 'dart:convert';

import 'package:invo_mobile/models/custom/cloud_request.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';
import 'package:invo_mobile/models/reports/SalesByServiceModel.dart';
import 'package:invo_mobile/models/reports/SalesSummaryModels.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ReportCloud {
  Future<bool> dailyClosingReportRequest(CloudRequest request, Socket websocket) async {
    DateTime date = DateTime.parse(request.param);
    dynamic list = await locator.get<ConnectionRepository>().reportService!.closingSalesReport(date);
    if (list != null) {
      Map<String, dynamic> result = new Map<String, dynamic>();
      result = list.toMapRequest();

      print(jsonEncode(result).toString());

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> getCashiers(CloudRequest request, Socket websocket) async {
    DateTime date = DateTime.parse(request.param);
    List<CashierModel>? list = await locator.get<ConnectionRepository>().reportService!.getCashiers(date);
    if (list!.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      for (var element in list) {
        result.add(element.toMap());
      }

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> cashierReportRequest(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param.toString());
    dynamic list = await locator.get<ConnectionRepository>().reportService!.cashierDetailReport(id);
    if (list != null) {
      Map<String, dynamic> result = Map<String, dynamic>();
      result = list.toMapRequest();

      print(jsonEncode(result).toString());

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> fetchFullOrderRequest(CloudRequest request, Socket websocket) async {
    int id = int.parse(request.param.toString());
    dynamic list = await locator.get<ConnectionRepository>().orderService!.fetchFullOrder(id);
    if (list != null) {
      Map<String, dynamic> result = new Map<String, dynamic>();
      result = list.toMapRequest();

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> salesSummary(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);

    dynamic connectionRepository = await locator.get<ConnectionRepository>();
    SummaryModel summary = await connectionRepository.reportService.summarySales(from, to.add(Duration(days: 1)));
    List<SalesByServiceModel> services = await connectionRepository.reportService.salesByService(from, to.add(Duration(days: 1)));
    List<CategorySalesModel> temp = await connectionRepository.reportService.categorysales(from, to.add(Duration(days: 1)));

    List<PaymentMethodSalesModel> methods = await connectionRepository.reportService.paymentMethodsales(from, to.add(Duration(days: 1)));
    List<CashierReportDetails> shortOver = await connectionRepository.reportService.shortOverReport(from, to.add(Duration(days: 1)));
    if (summary != null) {
      Map<String, dynamic> resultSummary = summary.toMapRequest();
      List<Map<String, dynamic>> resultCategory = List<Map<String, dynamic>>.empty(growable: true);
      temp.forEach((element) {
        resultCategory.add(element.toMapRequest());
      });
      List<Map<String, dynamic>> resultServices = List<Map<String, dynamic>>.empty(growable: true);
      services.forEach((element) {
        resultServices.add(element.toMapRequest());
      });
      List<Map<String, dynamic>> resultShortOver = List<Map<String, dynamic>>.empty(growable: true);
      shortOver.forEach((element) {
        resultShortOver.add(element.toMapRequest());
      });
      List<Map<String, dynamic>> resultTenders = List<Map<String, dynamic>>.empty(growable: true);
      methods.forEach((element) {
        resultTenders.add(element.toMapRequest());
      });

      var map = <String, dynamic>{
        'categorySales': resultCategory,
        'saleSummary': resultSummary,
        'serviceSales': resultServices,
        'shortOverReport': resultShortOver,
        'tenderSales': resultTenders
      };

      print(jsonEncode(map).toString());
      request.data = jsonEncode(map).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> dailySaleReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.dailySales(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> hourlySaleReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.salesByHours(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> hourlyOrderListReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    String hour = dates['search'];
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.hourlyOrderList(from, to.add(Duration(days: 1)), hour);
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> dailyOrderListReport(CloudRequest request, Socket websocket) async {
    DateTime from = DateTime.parse(request.param);
    DateTime to = DateTime.parse(request.param);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.dailyOrderList(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> salesByServiceReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.salesByService(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> salesByTableReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.salesByTable(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> salesByTableGroupReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.salesBySectionTable(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> salesByItemsReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.salesByItem(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> sales = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        sales.add(element.toMapRequest());
      });
      List<dynamic> detailList = await locator.get<ConnectionRepository>().reportService!.salesByItemDetails(from, to);
      List<Map<String, dynamic>> details = List<Map<String, dynamic>>.empty(growable: true);
      detailList.forEach((element) {
        details.add(element.toMapRequest());
      });
      var map = <String, dynamic>{
        'sales': sales,
        'details': details,
      };

      print(jsonEncode(map).toString());
      request.data = jsonEncode(map).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> salesByCategoryReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.salesByCategory(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> sales = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        sales.add(element.toMapRequest());
      });
      List<dynamic> detailList = await locator.get<ConnectionRepository>().reportService!.orderTotalDetail(from, to);
      List<Map<String, dynamic>> details = List<Map<String, dynamic>>.empty(growable: true);
      detailList.forEach((element) {
        details.add(element.toMapRequest());
      });
      var map = <String, dynamic>{
        'sales': sales,
        'details': details,
      };

      print(jsonEncode(map).toString());
      request.data = jsonEncode(map).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> taxReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.taxReport(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> salesByEmployeeReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.salesByEmployee(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> sales = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        sales.add(element.toMapRequest());
      });
      List<dynamic> detailList = await locator.get<ConnectionRepository>().reportService!.orderTotalDetail(from, to);
      List<Map<String, dynamic>> details = List<Map<String, dynamic>>.empty(growable: true);
      detailList.forEach((element) {
        details.add(element.toMapRequest());
      });
      var map = <String, dynamic>{
        'sales': sales,
        'details': details,
      };

      print(jsonEncode(map).toString());
      request.data = jsonEncode(map).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> driverReportSummaryReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.driverSummary(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      print(jsonEncode(result).toString());
      request.data = jsonEncode(result).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }

  Future<bool> voidReport(CloudRequest request, Socket websocket) async {
    Map dates = json.decode(request.param);
    DateTime from = DateTime.parse(dates['from']);
    DateTime to = DateTime.parse(dates['to']);
    List<dynamic> list = await locator.get<ConnectionRepository>().reportService!.voidReport(from, to.add(Duration(days: 1)));
    if (list.isNotEmpty) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.empty(growable: true);
      list.forEach((element) {
        result.add(element.toMapRequest());
      });

      var map = <String, dynamic>{
        'VoidOrders': result,
        'VoidItems': result,
      };
      print(jsonEncode(map).toString());
      request.data = jsonEncode(map).toString();
      websocket.emit("response", jsonEncode(request.toJson()));
      return true;
    } else {
      request.data = '[]';
      websocket.emit("response", jsonEncode(request.toJson()));
      return false;
    }
  }
}
