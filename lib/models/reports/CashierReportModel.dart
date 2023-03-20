// ignore_for_file: unnecessary_this, prefer_null_aware_operators

import 'dart:core';
import 'dart:math';

import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/reports/SalesSummaryModels.dart';
import 'package:collection/collection.dart';

class CashierReportModel {
  int id;
  String name;
  int employee_id;
  DateTime? cashier_in;
  DateTime? cashier_out;
  String approvedBy;
  double start_amount;
  int total_Transactions;
  double account_Payment;
  double total_Sale;
  double payOut_total;
  double extra_cash;
  int terminal_id;
  OrdersDetails? ordersDetails;
  double count = 0;

  List<CategoryCashier> categoryReports = [];
  List<CashierReportDetails> details = [];
  List<CashierReportDetails> credit_payments = [];

  List<LocalCurrencys> local_currency = [];
  List<ForigenCurrencys> forignCurrency = [];
  List<OtherTenders> other_tenders = [];

  CashierReportModel(
      {this.id = 0,
      this.name = "",
      this.cashier_in,
      this.cashier_out,
      this.approvedBy = "",
      this.start_amount = 0,
      this.total_Transactions = 0,
      this.account_Payment = 0,
      this.total_Sale = 0,
      this.payOut_total = 0,
      this.extra_cash = 0,
      this.ordersDetails,
      this.terminal_id = 0,
      this.employee_id = 0,
      required this.categoryReports,
      required this.details,
      required this.credit_payments,
      required this.local_currency,
      required this.forignCurrency,
      required this.other_tenders,
      this.count = 0});

  factory CashierReportModel.fromJson(Map<String, dynamic> json) {
    DateTime _cashier_in = DateTime.fromMillisecondsSinceEpoch(int.parse(json['cashier_in'].substring(6, json['cashier_in'].length - 7)));
    DateTime? _cashier_out = json['cashier_out'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(int.parse(json['cashier_out'].substring(6, json['cashier_out'].length - 7)));
    double _start_amount = double.parse(json['start_amount'].toString());
    List<CategoryCashier> _categoryReports = List<CategoryCashier>.empty(growable: true);
    if (json.containsKey('CategoryReports') && json['CategoryReports'] != null)
      for (var item in json['CategoryReports']) {
        _categoryReports.add(CategoryCashier.fromJson(item));
      }

    List<CashierReportDetails> _details = List<CashierReportDetails>.empty(growable: true);
    if (json.containsKey('details') && json['details'] != null)
      for (var item in json['details']) {
        _details.add(CashierReportDetails.fromJson(item));
      }

    List<CashierReportDetails> _credit_payments = List<CashierReportDetails>.empty(growable: true);
    if (json.containsKey('credit_payments') && json['credit_payments'] != null)
      for (var item in json['credit_payments']) {
        _credit_payments.add(CashierReportDetails.fromJson(item));
      }

    List<LocalCurrencys> _local_currency = List<LocalCurrencys>.empty(growable: true);
    if (json.containsKey('Local_currency') && json['Local_currency'] != null) {
      for (var item in json['Local_currency']) {
        _local_currency.add(LocalCurrencys.fromJson(item));
      }
    }

    List<ForigenCurrencys> _forign_currency = List<ForigenCurrencys>.empty(growable: true);
    if (json.containsKey('Forign_currency') && json['Forign_currency'] != null) {
      for (var item in json['Forign_currency']) {
        _forign_currency.add(ForigenCurrencys.fromJson(item));
      }
    }

    List<OtherTenders> _other_tenders = List<OtherTenders>.empty(growable: true);
    if (json.containsKey('Other_tenders') && json['Other_tenders'] != null) {
      for (var item in json['Other_tenders']) {
        _other_tenders.add(OtherTenders.fromJson(item));
      }
    }

    OrdersDetails _ordersDetails = OrdersDetails();
    if (json.containsKey('ordersDetails') && json['ordersDetails'] != null) {
      _ordersDetails = OrdersDetails.fromJson(json['ordersDetails']);
    }
    return CashierReportModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      cashier_in: _cashier_in,
      cashier_out: _cashier_out,
      approvedBy: json['approvedBy'] ?? "",
      start_amount: _start_amount,
      total_Transactions: json['Total_Transactions'] != null ? int.parse(json['Total_Transactions'].toString()) : 0,
      account_Payment: json['Account_Payment'] != null ? double.parse(json['Account_Payment'].toString()) : 0.0,
      total_Sale: json['Total_Sale'] != null ? double.parse(json['Total_Sale'].toString()) : 0.0,
      payOut_total: json['PayOut_Total'] != null ? double.parse(json['PayOut_Total'].toString()) : 0.0,
      extra_cash: json['Extra_Cash'] != null ? double.parse(json['Extra_Cash'].toString()) : 0.0,
      terminal_id: json['terminal_id'] ?? 0,
      employee_id: json['employee_id'] ?? 0,
      categoryReports: _categoryReports,
      details: _details,
      credit_payments: _credit_payments,
      local_currency: _local_currency,
      forignCurrency: _forign_currency,
      other_tenders: _other_tenders,
      ordersDetails: _ordersDetails,
    );
  }
  Map<String, dynamic> toMapRequest() {
    List<Map<String, dynamic>>? _categoryReports = this.categoryReports != null ? this.categoryReports.map((i) => i.toMap()).toList() : null;

    List<Map<String, dynamic>>? _details = this.details.map((i) => i.toMap()).toList();
    List<Map<String, dynamic>>? _credit_payments = this.credit_payments.map((i) => i.toMap()).toList();
    List<Map<String, dynamic>>? _local_currency = this.local_currency.map((i) => i.toMap()).toList();
    List<Map<String, dynamic>>? _forign_currency = this.forignCurrency.map((i) => i.toMap()).toList();
    List<Map<String, dynamic>>? _other_tenders = this.other_tenders.map((i) => i.toMap()).toList();
    List<Map<String, dynamic>>? _combine = this.combine.map((i) => i.toMap()).toList();

    Map<String, dynamic>? _ordersDetails = this.ordersDetails != null ? this.ordersDetails!.toMap() : null;
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'cashier_in': (cashier_in == null) ? null : "/Date(" + (cashier_in!.millisecondsSinceEpoch).toString() + ")/",
      'cashier_out': (cashier_out == null) ? null : "/Date(" + (cashier_out!.millisecondsSinceEpoch).toString() + ")/",
      'approvedBy': approvedBy,
      'start_amount': start_amount,
      'Total_Transactions': total_Transactions,
      'Account_Payment': account_Payment,
      'Total_Sale': total_Sale,
      'PayOut_Total': payOut_total,
      'extra_cash': extra_cash,
      'terminal_id': terminal_id,
      'employee_id': employee_id,
      'Combine': _combine,
      'categoryReports': _categoryReports,
      'details': _details,
      'credit_payments': _credit_payments,
      'local_currency': _local_currency,
      'forignCurrency': _forign_currency,
      'other_tenders': _other_tenders,
      'ordersDetails': _ordersDetails,
    };
    return map;
  }

  factory CashierReportModel.fromMap(Map<String, dynamic> map) {
    return CashierReportModel(
        id: map['id'],
        employee_id: map['employee_id'],
        name: map['name'],
        terminal_id: map['terminal_id'],
        cashier_in: map['cashier_in'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['cashier_in']),
        cashier_out: map['cashier_out'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['cashier_out']),
        approvedBy: map['approvedBy'],
        start_amount: map['start_amount'] ?? 0,
        total_Transactions: map['Total_Transactions'] ?? 0,
        account_Payment: map['Account_Payment'] ?? 0,
        total_Sale: map['Total_Sale'] ?? 0,
        payOut_total: map['PayOut_Total'] ?? 0,
        extra_cash: map['Extra_Cash'] ?? 0,
        ordersDetails: map['ordersDetails'] ?? new OrdersDetails(),
        categoryReports: List<CategoryCashier>.empty(growable: true),
        details: List<CashierReportDetails>.empty(growable: true),
        credit_payments: List<CashierReportDetails>.empty(growable: true),
        local_currency: List<LocalCurrencys>.empty(growable: true),
        forignCurrency: List<ForigenCurrencys>.empty(growable: true),
        other_tenders: List<OtherTenders>.empty(growable: true));
  }

  get total_income {
    if (total_Sale != null) {
      return total_Sale + start_amount;
    } else {
      return 0.0;
    }
  }

  List<CashierReportDetails> get combine {
    List<CashierReportDetails> temp = details;
    CashierReportDetails? detail;

    for (var _item in credit_payments) {
      detail = temp.firstWhereOrNull((f) => f.payment_method_id == _item.payment_method_id);
      if (detail == null) {
        temp.add(_item);
      } else {
        detail.amount_paid += _item.amount_paid;
        detail.actual_amount_paid += _item.actual_amount_paid;
        detail.count += _item.count;
      }
    }
    return temp;
  }

  cashier_year(date) {
    if (date != null) {
      return date.year.toString();
    } else {
      return "";
    }
  }

  cashier_month(date) {
    if (date != null) {
      if (date.month < 10) {
        return "0" + date.month.toString();
      } else {
        return date.month.toString();
      }
    } else {
      return "";
    }
  }

  cashier_days(date) {
    if (date != null) {
      if (date.day < 10) {
        return "0" + date.day.toString();
      } else {
        return date.day.toString();
      }
    } else {
      return "";
    }
  }

  cashier_hour(date) {
    if (date != null) {
      if (date.hour < 10) {
        return "0" + date.hour.toString();
      } else {
        return date.hour.toString();
      }
    } else {
      return "";
    }
  }

  cashier_min(date) {
    if (date != null) {
      if (date.minute < 10) {
        return "0" + date.minute.toString();
      } else {
        return date.minute.toString();
      }
    } else {
      return "";
    }
  }

  get netSale {
    double temp = 0.0;
    if (details.isNotEmpty) {
      details.forEach((element) {
        temp += element.amount_paid;
      });

      return temp;
    } else {
      return temp;
    }
  }

  get categoryTotal {
    double temp = 0.0;
    if (categoryReports.isNotEmpty) {
      categoryReports.forEach((element) {
        temp += element.total!;
      });

      return temp;
    } else {
      return temp;
    }
  }

  get localCurrencyTotal {
    double temp = 0.0;
    if (local_currency.isNotEmpty) {
      local_currency.forEach((element) {
        temp += element.amount!;
      });

      return temp;
    } else {
      return temp;
    }
  }

  get otherTenderTotal {
    double temp = 0.0;
    if (other_tenders.isNotEmpty) {
      for (var element in other_tenders) {
        temp += element.amount!;
      }

      return temp;
    } else {
      return temp;
    }
  }

  get forignCurrencyTotal {
    double temp = 0.0;
    if (forignCurrency.isNotEmpty) {
      forignCurrency.forEach((element) {
        temp += element.amount!;
      });

      return temp;
    } else {
      return temp;
    }
  }
}

class CashierModel {
  int? id;
  String? name;
  int? employee_id;
  DateTime? cashier_in;
  DateTime? cashier_out;
  int? terminal_id;
  CashierModel({this.id, this.name, this.cashier_in, this.cashier_out, this.terminal_id, this.employee_id});

  CashierModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    employee_id = map['employee_id'];
    name = map['name'];
    terminal_id = map['terminal_id'];
    cashier_in = map['cashier_in'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['cashier_in']);
    cashier_out = map['cashier_out'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['cashier_out']);
  }
  factory CashierModel.fromJson(Map<String, dynamic> json) {
    DateTime _cashier_in = DateTime.fromMillisecondsSinceEpoch(int.parse(json['cashier_in'].substring(6, json['cashier_in'].length - 7)));
    DateTime _cashier_out = DateTime.fromMillisecondsSinceEpoch(int.parse(json['cashier_out'].substring(6, json['cashier_out'].length - 7)));
    return CashierModel(
        id: json['id'],
        name: json['name'],
        cashier_in: _cashier_in,
        cashier_out: _cashier_out,
        terminal_id: json['terminal_id'],
        employee_id: json['employee_id']);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'cashier_in': (cashier_in == null) ? null : "/Date(" + (cashier_in?.millisecondsSinceEpoch).toString() + ")/",
      'cashier_out': (cashier_out == null) ? null : "/Date(" + (cashier_out?.millisecondsSinceEpoch).toString() + ")/",
      'terminal_id': terminal_id,
      'employee_id': employee_id,
      'name': name
    };
    return map;
  }

  cashier_month(date) {
    if (date != null) {
      if (date.month < 10) {
        return "0" + date.month.toString();
      } else {
        return date.month.toString();
      }
    } else {
      return "";
    }
  }

  cashier_days(date) {
    if (date != null) {
      if (date.day < 10) {
        return "0" + date.day.toString();
      } else {
        return date.day.toString();
      }
    } else {
      return "";
    }
  }

  cashier_hour(date) {
    if (date != null) {
      if (date.hour < 10) {
        return "0" + date.hour.toString();
      } else {
        return date.hour.toString();
      }
    } else {
      return "";
    }
  }

  cashier_min(date) {
    if (date != null) {
      if (date.minute < 10) {
        return "0" + date.minute.toString();
      } else {
        return date.minute.toString();
      }
    } else {
      return "";
    }
  }
}

class OtherTenders {
  PaymentMethod? payment_method;
  double? amount;
  OtherTenders({this.payment_method, this.amount});

  OtherTenders.fromMap(Map<String, dynamic> map) {
    amount = map['amount'];
    payment_method = map['payment_method'];
  }

  factory OtherTenders.fromJson(Map<String, dynamic> json) {
    return OtherTenders(
      payment_method: json['payment_method'],
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'payment_method': payment_method,
      'amount': amount ?? 0.0,
    };
    return map;
  }
}

class CategoryCashier {
  String? category_name;
  double? total;
  CategoryCashier({this.category_name, this.total});

  CategoryCashier.fromMap(Map<String, dynamic> map) {
    category_name = map['category_name'] ?? 'Other';
    total = map['total'];
  }

  factory CategoryCashier.fromJson(Map<String, dynamic> json) {
    return CategoryCashier(
      category_name: json['category_name'] ?? 'Other',
      total: double.parse(json['total'].toString()),
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'category_name': category_name,
      'total': total ?? 0.0,
    };
    return map;
  }
}

class LocalCurrencys {
  int? qty;
  double? type;

  LocalCurrencys({this.qty, this.type});

  LocalCurrencys.fromMap(Map<String, dynamic> map) {
    qty = map['qty'] ?? 0;
    type = map['type'] ?? 0;
  }
  factory LocalCurrencys.fromJson(Map<String, dynamic> json) {
    return LocalCurrencys(
      qty: json['qty'],
      type: json['type'],
    );
  }

  get amount {
    if (qty != null) {
      return qty! * type!;
    } else {
      return 0.0;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'qty': qty ?? 0.0, 'type': type, 'amount': amount};
    return map;
  }
}

class ForigenCurrencys {
  double? amount;
  PaymentMethod? payment_method;
  double? rate;

  ForigenCurrencys({this.payment_method, this.amount, this.rate});

  ForigenCurrencys.fromMap(Map<String, dynamic> map) {
    amount = map['amount'];
    payment_method = map['payment_method'];
    rate = map['rate'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'amount': amount ?? 0.0, 'payment_method': payment_method, 'rate': rate};
    return map;
  }

  factory ForigenCurrencys.fromJson(Map<String, dynamic> json) {
    return ForigenCurrencys(
      amount: json['amount'],
      payment_method: json['payment_method'],
      rate: json['rate'],
    );
  }

  get equivalant {
    if (amount != null) {
      return (rate! * amount!);
    } else {
      return 0.0;
    }
  }
}

class CashierReportDetails {
  int? cashier_id;
  int? payment_method_id;
  String? payment_method;
  double start_amount;
  double end_amount;
  int count;
  double amount_paid;
  double actual_amount_paid;

  CashierReportDetails(
      {required this.payment_method,
      this.actual_amount_paid = 0,
      this.amount_paid = 0,
      required this.cashier_id,
      this.count = 0,
      this.end_amount = 0,
      required this.payment_method_id,
      this.start_amount = 0});

  factory CashierReportDetails.fromMap(Map<String, dynamic> map) {
    return CashierReportDetails(
        payment_method: map['Payment_method'],
        actual_amount_paid: map['actual_amount_paid'] ?? 0,
        amount_paid: map['Amount_paid'] ?? 0,
        cashier_id: map['cashier_id'],
        count: map['count'] ?? 0,
        end_amount: map['end_amount'] ?? 0,
        payment_method_id: map['payment_method_id'],
        start_amount: map['start_amount'] ?? 0);
  }

  factory CashierReportDetails.fromJson(Map<String, dynamic> json) {
    return CashierReportDetails(
      payment_method: json['Payment_method'],
      actual_amount_paid: json['actual_amount_paid'] != null ? double.parse(json['actual_amount_paid'].toString()) : 0.0,
      amount_paid: json['Amount_paid'] != null ? double.parse(json['Amount_paid'].toString()) : 0.0,
      cashier_id: json['cashier_id'],
      count: json['count'],
      end_amount: json['end_amount'] != null ? double.parse(json['end_amount'].toString()) : 0.0,
      payment_method_id: json['payment_method_id'],
      start_amount: json['start_amount'] != null ? double.parse(json['start_amount'].toString()) : 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'cashier_id': cashier_id,
      'Payment_method': payment_method,
      'payment_method_id': payment_method_id,
      'actual_amount_paid': actual_amount_paid,
      'Amount_paid': amount_paid,
      'cashier_id': cashier_id,
      'count': count,
      'end_amount': end_amount,
      'start_amount': start_amount,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'cashier_id': cashier_id,
      'Payment_method': payment_method,
      'payment_method_id': payment_method_id,
      'actual_amount_paid': actual_amount_paid,
      'Amount_paid': amount_paid,
      'cashier_id': cashier_id,
      'count': count,
      'Count': count,
      'end_amount': end_amount,
      'start_amount': start_amount,
      'Expected': (start_amount + amount_paid),
      'ShortOver': (end_amount - (start_amount + amount_paid))
    };
    return map;
  }
}

class OrdersDetails {
  double? total_charge_per_hour;
  double? total_minimum_charge;
  double? total_delivery_charge;
  double? total_discount_amount;
  double? total_surcharge_amount;
  double? total_tax;
  double? total_tax2;
  double? total_tax3;
  double? total_rounding;

  OrdersDetails(
      {this.total_rounding,
      this.total_tax,
      this.total_delivery_charge,
      this.total_surcharge_amount,
      this.total_discount_amount,
      this.total_minimum_charge,
      this.total_charge_per_hour,
      this.total_tax3,
      this.total_tax2});

  OrdersDetails.fromMap(Map<String, dynamic> map) {
    total_rounding = map['total_rounding'] ?? 0;
    total_tax = map['Total_tax'] ?? 0;
    total_delivery_charge = map['Total_delivery_charge'] ?? 0;
    total_surcharge_amount = map['Total_surcharge_amount'] ?? 0;
    total_discount_amount = map['Total_discount_amount'] ?? 0;
    total_minimum_charge = map['Total_minimum_charge'] ?? 0;
    total_charge_per_hour = map['Total_charge_per_hour'] ?? 0;
    total_tax3 = map['Total_tax3'] ?? 0;
    total_tax2 = map['Total_tax2'] ?? 0;
  }

  factory OrdersDetails.fromJson(Map<String, dynamic> json) {
    return OrdersDetails(
      total_rounding: json['total_rounding'] == null ? 0 : double.parse(json['total_rounding'].toString()),
      total_tax: json['Total_tax'] == null ? 0 : double.parse(json['Total_tax'].toString()),
      total_delivery_charge: json['Total_delivery_charge'] == null ? 0 : double.parse(json['Total_delivery_charge'].toString()),
      total_surcharge_amount: json['Total_surcharge_amount'] == null ? 0 : double.parse(json['Total_surcharge_amount'].toString()),
      total_discount_amount: json['Total_discount_amount'] == null ? 0 : double.parse(json['Total_discount_amount'].toString()),
      total_minimum_charge: json['Total_minimum_charge'] == null ? 0 : double.parse(json['Total_minimum_charge'].toString()),
      total_charge_per_hour: json['Total_charge_per_hour'] == null ? 0 : double.parse(json['Total_charge_per_hour'].toString()),
      total_tax3: json['Total_tax3'] == null ? 0 : double.parse(json['Total_tax3'].toString()),
      total_tax2: json['Total_tax2'] == null ? 0 : double.parse(json['Total_tax2'].toString()),
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'total_rounding': total_rounding ?? 0,
      'total_tax': total_tax ?? 0,
      'total_delivery_charge': total_delivery_charge ?? 0,
      'total_surcharge_amount': total_surcharge_amount ?? 0,
      'total_discount_amount': total_discount_amount ?? 0,
      'total_minimum_charge': total_minimum_charge ?? 0,
      'total_charge_per_hour': total_charge_per_hour ?? 0,
      'total_tax3': total_tax3 ?? 0,
      'total_tax2': total_tax2 ?? 0,
    };
    return map;
  }
}
