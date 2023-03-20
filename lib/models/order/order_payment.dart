import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/payment_method.dart';

class OrderPayment {
  int id = 0;
  DateTime? date_time;
  int order_id;
  int employee_id;
  int cashier_id;
  double amount_tendered;
  double amount_paid;
  double actual_amount_paid;
  double rate;
  String reference;
  int status;
  PaymentMethod? method;
  int? payment_method_id;

  String onlineData;
  String onlineService;

  OrderPayment({
    this.id = 0,
    this.date_time,
    this.order_id = 0,
    this.employee_id = 0,
    this.cashier_id = 0,
    this.amount_tendered = 0,
    this.amount_paid = 0,
    this.actual_amount_paid = 0,
    this.rate = 0,
    this.reference = "", //add verfication code here
    this.onlineService = "",
    this.onlineData = "",
    this.status = 0,
    this.method,
    this.payment_method_id = 0,
  });

  factory OrderPayment.fromPayment(OrderHeader _order, double _price, PaymentMethod _method, int _cashierId, int _employeeId,
      {String reference_ = ""}) {
    OrderPayment temp = OrderPayment();

    temp.id = 0;
    if (temp.rate == 0) temp.rate = 1;
    temp.date_time = DateTime.now();

    if (_order.status == 6) {
      //reopen
      var firstPayment = _order.payments.first;
      if (firstPayment != null && firstPayment.status == 1) {
        temp.cashier_id = firstPayment.cashier_id;
      } else {
        temp.cashier_id = _cashierId;
      }
    } else {
      temp.cashier_id = _cashierId;
    }

    temp.order_id = _order.id;
    temp.employee_id = _employeeId;

    if (_method != null) {
      temp.rate = _method.rate;
      temp.payment_method_id = _method.id;
      temp.method = _method;
    } else {
      temp.payment_method_id = null;
      temp.method = null;
    }

    temp.amount_tendered = _price;
    temp.amount_paid = _price;
    temp.status = 0; //paid
    //If Payment type cash
    if (_method != null && _method.type == 1 && _order.amountBalance < temp.amount_paid) temp.amount_paid = (_order.amountBalance / _method.rate);
    temp.reference = reference_;
    return temp;
  }

  double get actualAmountTendered {
    return amount_tendered * rate;
  }

  double get actualAmountPaid {
    return amount_paid * rate;
  }

  double get amountBalance {
    return actualAmountTendered - actualAmountPaid;
  }

  dynamic getProp(String key) {
    Map<String, dynamic> map = this.toMap();
    map['payment_method'] = method;
    map['actual_amount_paid'] = amount_paid * rate;
    return map[key];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'id': id,
      'order_id': order_id,
      'date_time': date_time == null
          ? null
          : ("/Date(" + (date_time!.millisecondsSinceEpoch + new DateTime.now().timeZoneOffset.inMilliseconds).toString() + ")/"),
      'employee_id': employee_id,
      'cashier_id': cashier_id,
      'amount_tendered': amount_tendered,
      'amount_paid': amount_paid,
      'rate': rate,
      'status': status,
      'payment_method_id': payment_method_id,
      'payment_method': {'id': method!.id, 'name': method?.name},
    };

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        map[key] = value;
      }
    }

    writeNotNull('reference', reference);

    return map;
  }

  factory OrderPayment.fromJson(json) {
    DateTime _dateTime;
    if (json['date_time'] == null) {
      _dateTime = DateTime.now();
    } else if (json['date_time'].toString().contains('Date')) {
      _dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['date_time'].substring(6, json['date_time'].length - 7)));
    } else {
      _dateTime = DateTime.fromMillisecondsSinceEpoch(json['date_time']);
    }

    PaymentMethod? _payment = (json.containsKey('payment_method')) ? PaymentMethod.fromJson(json['payment_method']) : null;

    return OrderPayment(
        id: json['id'] ?? 0,
        date_time: _dateTime,
        onlineService: json['onlineService'] ?? "",
        onlineData: json['onlineData'] ?? "",
        order_id: json['order_id'] ?? 0,
        employee_id: json['employee_id'] ?? 0,
        cashier_id: json['cashier_id'] ?? 0,
        amount_tendered: json['amount_tendered'] != null ? double.parse(json['amount_tendered'].toString()) : 0.0,
        amount_paid: json['amount_paid'] != null ? double.parse(json['amount_paid'].toString()) : 0.0,
        rate: json['rate'] != null ? double.parse(json['rate'].toString()) : 0.0,
        reference: json['reference'] ?? "",
        status: json['status'] ?? 0,
        payment_method_id: json['payment_method_id'] ?? 0,
        method: _payment);
  }

  Map<String, dynamic> toMap() {
    int? _dateTime = (date_time == null || date_time!.toUtc().millisecondsSinceEpoch == null) ? null : date_time!.toUtc().millisecondsSinceEpoch;

    var map = <String, dynamic>{
      "id": id == 0 ? null : id,
      'order_id': order_id,
      'date_time': _dateTime,
      'employee_id': employee_id,
      'onlineService': onlineService,
      'onlineData': onlineData,
      'cashier_id': cashier_id,
      'amount_tendered': amount_tendered,
      'amount_paid': amount_paid,
      'rate': rate,
      'reference': reference,
      'status': status,
      'payment_method_id': payment_method_id,
    };
    return map;
  }

  factory OrderPayment.fromMap(Map<String, dynamic> map) {
    OrderPayment orderPayment = OrderPayment();
    orderPayment.id = map['id'] ?? 0;
    orderPayment.cashier_id = map['cashier_id'] ?? 0;
    orderPayment.date_time = DateTime.fromMillisecondsSinceEpoch(map['date_time']);
    orderPayment.order_id = map['order_id'] ?? 0;
    orderPayment.employee_id = map['employee_id'] ?? 0;
    orderPayment.amount_tendered = map['amount_tendered'] ?? 0;
    orderPayment.amount_paid = map['amount_paid'] ?? 0;
    orderPayment.reference = map['reference'] ?? "";
    orderPayment.status = map['status'] ?? 0;
    orderPayment.rate = map['rate'] ?? 0;
    orderPayment.payment_method_id = map['payment_method_id'] ?? 0;
    return orderPayment;
  }
}
