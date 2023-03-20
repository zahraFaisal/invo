// ignore_for_file: unnecessary_this, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:invo_mobile/blocs/order_page/order_page_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/models/order/employee_reference.dart';
import 'package:invo_mobile/models/order/menu_item_reference.dart';
import 'package:invo_mobile/models/order/service_reference.dart';
import 'package:invo_mobile/models/order/surcharge_reference.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../Number.dart';
import '../menu_item.dart' as mi;
import '../menu_modifier.dart';
import 'TransactionCombo.dart';
import 'TransactionModifier.dart';
import 'customer_reference.dart';
import 'dineIn_table_reference.dart';
import 'discount_reference.dart';
import 'order_payment.dart';
import 'order_transaction.dart';

part 'order_header.g.dart';

@JsonSerializable()
class OrderHeader {
  int id;
  int? ticket_number;

  int? terminal_id;
  ServiceReference? service;
  int? service_id;

  int employee_id;
  EmployeeReference? employee;

  @JsonKey(includeIfNull: false)
  int? dinein_table_id;

  @JsonKey(includeIfNull: false)
  DineInTableReference? dinein_table;

  DateTime? date_time;
  String? date_time_string;

  @JsonKey(includeIfNull: false)
  int? discount_id;
  @JsonKey(includeIfNull: false)
  DiscountReference? discount;
  String? discount_name_txt;

  @JsonKey(defaultValue: false)
  bool discount_percentage = false;

  double discount_amount = 0;

  @JsonKey(includeIfNull: false)
  SurchargeReference? surcharge;

  int? surcharge_id;

  bool surcharge_percentage = false;

  double surcharge_amount = 0;

  @JsonKey(includeIfNull: false)
  CustomerReference? customer;

  @JsonKey(includeIfNull: false)
  int? customer_id_number;

  @JsonKey(includeIfNull: false)
  String? customer_contact;

  @JsonKey(includeIfNull: false)
  String? customer_address;
  String? note;

  int no_of_guests = 1;
  DateTime? prepared_date;

  double minimum_charge = 0;
  double charge_per_hour = 0;
  int charge_after = 0;

  int? status; // 1- open , 2 printed , 3 paid , 4 void , 6 re open ,7 merged
  String? Label;
  double total_tax = 0;
  double total_tax2 = 0;
  double total_tax3 = 0;
  double? total_charge_per_hour;
  double grand_price = 0;
  String GUID;

  double Smallest_currency = 0;
  int Round_Type = 0;
  double Rounding = 0;

  List<OrderTransaction> transaction = [];
  List<OrderPayment> payments;
  double item_total = 0;

  double delivery_charge;
  double min_charge; //total minimum charge
  double discount_actual_amount;
  double surcharge_actual_amount;
  double sub_total_price;

  double tax1;
  double tax2;
  double tax3;
  bool tax2_tax1;
  double taxable1_amount;

  double taxable2_amount;
  double taxable3_amount;

  bool surcharge_apply_tax1;

  bool surcharge_apply_tax2;

  bool surcharge_apply_tax3;

  @JsonKey(includeIfNull: false)
  EmployeeReference? driver;

  @JsonKey(includeIfNull: false)
  DateTime? depature_time;

  @JsonKey(includeIfNull: false)
  DateTime? arrival_time;

  DateTime? print_time;

  int PrintCopy = 0;
  int? localPrintCopy;
  String server_id;
  OrderHeader({
    this.id = 0,
    this.server_id = "",
    this.ticket_number = 0,
    this.GUID = "",
    @required this.terminal_id,
    this.service_id,
    this.service,
    this.discount_name_txt,
    required this.employee_id,
    this.employee,
    this.dinein_table_id,
    this.dinein_table,
    this.discount_id,
    this.discount,
    this.discount_amount = 0,
    this.discount_percentage = false,
    this.surcharge,
    this.surcharge_id,
    this.prepared_date,
    this.surcharge_amount = 0,
    this.surcharge_percentage = false,
    this.customer,
    this.customer_id_number,
    this.customer_contact,
    this.customer_address,
    this.driver,
    this.depature_time,
    this.arrival_time,
    this.total_tax = 0,
    this.total_tax2 = 0,
    this.total_tax3 = 0,
    this.grand_price = 0,
    this.status = 1,
    this.date_time,
    this.no_of_guests = 1,
    this.Smallest_currency = 0,
    this.total_charge_per_hour = 0,
    this.Round_Type = 0,
    this.charge_after = 0,
    this.print_time,
    this.Label,
    this.charge_per_hour = 0,
    this.minimum_charge = 0,
    this.min_charge = 0,
    this.discount_actual_amount = 0,
    this.surcharge_actual_amount = 0,
    this.sub_total_price = 0,
    this.delivery_charge = 0,
    this.surcharge_apply_tax1 = false,
    this.surcharge_apply_tax2 = false,
    this.surcharge_apply_tax3 = false,
    this.taxable1_amount = 0,
    this.taxable2_amount = 0,
    this.taxable3_amount = 0,
    this.tax1 = 0,
    this.tax2 = 0,
    this.tax3 = 0,
    this.tax2_tax1 = false,
    required this.transaction,
    required this.payments,
    this.PrintCopy = 0,
  }) {
    if (this.transaction == null) this.transaction = List<OrderTransaction>.empty(growable: true);
    if (this.payments == null) this.payments = List<OrderPayment>.empty(growable: true);
    if (this.GUID == null || this.GUID == "") GUID = Uuid().v1();
  }

  factory OrderHeader.fromJson(Map<String, dynamic> json) {
    List<OrderTransaction> _transaction = List<OrderTransaction>.empty(growable: true);
    for (var item in json['transaction']) {
      _transaction.add(OrderTransaction.fromJson(item));
    }
    print("test");
    List<OrderPayment> _payments = List<OrderPayment>.empty(growable: true);
    if (json['payments'] != null)
      for (var item in json['payments']) {
        _payments.add(OrderPayment.fromJson(item));
      }

    DineInTableReference? _dineInTable = (json.containsKey('dinein_table') && json['dinein_table'] != null) ? DineInTableReference.fromJson(json['dinein_table']) : null;

    ServiceReference? _service = (json.containsKey('service') && json['service'] != null) ? ServiceReference.fromJson(json['service']) : null;

    EmployeeReference? _employee = (json.containsKey('employee') && json['employee'] != null) ? EmployeeReference.fromJson(json['employee']) : null;

    EmployeeReference? _driver = (json.containsKey('driver') && json['driver'] != null) ? EmployeeReference.fromJson(json['driver']) : null;

    DiscountReference? _discount = (json.containsKey('discount') && json['discount'] != null) ? DiscountReference.fromJson(json['discount']) : null;

    SurchargeReference? _surcharge = (json.containsKey('surcharge') && json['surcharge'] != null) ? SurchargeReference.fromJson(json['surcharge']) : null;

    CustomerReference? _customer = (json.containsKey('customer') && json['customer'] != null) ? CustomerReference.fromJson(json['customer']) : null;

    // if (_customer != null && _customer.id_number == 0) _customer = null;

    DateTime _dateTime;

    if (json['date_time'].toString().contains('T') && json['date_time'] != null) {
      _dateTime = DateTime.now();
    } else {
      _dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['date_time'].substring(6, json['date_time'].length - 7)));
    }

    DateTime? _depatureTime = (json.containsKey('depature_time') && json['depature_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['depature_time'].substring(6, json['depature_time'].length - 7))) : null;

    DateTime? _printTime;
    if ((json.containsKey('print_time') && json['print_time'] != null)) {
      _printTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['print_time'].substring(6, json['print_time'].length - 7)));
    }

    DateTime? _arrivalTime = (json.containsKey('arrival_time') && json['arrival_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['arrival_time'].substring(6, json['arrival_time'].length - 7))) : null;

    DateTime? _prepared_date = (json.containsKey('prepared_date') && json['prepared_date'] != null) ? DateTime.fromMillisecondsSinceEpoch(int.parse(json['prepared_date'].substring(6, json['prepared_date'].length - 7))) : null;
    int? surcharge_id;
    if (_surcharge != null) {
      surcharge_id = _surcharge.id;
    }

    return OrderHeader(
        id: json['id'] ?? 0,
        ticket_number: json['ticket_number'] ?? 0,
        GUID: json['GUID'],
        terminal_id: json['terminal_id'] ?? 0,
        status: json['status'] ?? 1,
        date_time: _dateTime,
        service_id: json['service_id'] ?? 0,
        service: _service,
        employee_id: json['employee_id'] ?? 1,
        employee: _employee,
        customer: _customer,
        prepared_date: _prepared_date,
        customer_id_number: json['customer_id_number'],
        customer_address: json['customer_address'],
        customer_contact: json['customer_contact'],
        driver: _driver,
        depature_time: _depatureTime,
        arrival_time: _arrivalTime,
        print_time: _printTime,
        dinein_table_id: json['dinein_table_id'],
        dinein_table: _dineInTable,
        Label: json['Label'],
        discount: _discount,
        discount_id: int.parse(json['discount_id'] == null ? "0" : json['discount_id'].toString()),
        discount_amount: double.parse(json['discount_amount'] == null ? "0" : json['discount_amount'].toString()),
        discount_percentage: json['discount_percentage'] ?? false,
        surcharge: _surcharge,
        surcharge_amount: double.parse(json['surcharge_amount'] == null ? "0" : json['surcharge_amount'].toString()),
        surcharge_percentage: json['surcharge_percentage'] ?? false,
        total_tax: double.parse(json['total_tax'] == null ? "0" : json['total_tax'].toString()),
        total_tax2: double.parse(json['total_tax2'] == null ? "0" : json['total_tax2'].toString()),
        total_tax3: double.parse(json['total_tax3'] == null ? "0" : json['total_tax3'].toString()),
        grand_price: json.containsKey('grand_price') ? double.parse(json['grand_price'].toString()) : 0,
        total_charge_per_hour: double.parse(json['total_charge_per_hour'] == null ? "0" : json['total_charge_per_hour'].toString()),
        no_of_guests: int.parse(json['no_of_guests'] == null ? "0" : json['no_of_guests'].toString()),
        Smallest_currency: double.parse(json['Smallest_currency'] == null ? "0" : json['Smallest_currency'].toString()),
        Round_Type: int.parse(json['Round_Type'] == null ? "0" : json['Round_Type'].toString()),
        charge_after: int.parse(json['charge_after'] == null ? "0" : json['charge_after'].toString()),
        charge_per_hour: double.parse(json['charge_per_hour'] == null ? "0" : json['charge_per_hour'].toString()),
        minimum_charge: double.parse(json['minimum_charge'] == null ? "0" : json['minimum_charge'].toString()),
        min_charge: double.parse(json['min_charge'] == null ? "0" : json['min_charge'].toString()),
        discount_actual_amount: double.parse(json['discount_actual_amount'] == null ? "0" : json['discount_actual_amount'].toString()),
        surcharge_actual_amount: double.parse(json['surcharge_actual_amount'] == null ? "0" : json['surcharge_actual_amount'].toString()),
        tax1: double.parse(json['tax1'] == null ? "0" : json['tax1'].toString()),
        tax2: double.parse(json['tax2'] == null ? "0" : json['tax2'].toString()),
        tax3: double.parse(json['tax3'] == null ? "0" : json['tax3'].toString()),
        tax2_tax1: json['tax2_tax1'] ?? false,
        surcharge_apply_tax1: json['surcharge_apply_tax1'] ?? false,
        surcharge_apply_tax2: json['surcharge_apply_tax2'] ?? false,
        surcharge_apply_tax3: json['surcharge_apply_tax3'] ?? false,
        surcharge_id: surcharge_id,
        delivery_charge: double.parse(json['delivery_charge'] == null ? "0" : json['delivery_charge'].toString()),
        sub_total_price: double.parse(json['sub_total_price'] == null ? "0" : json['sub_total_price'].toString()),
        transaction: _transaction,
        PrintCopy: json['PrintCopy'] ?? 0,
        payments: _payments);
  }

  factory OrderHeader.fromMap(Map<String, dynamic> json) {
    List<OrderTransaction> _transaction = List<OrderTransaction>.empty(growable: true);
    if ((json.containsKey('transaction') && json['transaction'] != null))
      for (var item in json['transaction']) {
        _transaction.add(OrderTransaction.fromJson(item));
      }

    List<OrderPayment> _payments = List<OrderPayment>.empty(growable: true);
    if (json['payments'] != null)
      for (var item in json['payments']) {
        _payments.add(OrderPayment.fromJson(item));
      }

    DateTime _dateTime;

    if (json['date_time'].toString().contains(":")) {
      _dateTime = DateTime.parse(json['date_time']);
    } else {
      _dateTime = DateTime.fromMillisecondsSinceEpoch(json['date_time']);
    }

    DateTime? _depatureTime = (json.containsKey('depature_time') && json['depature_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['depature_time']) : null;

    DateTime? _printTime = (json.containsKey('print_time') && json['depature_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['print_time']) : null;

    DateTime? _arrivalTime = (json.containsKey('arrival_time') && json['arrival_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['arrival_time']) : null;

    DineInTableReference? _dineInTable;
    if (json['dinein_table_id'] != null) {
      _dineInTable = DineInTableReference(id: json['dinein_table_id'], name: json['dineIn_table_name']);
    }

    DiscountReference? _discount;
    if (json['discount_id'] != null && json['discount_id'] != 0) {
      _discount = DiscountReference(id: json['discount_id'], name: json['discount_name'], items: json['items']);
    }

    ServiceReference? _service;
    if (json['service_id'] != null) {
      _service = ServiceReference(id: json['service_id'], name: json['service_name'], alternative: json['service_alternative']);
    }

    EmployeeReference? _employee;
    if (json['employee_id'] != null && json['employee_id'] != 0) {
      _employee = EmployeeReference(id: json['employee_id'], name: json['employee_name'] ?? "");
    }

    CustomerReference? _customer;
    if (json['customer_id_number'] != null && json['customer_id_number'] != 0) {
      _customer = CustomerReference(id_number: json['customer_id_number'], name: json['customer_name'] ?? "");
    }

    if (json['customer'] != null) {
      _customer = CustomerReference(id_number: json['customer']['id_number'], name: json['customer']['name']);
    }

    SurchargeReference? _surcharge;
    if (json['surcharge_id'] != null && json['surcharge_id'] != 0) {
      _surcharge = SurchargeReference(id: json['surcharge_id'], name: json['surcharge_name']);
    }

    EmployeeReference? _driver;
    if (json['driver_id'] != null) {
      _driver = EmployeeReference(id: json['driver_id'], name: json['driver_name']);
    }

    return OrderHeader(
      id: json['id'],
      transaction: _transaction,
      payments: _payments,
      ticket_number: json['ticket_number'],
      GUID: json['GUID'],
      terminal_id: json['terminal_id'],
      discount_name_txt: json['discount_name'],
      status: json['status'],
      date_time: _dateTime,
      service_id: json['service_id'],
      service: _service,
      employee_id: json['employee_id'],
      employee: _employee,
      dinein_table: _dineInTable,
      discount: _discount,
      surcharge: _surcharge,
      driver: _driver,
      customer_id_number: json['customer_id_number'],
      customer: _customer,
      customer_address: json['customer_address'],
      customer_contact: json['customer_contact'],
      depature_time: _depatureTime,
      arrival_time: _arrivalTime,
      print_time: _printTime,
      dinein_table_id: json['dinein_table_id'],
      Label: json['Label'],
      discount_id: int.parse(json['discount_id'] == null ? "0" : json['discount_id'].toString()),
      discount_amount: double.parse(json['discount_amount'] == null ? "0" : json['discount_amount'].toString()),
      discount_percentage: json['discount_percentage'] == 1 ? true : false,
      surcharge_id: int.parse(json['surcharge_id'] == null ? "0" : json['surcharge_id'].toString()),
      surcharge_amount: double.parse(json['surcharge_amount'] == null ? "0" : json['surcharge_amount'].toString()),
      surcharge_percentage: json['surcharge_percentage'] == 1 ? true : false,
      total_tax: double.parse(json['total_tax'] == null ? "0" : json['total_tax'].toString()),
      total_tax2: double.parse(json['total_tax2'] == null ? "0" : json['total_tax2'].toString()),
      total_tax3: double.parse(json['total_tax3'] == null ? "0" : json['total_tax3'].toString()),
      grand_price: json.containsKey('grand_price') ? double.parse(json['grand_price'].toString()) : 0,
      total_charge_per_hour: double.parse(json['total_charge_per_hour'] == null ? "0" : json['total_charge_per_hour'].toString()),
      no_of_guests: int.parse(json['no_of_guests'] == null ? "0" : json['no_of_guests'].toString()),
      Smallest_currency: double.parse(json['Smallest_currency'] == null ? "0" : json['Smallest_currency'].toString()),
      Round_Type: int.parse(json['Round_Type'] == null ? "0" : json['Round_Type'].toString()),
      charge_after: int.parse(json['charge_after'] == null ? "0" : json['charge_after'].toString()),
      charge_per_hour: double.parse(json['charge_per_hour'] == null ? "0" : json['charge_per_hour'].toString()),
      minimum_charge: double.parse(json['minimum_charge'] == null ? "0" : json['minimum_charge'].toString()),
      min_charge: double.parse(json['min_charge'] == null ? "0" : json['min_charge'].toString()),
      discount_actual_amount: double.parse(json['discount_actual_amount'] == null ? "0" : json['discount_actual_amount'].toString()),
      surcharge_actual_amount: double.parse(json['surcharge_actual_amount'] == null ? "0" : json['surcharge_actual_amount'].toString()),
      tax1: double.parse(json['tax1'] == null ? "0" : json['tax1'].toString()),
      tax2: double.parse(json['tax2'] == null ? "0" : json['tax2'].toString()),
      tax3: double.parse(json['tax3'] == null ? "0" : json['tax3'].toString()),
      tax2_tax1: json['tax2_tax1'] == 1 ? true : false,
      surcharge_apply_tax1: json['surcharge_apply_tax1'] == 1 ? true : false,
      surcharge_apply_tax2: json['surcharge_apply_tax2'] == 1 ? true : false,
      surcharge_apply_tax3: json['surcharge_apply_tax3'] == 1 ? true : false,
      delivery_charge: double.parse(json['delivery_charge'] == null ? "0" : json['delivery_charge'].toString()),
      sub_total_price: double.parse(json['sub_total_price'] == null ? "0" : json['sub_total_price'].toString()),
    );
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    map['sub_total_price_no_tax3'] = sub_total_price_no_tax3;
    map['payments'] = payments;
    map['amount_change'] = amountChange;
    map['balance'] = amountBalance;
    map['amount_tendered'] = amountTendered;

    return map[key];
  }

  Map<String, dynamic> toMap() {
    int? _dateTime = (date_time == null || date_time!.toUtc().millisecondsSinceEpoch == null) ? null : date_time?.toUtc().millisecondsSinceEpoch;

    int? _depature_time = (depature_time == null || depature_time!.toUtc().millisecondsSinceEpoch == null) ? null : depature_time?.toUtc().millisecondsSinceEpoch;

    int? _arrival_time = (arrival_time == null || arrival_time!.toUtc().millisecondsSinceEpoch == null) ? null : arrival_time?.toUtc().millisecondsSinceEpoch;

    int? _print_time = (print_time == null || print_time!.toUtc().millisecondsSinceEpoch == null) ? null : print_time?.toUtc().millisecondsSinceEpoch;

    // int _employee_id;
    // if (employee != null) {
    //   _employee_id = employee!.id;
    // } else if (employee_id != null) {
    //   _employee_id = employee_id;
    // }

    // int _service_id = (service);
    // if (service != null) {
    //   _service_id = service!.id;
    // } else if (service_id != null) {
    //   _service_id = service_id!;
    // }

    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'ticket_number': ticket_number,
      'GUID': GUID,
      'terminal_id': terminal_id,
      'status': status,
      'surcharge': surcharge,
      'service': service,
      'customer': customer,
      'transaction': transaction,
      'employee': employee,
      'date_time': _dateTime,
      'discount_name_txt': discount_name_txt,
      'dinein_table': dinein_table,
      'service_id': service_id,
      'employee_id': employee_id,
      'customer_id_number': customer_id_number,
      'customer_address': customer_address,
      'customer_contact': customer_contact,
      'depature_time': _depature_time,
      'arrival_time': _arrival_time,
      'print_time': _print_time,
      'dinein_table_id': dinein_table_id,
      'Label': Label,
      'discount_id': discount_id,
      'discount_amount': discount_amount,
      'discount_percentage': discount_percentage,
      'surcharge_id': surcharge_id,
      'surcharge_amount': surcharge_amount,
      'surcharge_percentage': surcharge_percentage,
      'total_tax': total_tax,
      'total_tax2': total_tax2,
      'total_tax3': total_tax3,
      'grand_price': grand_price,
      'total_charge_per_hour': total_charge_per_hour,
      'no_of_guests': no_of_guests,
      'Smallest_currency': Smallest_currency,
      'Round_Type': Round_Type,
      'charge_after': charge_after,
      'charge_per_hour': charge_per_hour,
      'minimum_charge': minimum_charge,
      'min_charge': min_charge,
      'discount_actual_amount': discount_actual_amount,
      'surcharge_actual_amount': surcharge_actual_amount,
      'tax1': tax1,
      'tax2': tax2,
      'tax3': tax3,
      'tax2_tax1': tax2_tax1,
      'Rounding': Rounding,
      'surcharge_apply_tax1': surcharge_apply_tax1,
      'surcharge_apply_tax2': surcharge_apply_tax2,
      'surcharge_apply_tax3': surcharge_apply_tax3,
      'taxable1_amount': taxable1_amount,
      'taxable2_amount': taxable2_amount,
      'taxable3_amount': taxable3_amount,
      'delivery_charge': delivery_charge,
      'sub_total_price': sub_total_price,
    };
    return map;
  }

  Map<String, dynamic> toMapDB() {
    int? _dateTime = (date_time == null || date_time!.toUtc().millisecondsSinceEpoch == null) ? null : date_time?.toUtc().millisecondsSinceEpoch;

    int? _depature_time = (depature_time == null || depature_time!.toUtc().millisecondsSinceEpoch == null) ? null : depature_time?.toUtc().millisecondsSinceEpoch;

    int? _arrival_time = (arrival_time == null || arrival_time!.toUtc().millisecondsSinceEpoch == null) ? null : arrival_time?.toUtc().millisecondsSinceEpoch;

    int? _print_time = (print_time == null || print_time!.toUtc().millisecondsSinceEpoch == null) ? null : print_time?.toUtc().millisecondsSinceEpoch;
    // int? _employee_id;
    // if (employee != null)
    //   _employee_id = employee!.id;
    // else if (employee_id != null) _employee_id = employee_id;

    // int _service_id;
    // if (service != null)
    //   _service_id = service!.id;
    // else if (service_id != null) _service_id = service_id!;

    var map = <String, dynamic>{
      // 'id': id,
      'ticket_number': ticket_number,
      'GUID': GUID,
      'terminal_id': terminal_id,
      'status': status,
      // 'surcharge': surcharge,
      // 'service': service,
      // 'customer': customer,
      // 'transaction': transaction,
      // 'employee': employee,
      'date_time': _dateTime,
      // 'discount_name_txt': discount_name_txt,
      // 'dinein_table': dinein_table,
      'service_id': service_id,
      'employee_id': employee_id,
      'customer_id_number': customer_id_number,
      'customer_address': customer_address,
      'customer_contact': customer_contact,
      'depature_time': _depature_time,
      'arrival_time': _arrival_time,
      'print_time': _print_time,
      'dinein_table_id': dinein_table_id,
      'Label': Label,
      'discount_id': discount_id,
      'discount_amount': discount_amount,
      'discount_percentage': discount_percentage,
      'surcharge_id': surcharge_id,
      'surcharge_amount': surcharge_amount,
      'surcharge_percentage': surcharge_percentage,
      'total_tax': total_tax,
      'total_tax2': total_tax2,
      'total_tax3': total_tax3,
      'grand_price': grand_price,
      'total_charge_per_hour': total_charge_per_hour,
      'no_of_guests': no_of_guests,
      'Smallest_currency': Smallest_currency,
      'Round_Type': Round_Type,
      'charge_after': charge_after,
      'charge_per_hour': charge_per_hour,
      'minimum_charge': minimum_charge,
      'min_charge': min_charge,
      'discount_actual_amount': discount_actual_amount,
      'surcharge_actual_amount': surcharge_actual_amount,
      'tax1': tax1,
      'tax2': tax2,
      'tax3': tax3,
      'tax2_tax1': tax2_tax1,
      'Rounding': Rounding,
      'surcharge_apply_tax1': surcharge_apply_tax1,
      'surcharge_apply_tax2': surcharge_apply_tax2,
      'surcharge_apply_tax3': surcharge_apply_tax3,
      'taxable1_amount': taxable1_amount,
      'taxable2_amount': taxable2_amount,
      'taxable3_amount': taxable3_amount,
      'delivery_charge': delivery_charge,
      'sub_total_price': sub_total_price,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    List<Map<String, dynamic>>? _payments = payments != null ? payments.map((i) => i.toMap()).toList() : null;
    List<Map<String, dynamic>>? _transaction = transaction != null ? transaction.map((i) => i.toMap()).toList() : null;
    Map<String, dynamic>? _dinein_table = dinein_table != null ? dinein_table!.toMap() : null;
    Map<String, dynamic>? _service = service != null ? service!.toMap() : null;
    Map<String, dynamic>? _employee = employee != null ? employee!.toMap() : null;
    Map<String, dynamic>? _customer = customer != null ? customer!.toMap() : null;
    // int? _employee_id;
    // if (employee != null)
    //   _employee_id = employee.id;
    // else if (employee_id != null) _employee_id = employee_id;
    // int? _service_id;
    // if (service != null)
    //   _service_id = service!.id;
    // else if (service_id != null) _service_id = service_id;

    var map = <String, dynamic>{
      'id': id,
      'ticket_number': ticket_number,
      'GUID': GUID,
      'terminal_id': terminal_id,
      'status': status,
      'date_time': (date_time == null) ? null : "/Date(" + (date_time?.millisecondsSinceEpoch).toString() + ")/",
      'service_id': service_id,
      'employee_id': employee_id,
      'customer_id_number': customer_id_number,
      'customer_address': customer_address,
      'customer_contact': customer_contact,
      'depature_time': (depature_time == null) ? null : "/Date(" + (depature_time?.millisecondsSinceEpoch).toString() + ")/",
      'arrival_time': (arrival_time == null) ? null : "/Date(" + (arrival_time?.millisecondsSinceEpoch).toString() + ")/",
      'print_time': (print_time == null) ? null : "/Date(" + (print_time?.millisecondsSinceEpoch).toString() + ")/",
      'dinein_table_id': dinein_table_id,
      'Label': Label ?? "",
      'discount_id': discount_id,
      'discount_amount': discount_amount,
      'discount_percentage': discount_percentage,
      'surcharge_id': surcharge_id,
      'surcharge_amount': surcharge_amount,
      'surcharge_percentage': surcharge_percentage,
      'total_tax': total_tax,
      'total_tax2': total_tax2,
      'total_tax3': total_tax3,
      'grand_price': grand_price,
      'total_charge_per_hour': total_charge_per_hour,
      'no_of_guests': no_of_guests,
      'Smallest_currency': Smallest_currency,
      'Round_Type': Round_Type,
      'charge_after': charge_after,
      'charge_per_hour': charge_per_hour,
      'minimum_charge': minimum_charge,
      'min_charge': min_charge,
      'discount_actual_amount': discount_actual_amount,
      'surcharge_actual_amount': surcharge_actual_amount,
      'tax1': tax1,
      'tax2': tax2,
      'tax3': tax3,
      'tax2_tax1': tax2_tax1,
      'Rounding': Rounding,
      'surcharge_apply_tax1': surcharge_apply_tax1,
      'surcharge_apply_tax2': surcharge_apply_tax2,
      'surcharge_apply_tax3': surcharge_apply_tax3,
      'taxable1_amount': taxable1_amount,
      'taxable2_amount': taxable2_amount,
      'taxable3_amount': taxable3_amount,
      'delivery_charge': delivery_charge,
      'sub_total_price': sub_total_price,
      'payments': _payments,
      'transaction': _transaction,
      'dinein_table': _dinein_table,
      'service': _service,
      'employee': _employee,
      'customer': _customer,
      'server_id': server_id
    };
    return map;
  }

  OrderHeader clone() {
    OrderHeader orderHeader = OrderHeader(id: id, service_id: this.service_id, employee_id: this.employee_id, transaction: this.transaction, payments: this.payments, terminal_id: this.terminal_id);

    orderHeader.ticket_number = this.ticket_number;
    orderHeader.GUID = this.GUID;
    orderHeader.service = this.service;
    orderHeader.terminal_id = this.terminal_id;
    orderHeader.employee = this.employee;
    orderHeader.dinein_table_id = this.dinein_table_id;
    orderHeader.dinein_table = this.dinein_table;
    orderHeader.discount_id = this.discount_id;
    orderHeader.discount = this.discount;
    orderHeader.discount_amount = this.discount_amount;
    orderHeader.discount_percentage = this.discount_percentage;
    orderHeader.surcharge = this.surcharge;
    orderHeader.surcharge_amount = this.surcharge_amount;
    orderHeader.surcharge_percentage = this.surcharge_percentage;
    orderHeader.customer = this.customer;
    orderHeader.customer_id_number = this.customer_id_number;
    orderHeader.customer_contact = this.customer_contact;
    orderHeader.customer_address = this.customer_address;
    orderHeader.driver = this.driver;
    orderHeader.depature_time = this.depature_time;
    orderHeader.arrival_time = this.arrival_time;
    orderHeader.total_tax = this.total_tax;
    orderHeader.total_tax2 = this.total_tax2;
    orderHeader.total_tax3 = this.total_tax3;
    orderHeader.grand_price = this.grand_price;
    orderHeader.status = this.status;
    orderHeader.date_time = this.date_time;
    orderHeader.no_of_guests = this.no_of_guests;
    orderHeader.Smallest_currency = this.Smallest_currency;
    orderHeader.total_charge_per_hour = this.total_charge_per_hour;
    orderHeader.Round_Type = this.Round_Type;
    orderHeader.charge_after = this.charge_after;
    orderHeader.Label = this.Label;
    orderHeader.charge_per_hour = this.charge_per_hour;
    orderHeader.minimum_charge = this.minimum_charge;
    orderHeader.min_charge = this.min_charge;
    orderHeader.discount_actual_amount = this.discount_actual_amount;
    orderHeader.surcharge_actual_amount = this.surcharge_actual_amount;
    orderHeader.sub_total_price = this.sub_total_price;
    orderHeader.delivery_charge = this.delivery_charge;
    orderHeader.surcharge_apply_tax1 = this.surcharge_apply_tax1;
    orderHeader.surcharge_apply_tax2 = this.surcharge_apply_tax2;
    orderHeader.surcharge_apply_tax3 = this.surcharge_apply_tax3;
    orderHeader.tax1 = this.tax1;
    orderHeader.tax2 = this.tax2;
    orderHeader.tax3 = this.tax3;
    orderHeader.tax2_tax1 = this.tax2_tax1;

    return orderHeader;
  }

  Map<String, dynamic> toJson() => _$OrderHeaderToJson(this);

  double get sub_total_price_no_tax3 {
    return taxable3_amount - total_tax3;
  }

  bool get isChargePerHourVisible {
    return charge_per_hour > 0;
  }

  //===========================================================================================
  bool get isMinChargeVisible {
    return min_charge > 0;
  }

  //===========================================================================================
  bool get isSubTotalVisible {
    return total_tax > 0 || total_tax2 > 0 || isRoundingVisible;
    //return sub_total_price != grand_total_price;
  }
  //===========================================================================================

  bool get isItemTotalVisible {
    return surcharge_actual_amount > 0 || charge_per_hour > 0 || discount_actual_amount > 0 || delivery_charge > 0 || min_charge > 0;
  }

  bool get isSurchargeVisible {
    return surcharge_actual_amount > 0;
  }

  //===========================================================================================
  bool get isDiscountVisible {
    return discount_actual_amount > 0;
  }

  //===========================================================================================
  bool get isDeliveryChargeVisible {
    return delivery_charge > 0;
  }

  //===========================================================================================
  bool get isRoundingVisible {
    return Rounding != 0;
  }

  //===========================================================================================
  bool get isTaxVisible {
    return total_tax > 0;
  }

  //===========================================================================================
  bool get isTax2Visible {
    return total_tax2 > 0;
  }

  //===========================================================================================
  bool get isTax3Visible {
    return total_tax3 > 0;
  }

  //===========================================================================================

  bool get isEditBtnVisible {
    return (driver == null && arrival_time == null && (status == 1 || status == 2 || status == 6));
  }

  bool get isReOpenBtnVisible {
    return status == 6;
  }

  bool get isPayBtnVisible {
    //payment only if open or print
    return (driver == null || arrival_time != null) && status == 1 || status == 2 || status == 6;
  }

  bool get isVoidBtnVisible {
    return status != 4;
  }

  bool get isSurchargeBtnVisible {
    return driver == null && arrival_time == null && (status == 1 || status == 2);
  }

  bool get isDiscountBtnVisible {
    return driver == null && arrival_time == null && (status == 1 || status == 2);
  }

  double get exclusiveTax {
    if (tax1 > 0 || tax2 > 0) {
      double exclusiveTax = 0;
      for (var item in transaction.where((f) => f.status == 1 && (f.apply_tax1 == true || f.apply_tax2 == true) && (f.tax1_amount + f.tax2_amount) > 0)) {
        exclusiveTax += item.grand_price;
      }
      exclusiveTax += min_charge;

      if (discount_percentage == false) // for cash discount
      {
        exclusiveTax -= discount_actual_amount;
        if (exclusiveTax < 0) exclusiveTax = 0;
      } else {
        for (var item in transaction.where((f) => f.status == 1 && (f.apply_tax1 || f.apply_tax2))) {
          exclusiveTax += item.discountable ? item.grand_price * ((100 - discount_amount) / 100) : item.grand_price;
        }
      }

      if (surcharge_apply_tax1 || surcharge_apply_tax2) {
        exclusiveTax += surcharge_actual_amount;
      }

      exclusiveTax += delivery_charge;
      return exclusiveTax;
    } else {
      return 0;
    }
  }

  double get inclusiveTax {
    if (tax3 > 0) {
      double inclusiveTax = 0;
      for (var item in transaction.where((f) => f.status == 1 && f.apply_tax3 == true && (f.tax3_amount) > 0)) {
        inclusiveTax += item.grand_price;
      }

      inclusiveTax += min_charge;

      if (discount_percentage == false) // for cash discount
      {
        inclusiveTax -= discount_actual_amount;
        if (inclusiveTax < 0) inclusiveTax = 0;
      } else {
        for (var item in transaction.where((f) => f.status == 1 && f.apply_tax3)) {
          inclusiveTax += item.discountable ? item.grand_price * ((100 - discount_amount) / 100) : item.grand_price;
        }
      }

      if (surcharge_apply_tax3) {
        inclusiveTax += surcharge_actual_amount;
      }

      inclusiveTax += delivery_charge;
      return inclusiveTax;
    } else {
      return 0;
    }
  }

  void calculateItemTotal() {
    item_total = 0;
    for (var item in transaction.where((f) => f.status == 1)) {
      item_total += item.grand_price;
    }

    calculateMinCharge();
  }

  void calculateMinCharge() {
    try {
      if (dinein_table == null)
        min_charge = 0;
      else {
        double min_charge_with_charge_per_hour = minimum_charge + total_charge_per_hour!;
        double price = item_total;
        min_charge = (min_charge_with_charge_per_hour - price <= 0) ? 0 : min_charge_with_charge_per_hour - price;
      }

      calculateDiscountAmount();
    } catch (Exception) {}
  }

  // void calculateDiscountAmount() {
  //   try {
  //     if (discount_amount > 0) {
  //       double discountSum = 0;
  //       if (discount_percentage) {
  //         if (discount.items.length > 0) {
  //           for (var item in transaction.where((f) => f.status != 2)) {
  //             if (item.discountable) {
  //               discountSum += item.grand_price * (discount_amount / 100);
  //             }
  //           }
  //           discountSum += min_charge * (discount_amount / 100);
  //           discount_actual_amount = discountSum;
  //         } else {
  //           discount_actual_amount =
  //               sub_total_price >= (sub_total_price * (discount_amount / 100))
  //                   ? (sub_total_price * (discount_amount / 100))
  //                   : sub_total_price;

  //           // discount_actual_amount = (item_total + min_charge) >=
  //           //         (sub_total_price * (discount_amount / 100))
  //           //     ? (sub_total_price * (discount_amount / 100))
  //           //     : (item_total + min_charge);
  //         }
  //       } else {
  //         discount_actual_amount = (item_total + min_charge) >= discount_amount
  //             ? discount_amount
  //             : (item_total + min_charge);
  //       }
  //       // }
  //     } else
  //       discount_actual_amount = 0;

  //     calculateSurchargeAmount();
  //   } catch (ex) {
  //     print(ex.toString());
  //   }
  // }

  void calculateDiscountAmount() {
    try {
      if (discount_amount > 0) {
        double discount = 0;
        if (discount_percentage == true) {
          for (var item in transaction.where((f) => f.status != 2)) {
            if (item.discountable) {
              discount += item.grand_price * (discount_amount / 100);
            }
          }
          discount += (min_charge * (discount_amount / 100));
          discount_actual_amount = discount;
        } else {
          discount_actual_amount = ((item_total + min_charge) >= discount_amount ? discount_amount : (item_total + min_charge));
        }
        // }
      } else
        // ignore: curly_braces_in_flow_control_structures
        discount_actual_amount = 0;

      calculateSurchargeAmount();
    } catch (ex) {
      print(ex.toString());
    }
  }

  calculateSurchargeAmount() {
    try {
      if (surcharge_amount > 0) {
        if (surcharge_percentage) {
          double total = item_total + minimum_charge - discount_actual_amount;
          surcharge_actual_amount = Number.getDouble(total * (surcharge_amount / 100));
        } else {
          surcharge_actual_amount = surcharge_amount;
        }
      } else
        // ignore: curly_braces_in_flow_control_structures
        surcharge_actual_amount = 0;

      calculateTaxableAmount();
      calculateSubTotalPrice();
    } catch (Exception) {}
  }

  calculateTaxableAmount() {
    taxable1_amount = 0;
    taxable2_amount = 0;
    taxable3_amount = 0;
    for (var item in transaction) {
      if (item.status == 1) {
        if (item.apply_tax1) taxable1_amount += item.grand_price;

        if (item.apply_tax2) taxable2_amount += item.grand_price;

        if (item.apply_tax3) taxable3_amount += item.grand_price;
      }
    }

    //Add Min Charge
    taxable1_amount += min_charge;
    taxable2_amount += min_charge;
    taxable3_amount += min_charge;

    if (discount_percentage == false) // for cash discount
    {
      taxable1_amount -= discount_actual_amount;
      taxable2_amount -= discount_actual_amount;
      taxable3_amount -= discount_actual_amount;

      if (taxable1_amount < 0) taxable1_amount = 0;
      if (taxable2_amount < 0) taxable2_amount = 0;
      if (taxable3_amount < 0) taxable3_amount = 0;
    } else {
      taxable1_amount = 0;
      taxable2_amount = 0;
      taxable3_amount = 0;

      for (var item in transaction) {
        if (item.status == 1) {
          if (item.apply_tax1) if (item.discountable) {
            taxable1_amount += item.grand_price * ((100 - discount_amount) / 100);
          } else {
            taxable1_amount += item.grand_price;
          }

          if (item.apply_tax2) if (item.discountable) {
            taxable2_amount += item.grand_price * ((100 - discount_amount) / 100);
          } else {
            taxable2_amount += item.grand_price;
          }

          if (item.apply_tax3) if (item.discountable) {
            taxable3_amount += item.grand_price * ((100 - discount_amount) / 100);
          } else {
            taxable3_amount += item.grand_price;
          }
        }
      }
    }

    //Check Surcharge
    if (surcharge_apply_tax1) {
      taxable1_amount += surcharge_actual_amount;
    }
    if (surcharge_apply_tax2) {
      taxable2_amount += surcharge_actual_amount;
    }
    if (surcharge_apply_tax3) {
      taxable3_amount += surcharge_actual_amount;
    }
    //======================================

    //Add Delivery Charge
    taxable1_amount += delivery_charge;
    taxable2_amount += delivery_charge;
    taxable3_amount += delivery_charge;
    //======================================
  }

  calculateSubTotalPrice() {
    sub_total_price = item_total + min_charge - discount_actual_amount + surcharge_actual_amount + delivery_charge;

    calculateTotalTax();
  }

  calculateTotalTax() {
    try {
      for (var item in transaction) {
        if (item.apply_tax1) {
          item.tax1_amount = item.grand_price * (tax1 / 100);
        } else {
          item.tax1_amount = 0;
        }

        if (item.apply_tax2) {
          if (item.tax2_tax1) {
            item.tax2_amount = (item.grand_price + item.tax1_amount) * (tax2 / 100); // add tax 1 amount then calculate tax2
          } else {
            item.tax2_amount = item.grand_price * (tax2 / 100);
          }
        } else {
          item.tax2_amount = 0;
        }

        if (item.apply_tax3) {
          item.tax3_amount = (item.grand_price * tax3) / (100 + tax3);
        } else {
          item.tax3_amount = 0;
        }
      }

      total_tax = Number.getDouble(taxable1_amount * (tax1 / 100));
      if (tax2_tax1) taxable2_amount += total_tax;
      total_tax2 = Number.getDouble(taxable2_amount * (tax2 / 100));

      total_tax3 = Number.getDouble(taxable3_amount * tax3 / (100 + tax3));
    } catch (Exception) {
    } finally {
      calculateGrandTotalPrice();
    }
  }

  calculateRounding(double price) {
    try {
      double roundingTotal;
      if (Smallest_currency > 0)
        roundingTotal = Number.rounding(price, Smallest_currency, Round_Type);
      else
        roundingTotal = price;

      Rounding = Number.getDouble(roundingTotal) - Number.getDouble(price);
    } catch (ex) {}
  }

  void calculateGrandTotalPrice() {
    try {
      double price = sub_total_price + total_tax + total_tax2;

      if (price < 0) price = 0;
      calculateRounding(price);
      grand_price = (price + Rounding);

      calculateAmountTendered();
      footerUpdate.sinkValue(true);
    } catch (ex) {}
  }

  double amountTendered = 0;
  void calculateAmountTendered() {
    double amount = 0;
    print(payments);
    for (var item in payments) {
      if (item.status == 0) {
        // paid
        amount += item.actualAmountTendered;
      }
    }
    amountTendered = amount;
    calculateAmountBalance();
  }

  double amountBalance = 0;
  void calculateAmountBalance() {
    if (amountTendered - grand_price >= 0) {
      amountBalance = 0;
    } else {
      amountBalance = (grand_price - amountTendered).abs();
    }
    calculateAmountChange();
  }

  double amountChange = 0;
  void calculateAmountChange() {
    if (amountTendered - grand_price > 0) {
      amountChange = amountTendered - grand_price;
    } else {
      amountChange = 0;
    }
  }

  void addTag(String tag) {
    this.Label = tag;
    headerUpdate.sinkValue(true);
  }

  //return true if new value
  void addItem(mi.MenuItem value, Preference preference, double qty, double price, Employee employee) {
    OrderTransaction? last = lastTransaction();

    bool itemHasModifiers = false;

    for (var popup in value.popup_mod!) {
      if (itemHasModifiers) break;
      for (var mod in popup.modifiers) {
        if (mod.selected == true && mod.selected != null) {
          itemHasModifiers = true;
          break;
        }
      }
    }

    if (qty <= 0) qty = 1;

    int _qty = qty.truncate();
    if (last != null && _qty == 1 && !itemHasModifiers && last.increasble(value)) {
      last.increaseQty();
      itemUpdated.sinkValue(last);
    } else {
      transaction.add(OrderTransaction.fromItem(value, preference, qty, price, employee));

      if (this.discount != null && this.discount_percentage == true && this.discount!.items != null && this.discount!.items!.isNotEmpty) {
        if (this.discount!.items!.where((f) => f.menu_item_id == transaction.last.menu_item!.id).length > 0) {
          transaction.last.discountable = true;
        } else {
          transaction.last.discountable = false;
        }
      }
      itemAdded.sinkValue(transaction.last);
      itemSelected.setValue(transaction.last);
    }
    calculateItemTotal();

    itemQtyUpadate.sinkValue(transaction.length);
  }

  void addTransaction(OrderTransaction value) {
    OrderTransaction? last = lastTransaction();

    if (last != null && value.qty == 1 && value.modifiers!.length == 0 && value.sub_menu_item!.length == 0 && last.increasble_transaction(value)) {
      last.increaseQty();
    } else {
      transaction.add(value);
    }

    calculateItemTotal();
  }

  void addSubItem(mi.MenuItem? item, {double qty = 1}) {
    OrderTransaction? last = lastTransaction();
    if (last != null) {
      last.sub_menu_item!.add(TransactionCombo(menu_item: item, menu_item_id: item!.id, qty: qty, price: item.default_price));
      itemUpdated.sinkValue(last);
    }
  }

  void addSubItemModifier(MenuModifier modifier, bool isForced) {
    OrderTransaction? last = lastTransaction();
    if (last != null) {
      TransactionCombo? lastSubItem = last.lastSubItem();
      if (lastSubItem!.addModifer(modifier, isForced)) {
        last.calculateTotalPrice();
        itemUpdated.sinkValue(last);
        calculateItemTotal();
      }
    }
  }

  void addComboItemModifier(TransactionCombo comboItem, MenuModifier modifier, bool isForced) {
    OrderTransaction? last = lastTransaction();
    if (last != null) {
      if (comboItem.addModifer(modifier, isForced)) {
        last.calculateTotalPrice();
        itemUpdated.sinkValue(last);
        calculateItemTotal();
      }
    }
  }

  void addModifier(MenuModifier modifier, bool isForced) {
    OrderTransaction? last = lastTransaction();
    if (last != null) {
      if (last.addModifer(modifier, isForced)) {
        itemUpdated.sinkValue(last);
        calculateItemTotal();
      }
    }
  }

  void addModifierToSelectedTransaction(MenuModifier modifier, bool isForced) {
    OrderTransaction? transaction = itemSelected.value;
    if (transaction != null) {
      if (transaction.addModifer(modifier, isForced)) {
        itemUpdated.sinkValue(transaction);
        calculateItemTotal();
      }
    }
  }

  void addShortNote(String note, String price) {
    OrderTransaction? transaction = itemSelected.value;
    if (transaction != null) {
      transaction.addShortNote(note, price);
      itemUpdated.sinkValue(transaction);
      calculateItemTotal();
    }
  }

  void removeModifier(TransactionModifier temp) {
    OrderTransaction? last = lastTransaction();
    if (last != null) {
      if (temp != null && !temp.isForced) {
        last.removeModifer(temp);
        itemUpdated.sinkValue(last);
        calculateItemTotal();
      }
    }
  }

  void removeModifierToSelectedTransaction(TransactionModifier temp) {
    OrderTransaction? transaction = itemSelected.value;
    if (transaction != null) {
      // TransactionModifier temp = transaction.modifiers
      //     .firstWhere((f) => f.modifier.id == modifier.id, orElse: () => null);
      if (temp != null && !temp.isForced) {
        transaction.removeModifer(temp);
        itemUpdated.sinkValue(transaction);
        calculateItemTotal();
      }
    }
  }

  OrderTransaction? lastTransaction() {
    try {
      if (transaction.length > 0) {
        return transaction[transaction.length - 1];
      } else {
        return null;
      }
    } catch (Exception) {
      return null;
    }
  }

  String addPayment(double price, PaymentMethod method, int cashierId, int employeeId, {String reference = ""}) {
    if (Number.getDouble(grand_price) > Number.getDouble(amountTendered)) {
      if (method.type == 2 || method.type == 3) {
        if (price * method.rate > Number.getDouble(amountBalance)) return "over_tendered";
      }

      payments.add(OrderPayment.fromPayment(this, price, method, cashierId, employeeId, reference_: reference));
      calculateAmountTendered();
      if (Number.getDouble(amountTendered) >= Number.getDouble(grand_price)) {
        status = 3; //settled
        return "complete";
      }
    } else if (grand_price == 0 && price == 0) {
      return "complete";
    }
    return "";
  }

  @JsonKey(ignore: true)
  Property<bool> headerUpdate = Property<bool>();
  @JsonKey(ignore: true)
  Property<bool> footerUpdate = Property<bool>();
  @JsonKey(ignore: true)
  Property<OrderTransaction> itemSelected = Property<OrderTransaction>();
  @JsonKey(ignore: true)
  Property<OrderTransaction> itemAdded = Property<OrderTransaction>();
  @JsonKey(ignore: true)
  Property<OrderTransaction> itemUpdated = Property<OrderTransaction>();
  @JsonKey(ignore: true)
  Property<ItemDeleted> itemRemoved = Property<ItemDeleted>();
  @JsonKey(ignore: true)
  Property<int> itemQtyUpadate = Property<int>();

  void addDiscount(Discount? _discount) {
    if (_discount == null) return;
    if (_discount.id > 0) {
      discount = DiscountReference.fromDiscount(_discount);
      discount_id = _discount.id;
      discount_amount = _discount.amount;
      discount_percentage = _discount.is_percentage;

      if (discount_percentage == true && _discount.items!.length > 0) {
        // foreach (var item in transaction)
        // {
        //     if(_discount.items.Where(f=> f.menu_item_id == item.menu_item_id).Count() > 0)
        //     {
        //         item.discountable = true;
        //     }
        //     else
        //     {
        //         item.discountable = false;
        //     }
        // }

        for (var item in this.transaction) {
          if (_discount.items!.where((f) => f.menu_item_id == item.menu_item_id).length > 0) {
            item.discountable = true;
          } else {
            item.discountable = false;
          }
        }
      }

      if (item_total == 0) {
        calculateItemTotal();
      } else
        calculateDiscountAmount();
    }
  }

  void deleteDiscount() {
    discount = null;
    discount_id = null;
    discount_amount = 0;
    discount_percentage = false;
    if (item_total == 0) {
      calculateItemTotal();
    } else
      calculateDiscountAmount();
  }

  void addItemDiscount(Discount discount) {
    if (itemSelected.value != null) {
      itemSelected.value!.addDiscount(discount);
      itemUpdated.sinkValue(itemSelected.value ?? OrderTransaction());
      calculateItemTotal();
    }
  }

  void deleteItemDiscount() {
    if (itemSelected.value != null) {
      itemSelected.value!.deleteDiscount();
      itemUpdated.sinkValue(itemSelected.value ?? OrderTransaction());
      calculateItemTotal();
    }
  }

  void addSurcharge(Surcharge _surcharge) {
    if (_surcharge.id != null) {
      surcharge = SurchargeReference.fromSurcharge(_surcharge);
      surcharge_id = _surcharge.id;
      surcharge_amount = _surcharge.amount;
      surcharge_percentage = _surcharge.is_percentage;

      surcharge_apply_tax1 = _surcharge.apply_tax1;
      surcharge_apply_tax2 = _surcharge.apply_tax2;
      surcharge_apply_tax3 = _surcharge.apply_tax3;

      if (item_total == 0) {
        calculateItemTotal();
      } else
        calculateSurchargeAmount();
    }
  }

  void deleteSurcharge() {
    surcharge = null;
    surcharge_id = null;
    surcharge_amount = 0;
    surcharge_percentage = false;
    if (item_total == 0) {
      calculateItemTotal();
    } else
      calculateSurchargeAmount();
  }

  void removeItem(OrderTransaction _transaction) {
    int index = transaction.indexOf(_transaction);
    itemRemoved.sinkValue(ItemDeleted(item: _transaction, index: index));
    transaction.remove(_transaction);
    itemQtyUpadate.sinkValue(transaction.length);
    calculateItemTotal();
  }

  void removeLastItem() {
    itemRemoved.sinkValue(ItemDeleted(item: lastTransaction()!, index: transaction.length - 1));
    transaction.remove(lastTransaction());
    itemQtyUpadate.sinkValue(transaction.length);
    calculateItemTotal();
  }

  void increaseQty() {
    if (itemSelected.value != null) {
      itemSelected.value!.qty++;
      itemSelected.value!.calculateTotalPrice();
      itemUpdated.sinkValue(itemSelected.value ?? OrderTransaction());
      calculateItemTotal();
    }
  }

  void decreaseQty() {
    if (itemSelected.value != null && itemSelected.value!.qty > 1) {
      itemSelected.value!.qty--;
      itemSelected.value!.calculateTotalPrice();
      itemUpdated.sinkValue(itemSelected.value ?? OrderTransaction());
      calculateItemTotal();
    }
  }

  void holdUntilFire() {
    if (itemSelected.value != null) {
      itemSelected.value!.holdUntilFire();
      itemUpdated.sinkValue(itemSelected.value ?? OrderTransaction());
    }
  }

  void adjTransactionPrice(String price) {
    if (itemSelected.value != null) {
      if (price == "") return;
      itemSelected.value!.item_price = double.parse(price);
      itemSelected.value!.calculateTotalPrice();
      itemUpdated.sinkValue(itemSelected.value ?? OrderTransaction());
      calculateItemTotal();
    }
  }

  void adjTransactionQty(String qty) {
    if (itemSelected.value != null) {
      if (qty == "") return;
      itemSelected.value!.qty = double.parse(qty);
      itemSelected.value!.calculateTotalPrice();
      itemUpdated.sinkValue(itemSelected.value ?? OrderTransaction());
      calculateItemTotal();
    }
  }

  void reOrder() {
    OrderTransaction _transaction = itemSelected.value!.clone();
    _transaction.calculateTotalPrice();
    transaction.add(_transaction);
    itemAdded.sinkValue(transaction.last);
    itemSelected.setValue(transaction.last);
    calculateItemTotal();
  }

  void changeTotalChargePerHour(double charge) {
    total_charge_per_hour = charge;
    calculateMinCharge();
  }

  void dispose() {
    itemSelected.dispose();
    itemAdded.dispose();
    itemUpdated.dispose();
    itemRemoved.dispose();
  }

  void changeService(Service service) {
    this.service = ServiceReference.fromService(service);
    service_id = service.id;
    if (service_id != 1) {
      dinein_table = null;
      dinein_table_id = null;
    }
    headerUpdate.sinkValue(true);
  }

  void setCustomer(Customer _customer, String contact, String address) {
    customer_id_number = _customer.id_number;
    customer = CustomerReference.fromCustomer(_customer);
    customer_contact = contact;
    customer_address = address;
    headerUpdate.sinkValue(true);
  }

  void changeTable(DineInTable temp) {
    dinein_table = DineInTableReference.fromTable(temp);
    dinein_table_id = temp.id;
    headerUpdate.sinkValue(true);
  }

  void addOnlinePayment(PaymentMethod payment, int cashier_id, int employee_id) {
    if (payment != null && cashier_id != null && employee_id != null) {
      if (payments.length > 0) {
        payments.first.cashier_id = cashier_id;
        payments.first.employee_id = employee_id;
        payments.first.date_time = DateTime.now();
        payments.first.order_id = this.id;
        payments.first.method = payment;
      } else {
        this.payments.add(OrderPayment(cashier_id: cashier_id, employee_id: employee_id, date_time: DateTime.now(), order_id: this.id, method: payment, payment_method_id: payment.id));
      }
      this.status = 2;
    }
  }

  bool get isBalanceVisible {
    return amountBalance > 0 && amountBalance != grand_price;
  }

  set serverId(String value) {
    this.server_id = value;
  }

  String get serverId {
    return server_id;
  }
}

class ItemDeleted {
  int? index;
  OrderTransaction? item;
  ItemDeleted({this.item, this.index});
}

enum RoundingType { Normal, Negative, Postive }
