import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/CashierReportModel.dart';

class DailyClosingModel {
  double total_sale;
  double item_discount;
  double total_account;
  double total_void;
  double total;
  double total_charge_per_hour;
  double total_minimum_charge;
  double total_delivery_charge;
  double total_discount_amount;
  double total_surcharge_amount;
  double total_tax;
  double total_tax2;
  double total_tax3;
  double total_payOut;
  int totalGuests;
  int total_transaction;
  int total_order;
  double total_rounding;
  String? tax1_alias;
  String? tax2_alias;
  String? tax3_alias;

  List<SalesService> serviceReports;
  List<OpenOrder> openOrders;
  List<OpenCashier> openCashiers;
  List<CashierReportModel> cashierReports;
  List<CategoryReport> categoryReports;
  List<SalesByTender> tenderReports;

  DailyClosingModel({
    this.total_sale = 0,
    this.item_discount = 0,
    this.total_account = 0,
    this.total_void = 0,
    this.total = 0,
    this.total_charge_per_hour = 0,
    this.total_minimum_charge = 0,
    this.total_delivery_charge = 0,
    this.total_discount_amount = 0,
    this.total_surcharge_amount = 0,
    this.total_tax = 0,
    this.total_tax2 = 0,
    this.total_tax3 = 0,
    this.total_payOut = 0,
    this.totalGuests = 1,
    this.total_transaction = 0,
    this.total_order = 0,
    this.total_rounding = 0,
    this.tax1_alias = "",
    this.tax2_alias = "",
    this.tax3_alias = "",
    required this.serviceReports,
    required this.openOrders,
    required this.openCashiers,
    required this.cashierReports,
    required this.categoryReports,
    required this.tenderReports,
  });
  factory DailyClosingModel.fromJson(Map<String, dynamic> json) {
    List<SalesService> _serviceReports = List<SalesService>.empty(growable: true);
    if (json.containsKey('ServiceReports') && json['ServiceReports'] != null)
      for (var item in json['ServiceReports']) {
        _serviceReports.add(SalesService.fromJson(item));
      }

    List<OpenOrder> _openOrders = new List<OpenOrder>.empty(growable: true);
    if (json.containsKey('OpenOrders') && json['OpenOrders'] != null)
      for (var item in json['OpenOrders']) {
        _openOrders.add(OpenOrder.fromJson(item));
      }

    List<OpenCashier> _openCashiers = new List<OpenCashier>.empty(growable: true);
    if (json.containsKey('OpenCashiers') && json['OpenCashiers'] != null)
      for (var item in json['OpenCashiers']) {
        _openCashiers.add(OpenCashier.fromJson(item));
      }

    List<CashierReportModel> _cashierReports = new List<CashierReportModel>.empty(growable: true);
    if (json.containsKey('CashierReports') && json['CashierReports'] != null)
      for (var item in json['CashierReports']) {
        _cashierReports.add(CashierReportModel.fromJson(item));
      }

    List<CategoryReport> _categoryReports = new List<CategoryReport>.empty(growable: true);
    if (json.containsKey('CategoryReports') && json['CategoryReports'] != null)
      for (var item in json['CategoryReports']) {
        _categoryReports.add(CategoryReport.fromJson(item));
      }

    List<SalesByTender> _tenderReports = new List<SalesByTender>.empty(growable: true);
    if (json.containsKey('TenderReports') && json['TenderReports'] != null)
      for (var item in json['TenderReports']) {
        _tenderReports.add(SalesByTender.fromJson(item));
      }

    return DailyClosingModel(
        total_sale: json['Total_Sale'] != null ? double.parse(json['Total_Sale'].toString()) : 0.0,
        item_discount: json['item_discount'] ?? 0,
        total_account: json['total_account'] != null ? double.parse(json['total_account'].toString()) : 0.0,
        total_void: json['Total_Void'] != null ? double.parse(json['Total_Void'].toString()) : 0.0,
        total: json['Total'] != null ? double.parse(json['Total'].toString()) : 0.0,
        total_charge_per_hour: json['Total_charge_per_hour'] != null ? double.parse(json['Total_charge_per_hour'].toString()) : 0.0,
        total_minimum_charge: json['Total_minimum_charge'] != null ? double.parse(json['Total_minimum_charge'].toString()) : 0.0,
        total_delivery_charge: json['Total_delivery_charge'] != null ? double.parse(json['Total_delivery_charge'].toString()) : 0.0,
        total_discount_amount: json['Total_discount_amount'] != null ? double.parse(json['Total_discount_amount'].toString()) : 0.0,
        total_surcharge_amount: json['Total_surcharge_amount'] != null ? double.parse(json['Total_surcharge_amount'].toString()) : 0.0,
        total_tax: json['Total_tax'] != null ? double.parse(json['Total_tax'].toString()) : 0.0,
        total_tax2: json['Total_tax2'] != null ? double.parse(json['Total_tax2'].toString()) : 0.0,
        total_tax3: json['Total_tax3'] != null ? double.parse(json['Total_tax3'].toString()) : 0.0,
        total_payOut: json['total_payOut'] != null ? double.parse(json['total_payOut'].toString()) : 0.0,
        totalGuests: json['TotalGuests'] ?? 1,
        total_transaction: json['total_transaction'],
        total_order: json['total_order'],
        total_rounding: json['total_rounding'] != null ? double.parse(json['total_rounding'].toString()) : 0.0,
        tax1_alias: json['tax1_alias'] ?? "",
        tax2_alias: json['tax2_alias'] ?? "",
        tax3_alias: json['tax3_alias'] ?? "",
        categoryReports: _categoryReports,
        serviceReports: _serviceReports,
        cashierReports: _cashierReports,
        openOrders: _openOrders,
        openCashiers: _openCashiers,
        tenderReports: _tenderReports);
  }
  factory DailyClosingModel.fromMap(Map<String, dynamic> map) {
    DailyClosingModel dailyClosingModel = DailyClosingModel(
        serviceReports: List<SalesService>.empty(growable: true),
        openOrders: List<OpenOrder>.empty(growable: true),
        openCashiers: List<OpenCashier>.empty(growable: true),
        cashierReports: List<CashierReportModel>.empty(growable: true),
        categoryReports: List<CategoryReport>.empty(growable: true),
        tenderReports: List<SalesByTender>.empty(growable: true));

    dailyClosingModel.total_sale = map['Total_Sale'] ?? 0;
    dailyClosingModel.item_discount = map['item_discount'] ?? 0;
    dailyClosingModel.total_account = map['total_account'] ?? 0;
    dailyClosingModel.total_void = map['Total_Void'] == null ? 0 : map['Total_Sale'];
    dailyClosingModel.total = map['Total'] ?? 0;
    dailyClosingModel.total_charge_per_hour = map['Total_charge_per_hour'] ?? 0;
    dailyClosingModel.total_minimum_charge = map['Total_minimum_charge'] ?? 0;
    dailyClosingModel.total_delivery_charge = map['Total_delivery_charge'] ?? 0;
    dailyClosingModel.total_discount_amount = map['Total_discount_amount'] ?? 0;
    dailyClosingModel.total_surcharge_amount = map['Total_surcharge_amount'] ?? 0;
    dailyClosingModel.total_tax = map['Total_tax'] ?? 0;
    dailyClosingModel.total_tax2 = map['Total_tax2'] ?? 0;
    dailyClosingModel.total_tax3 = map['Total_tax3'] ?? 0;
    dailyClosingModel.total_payOut = map['total_payOut'] ?? 0;
    dailyClosingModel.totalGuests = map['totalGuests'] ?? 0;
    dailyClosingModel.total_transaction = map['total_transaction'] ?? 0;
    dailyClosingModel.total_order = map['total_order'] ?? 0;
    dailyClosingModel.total_rounding = map['total_rounding'] ?? 0;
    dailyClosingModel.tax1_alias = map['tax1_alias'];
    dailyClosingModel.tax2_alias = map['tax2_alias'];
    dailyClosingModel.tax3_alias = map['tax3_alias'];
    // totalGuests = map['totalGuests'] == null ? 0 : map['totalGuests'];
    dailyClosingModel.serviceReports = List<SalesService>.empty(growable: true);
    dailyClosingModel.openOrders = List<OpenOrder>.empty(growable: true);
    dailyClosingModel.openCashiers = List<OpenCashier>.empty(growable: true);
    dailyClosingModel.cashierReports = List<CashierReportModel>.empty(growable: true);
    dailyClosingModel.categoryReports = List<CategoryReport>.empty(growable: true);
    dailyClosingModel.tenderReports = List<SalesByTender>.empty(growable: true);

    return dailyClosingModel;
  }

  Map<String, dynamic> toMapRequest() {
    List<Map<String, dynamic>>? _categoryReports = this.categoryReports != null ? this.categoryReports.map((i) => i.toMap()).toList() : null;

    List<Map<String, dynamic>>? _serviceReports = this.serviceReports != null ? this.serviceReports.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _openOrders = this.openOrders != null ? this.openOrders.map((i) => i.toMap()).toList() : null;

    List<Map<String, dynamic>>? _openCashiers = this.openCashiers != null ? this.openCashiers.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _tenderReports = this.tenderReports != null ? this.tenderReports.map((i) => i.toMap()).toList() : null;

    List<Map<String, dynamic>>? _cashierReports = this.cashierReports != null ? this.cashierReports.map((i) => i.toMapRequest()).toList() : null;

    var map = <String, dynamic>{
      'Total_Sale': total_sale,
      'item_discount': item_discount,
      'Account_total': total_account,
      'Total_Void': total_void,
      'Total': total,
      'charge_per_hour_total': total_charge_per_hour,
      'minimum_charge_total': total_minimum_charge,
      'Total_delivery_charge': total_delivery_charge,
      'Total_discount_amount': total_discount_amount,
      'Total_surcharge_amount': total_surcharge_amount,
      'total_tax': total_tax,
      'total_tax2': total_tax2,
      'total_tax3': total_tax3,
      'Total_PayOut': total_payOut,
      'TotalGuests': totalGuests,
      'total_transaction': total_transaction,
      'total_order': total_order,
      'total_rounding': total_rounding,
      'tax1_alias': tax1_alias,
      'tax2_alias': tax2_alias,
      'tax3_alias': tax3_alias,
      'CategoryReports': _categoryReports,
      'ServiceReports': _serviceReports,
      'CashierReports': _cashierReports,
      'OpenOrders': _openOrders,
      'OpenCashiers': _openCashiers,
      'TenderReports': _tenderReports
    };

    return map;
  }

  double get total_tender_sales {
    double result = 0;
    if (tenderReports.isNotEmpty) {
      tenderReports.forEach((element) {
        if (element.total != null) result += element.total!;
      });
    }

    return result;
  }

  double get total_category_sales {
    double result = 0;
    if (categoryReports.length > 0) {
      categoryReports.forEach((element) {
        if (element.total != null) result += element.total!;
      });
    }

    return result;
  }

  double get total_service_sales {
    double result = 0;
    if (this.serviceReports != null) {
      this.serviceReports.forEach((element) {
        if (element.total != null) result += element.total!;
      });
    }

    return result;
  }

  double? get item_Sale_total_No_Discount {
    {
      if (total_sale != null && item_discount != null)
        return total_sale - item_discount;
      else if (total_sale != null)
        return total_sale;
      else
        return 0;
    }
  }
}

class OpenOrder {
  int? id;
  DateTime? date_time;
  //service name
  String name;
  double grand_price;

  //service alternative
  String alternative;
  String? get serivce_name {
    {
      if (alternative.isEmpty) {
        return name;
      }
      return alternative;
    }
  }

  OpenOrder({
    required this.id,
    this.name = "",
    this.alternative = "",
    this.date_time,
    required this.grand_price,
  });
  factory OpenOrder.fromJson(Map<String, dynamic> json) {
    DateTime _date_time = DateTime.fromMillisecondsSinceEpoch(int.parse(json['date_time'].substring(6, json['date_time'].length - 7)));
    return OpenOrder(
      id: json['id'],
      name: json['name'],
      alternative: json['alternative'],
      date_time: _date_time,
      grand_price: json['grand_price'] != null ? double.parse(json['grand_price'].toString()) : 0.0,
    );
  }

  factory OpenOrder.fromMap(Map<String, dynamic> map) {
    return OpenOrder(
        id: map['id'],
        name: map['name'],
        alternative: map['alternative'],
        grand_price: map['grand_price'],
        date_time: map['date_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['date_time']));
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date_time': (date_time == null) ? null : "/Date(" + (date_time?.millisecondsSinceEpoch).toString() + ")/",
      'name': name,
      'grand_price': grand_price,
      'alternative': alternative
    };
    return map;
  }
}

class OpenCashier {
  int? id;
  String? name;
  int? computer_id;

  OpenCashier({this.id, this.name, this.computer_id});
  factory OpenCashier.fromJson(Map<String, dynamic> json) {
    return OpenCashier(
      id: json['id'],
      name: json['name'],
      computer_id: json['computer_id'],
    );
  }

  OpenCashier.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    computer_id = map['computer_id'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name, 'computer_id': computer_id};
    return map;
  }
}

class SalesService {
  String? service_name;
  // num? total;
  double? total;

  SalesService({
    this.service_name,
    this.total,
  });

  factory SalesService.fromJson(Map<String, dynamic> json) {
    return SalesService(
      service_name: json['service_name'],
      total: json['total'] != null ? double.parse(json['total'].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'service_name': service_name,
      'total': total,
    };
    return map;
  }

  SalesService.fromMap(Map<String, dynamic> map) {
    service_name = map['service_name'];
    total = map['total'] ?? 0;
  }
}

class SalesByTender {
  String? payment_method;
  int? payment_method_id;
  double? total;

  // num? total;
  SalesByTender({this.payment_method, this.total, this.payment_method_id});

  factory SalesByTender.fromJson(Map<String, dynamic> json) {
    return SalesByTender(
      payment_method_id: json['Payment_method_id'],
      payment_method: json['Payment_method'],
      total: json['total'] != null ? double.parse(json['total'].toString()) : 0.0,
    );
  }
  SalesByTender.fromMap(Map<String, dynamic> map) {
    payment_method = map['Payment_method'];
    payment_method_id = map['Payment_method_id'];
    total = map['total'] ?? 0;
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'Payment_method': payment_method,
      'payment_method_id': payment_method_id,
      'total': total ?? 0.0,
    };
    return map;
  }
}

class CategoryReport {
  String? category_name;
  double? total;

  CategoryReport({this.category_name, this.total});

  factory CategoryReport.fromJson(Map<String, dynamic> json) {
    return CategoryReport(
      category_name: json['category_name'] ?? 'Other',
      total: json['total'] != null ? double.parse(json['total'].toString()) : 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'category_name': category_name ?? 'Other',
      'total': total,
    };
    return map;
  }

  CategoryReport.fromMap(Map<String, dynamic> map) {
    category_name = map['category_name'] ?? 'Other';
    total = map['total'] ?? 0;
  }
}
