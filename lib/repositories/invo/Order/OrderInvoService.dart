import 'dart:convert';
import 'dart:io';

import 'package:invo_mobile/models/custom/direct_settle.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/order_payment.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/pending_status.dart';
import 'package:invo_mobile/models/service_order.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/repositories/interface/Order/IOrderService.dart';
import 'package:http/http.dart' as http;
import 'package:invo_mobile/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderInvoService implements IOrderService {
  late String ip;
  late String deviceId;
  late Map<String, String> headers;
  loadPerf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("Invo_IP")!;
    deviceId = prefs.getString("DeviceID")!;
    baseUrl = "http://" + "$ip:8081";
    headers = new Map<String, String>();
    headers["DeviceID"] = deviceId; // this.device.uuid
    headers["Device-Type"] = "1";
    headers["Content-Type"] = "application/json";
  }

  String baseUrl = "";

  @override
  Future<bool> discountOrder(OrderHeader order, Discount discount, int employeeId) async {
    await loadPerf();
    var json = <String, dynamic>{
      "orderId": order.id,
      "discount_id": (discount != null) ? discount.id : 0,
      "discount_amount": (discount != null) ? discount.amount : 0,
      "discount_percentage": (discount != null) ? (discount.is_percentage == null ? false : discount.is_percentage) : false,
      "grand_price": order.grand_price,
      "sub_total_price": order.sub_total_price,
      "discount_actual_amount": order.discount_actual_amount,
      "surcharge_actual_amount": order.surcharge_actual_amount,
      "Rounding": order.Rounding,
      "total_tax": order.total_tax,
      "total_tax2": order.total_tax2,
      "total_tax3": order.total_tax3,
      "employee_id": employeeId
    };

    final response = await http
        .post(Uri.parse("$baseUrl/Order/DirectDiscount"), body: jsonEncode(json), headers: this.headers)
        .timeout(Duration(seconds: 10))
        .catchError((error) {
      print(error);
    });

    if (response == null) {
      return false;
    }
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }

      if (response.body == "false")
        return false;
      else
        return true;

      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  @override
  Future<OrderHeader> fetchFullOrder(int orderId) {
    // TODO: implement fetchFullOrder
    throw UnimplementedError();
  }

  @override
  Future<OrderHeader?> fetchFullPendingOrder(int orderId) {
    throw UnimplementedError();
  }

  DateTime addOpeningHours(DateTime dateTime) {
    DateTime? dayStart = locator.get<ConnectionRepository>().preference!.day_start;
    int hour = 5;
    int minute = 0;
    int second = 0;
    if (dayStart != null) {
      hour = dayStart.hour;
      minute = dayStart.minute;
      second = dayStart.second;
    }
    DateTime _date = dateTime;
    _date = _date.add(Duration(hours: -_date.hour + hour));
    _date = _date.add(Duration(minutes: -_date.minute + minute));
    _date = _date.add(Duration(seconds: -_date.second + second));
    return _date;
  }

  String dateToString(DateTime dateTime) {
    String _date = dateTime.year.toString() +
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
    return _date;
  }

  //OpenOrders/Mini/All/{start_date}/{end_date}/{service}/{status}/{SearchText}
  @override
  Future<List<MiniOrder>?> fetchAllOrders(DateTime startDate, DateTime endDate, String searchText, int service, int status) async {
    await loadPerf();
    DateTime _startDate = addOpeningHours(startDate);
    DateTime _endDate = addOpeningHours(endDate);

    String _dateStart = dateToString(_startDate);
    String _dateEnd = dateToString(_endDate.add(Duration(days: 1)));
    if (searchText == "") searchText = "0";

    print("$baseUrl/Order/OpenOrders/Mini/All/" +
        _dateStart +
        "/" +
        _dateEnd +
        "/" +
        service.toString() +
        "/" +
        status.toString() +
        "/" +
        searchText +
        "");

    final response = await http.get(
        Uri.parse("$baseUrl/Order/OpenOrders/Mini/All/" +
            _dateStart +
            "/" +
            _dateEnd +
            "/" +
            service.toString() +
            "/" +
            status.toString() +
            "/" +
            searchText +
            ""),
        headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return null;
      }
      // If server returns an OK response, parse the JSON.
      List<MiniOrder> list = List<MiniOrder>.empty(growable: true);

      for (var item in json.decode(response.body)) {
        list.add(MiniOrder.fromJson(item));
      }

      return list;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return null;
    }
  }

  @override
  Future<List<MiniOrder>> fetchServiceOrder(int serviceId) {
    // TODO: implement fetchServiceOrder
    throw UnimplementedError();
  }

  @override
  Future<int>? fetchTodayOrdersCount(DateTime startDate, DateTime endDate) {}

  @override
  void removePendingOrder(int id) {}

  @override
  void rejectPendingOrder(String order_GUID, int pendingId) {}
  @override
  void acceptPendingOrder(String orderGUID, int id, int ticket_number) {}
  @override
  Future<List<MiniOrder>?>? fetchPendingOrders() async {}

  @override
  Future<List<MiniOrder>?>? fetchServicePaidOrders(int serviceId, DateTime _date) async {
    try {
      final response = await http
          .get(
              Uri.parse("$baseUrl/Order/SetteledOrders/mini/all/" +
                  serviceId.toString() +
                  "/" +
                  _date.year.toString() +
                  "-" +
                  _date.month.toString() +
                  "-" +
                  _date.day.toString()),
              headers: this.headers)
          .timeout(Duration(seconds: 10))
          .catchError((error) {
        print(error);
      });

      if (response == null) {
        return List<MiniOrder>.empty(growable: true);
      }

      if (response.statusCode == 200) {
        if (response.body == "") {
          return List<MiniOrder>.empty(growable: true);
        }
        // If server returns an OK response, parse the JSON.
        List<MiniOrder> list = List<MiniOrder>.empty(growable: true);

        for (var item in json.decode(response.body)) {
          list.add(MiniOrder.fromJson(item));
        }
        return list;
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return List<MiniOrder>.empty(growable: true);
      }
    } on SocketException {
      return null;
    }

    return null;
  }

  @override
  Future<List<ServiceOrder>> fetchServicesOrders() {
    // TODO: implement fetchServicesOrders
    throw UnimplementedError();
  }

  @override
  Future<List<OrderHeader>> loadOrders(int tableId) {
    // TODO: implement loadOrders
    throw UnimplementedError();
  }

  //Order/DirectSettle POST
  @override
  Future<bool> payOrder(OrderHeader order, bool complete) async {
    await loadPerf();
    DirectSettle directSettle = new DirectSettle();

    directSettle.payments = order.payments;
    directSettle.is_Completed = complete;
    print(jsonEncode(directSettle.toMap()));

    final response = await http.post(Uri.parse("$baseUrl/Order/DirectSettle"), body: jsonEncode(directSettle.toMap()), headers: this.headers);

    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.
      return true;
      // return true;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  @override
  Future<OrderHeader> saveOrder(OrderHeader order) {
    // TODO: implement saveOrder
    throw UnimplementedError();
  }

  @override
  Future<OrderHeader> savePendingOrder(OrderHeader order) {
    // TODO: implement saveOrder
    throw UnimplementedError();
  }

  @override
  Future<List<PendingStatus>> getPendingStatus() {
    throw UnimplementedError();
  }

  @override
  void updatePendingStatus(List<PendingStatus> pendingStatus) {}

  @override
  Future<OrderHeader>? getByGUID(String GUID) {}

  @override
  Future<List<OrderHeader>> saveOrders(List<OrderHeader> orders) {
    // TODO: implement saveOrders
    throw UnimplementedError();
  }

  @override
  Future<bool> surchargeOrder(OrderHeader order, Surcharge surcharge) async {
    await loadPerf();
    var json = <String, dynamic>{
      "orderId": order.id,
      "surcharge_id": (surcharge != null) ? surcharge.id : 0,
      "surcharge_amount": (surcharge != null) ? surcharge.amount : 0,
      "surcharge_percentage": (surcharge != null) ? (surcharge.is_percentage == null ? false : surcharge.is_percentage) : false,
      "grand_price": order.grand_price,
      "surcharge_apply_tax1": (surcharge != null) ? surcharge.apply_tax1 : false,
      "surcharge_apply_tax2": (surcharge != null) ? surcharge.apply_tax2 : false,
      "surcharge_apply_tax3": (surcharge != null) ? surcharge.apply_tax3 : false,
      "sub_total_price": order.sub_total_price,
      "surcharge_actual_amount": order.surcharge_actual_amount,
      "Rounding": order.Rounding,
      "total_tax": order.total_tax,
      "total_tax2": order.total_tax2,
      "total_tax3": order.total_tax3,
    };

    final response = await http
        .post(Uri.parse("$baseUrl/Order/DirectSurcharge"), body: jsonEncode(json), headers: this.headers)
        .timeout(Duration(seconds: 10))
        .catchError((error) {
      print(error);
    });

    if (response == null) {
      return false;
    }
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }

      if (response.body == "false")
        return false;
      else
        return true;

      // If server returns an OK response, parse the JSON.
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
  }

  @override
  void updatePrintedItem(OrderHeader order) {
    // TODO: implement updatePrintedItem
  }

  @override
  Future<bool> voidOrder(OrderHeader order, int employeeId, String reason, bool waste) async {
    await loadPerf();
    var json = <String, dynamic>{
      "order_id": order.id,
      "status": order.status,
      "employee_id": employeeId,
      "reason": reason,
      "grand_price": order.grand_price,
      "waste": waste,
    };

    try {
      final response = await http
          .post(Uri.parse("$baseUrl/Order/VoidOrder"), body: jsonEncode(json), headers: this.headers)
          .timeout(Duration(seconds: 10))
          .catchError((error) {
        print(error);
      });

      if (response == null) {
        return false;
      }
      if (response.statusCode == 200) {
        if (response.body == "") {
          return false;
        }

        if (response.body == "false")
          return false;
        else
          return true;

        // If server returns an OK response, parse the JSON.
      } else {
        print("error");
        // If that response was not OK, throw an error.
        // throw Exception('Failed to load post');
        return false;
      }
    } on SocketException {
      return false;
    }
  }

//Order/isSettled/{guid} get
  @override
  Future<bool> isSettled(guid) async {
    await loadPerf();
    final response = await http.get(Uri.parse("$baseUrl/Order/isSettled/" + guid.toString()), headers: this.headers);
    if (response.statusCode == 200) {
      if (response.body == "") {
        return false;
      }
      // If server returns an OK response, parse the JSON.

      if (response.body == "true")
        return true;
      else if (response.body == "false") return false;
    } else {
      print("error");
      // If that response was not OK, throw an error.
      // throw Exception('Failed to load post');
      return false;
    }
    return false;
  }
}
