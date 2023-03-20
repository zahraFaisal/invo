import 'cashier_detail.dart';

class Cashier {
  int id;
  int? employee_id;
  int? terminal_id;
  DateTime? cashier_in;
  DateTime? cashier_out;
  double? start_amount;
  double? end_amount;
  double? variance_amount;
  String? variance_reason;
  int? approved_employee_id;

  List<CashierDetail>? details = [];
  Cashier(
      {required this.id,
      this.employee_id,
      this.terminal_id,
      this.cashier_in,
      this.cashier_out,
      this.start_amount,
      this.end_amount,
      this.variance_amount,
      this.variance_reason,
      this.approved_employee_id,
      this.details});

  Map<String, dynamic> toJson() {
    try {
      var map = <String, dynamic>{
        'id': id == null ? 0 : id,
        'employee_id': employee_id,
        'terminal_id': terminal_id,
        'cashier_in': (cashier_in == null)
            ? null
            : "/Date(" + (cashier_in!.millisecondsSinceEpoch + new DateTime.now().timeZoneOffset.inMilliseconds).toString() + ")/",
        'start_amount': start_amount,
        'end_amount': end_amount,
        'variance_amount': variance_amount,
      };

      void writeNotNull(String key, dynamic value) {
        if (value != null) {
          map[key] = value;
        }
      }

      if (cashier_out != null) {
        writeNotNull(
            'cashier_out', "/Date(" + (cashier_out!.millisecondsSinceEpoch + DateTime.now().timeZoneOffset.inMilliseconds).toString() + ")/");
      }
      writeNotNull('variance_reason', variance_reason);
      writeNotNull('approved_employee_id', approved_employee_id);

      List<Map<String, dynamic>> temp = List<Map<String, dynamic>>.empty(growable: true);
      for (var item in details!) {
        // ignore: prefer_conditional_assignment
        if (item.cashier_id == null) {
          item.cashier_id = 0;
        }
        temp.add(item.toJson());
      }
      map['details'] = temp;
      return map;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'employee_id': employee_id,
      'terminal_id': terminal_id,
      'cashier_in': (cashier_in == null) ? null : cashier_in!.toUtc().millisecondsSinceEpoch,
      'cashier_out': (cashier_out == null) ? null : cashier_out!.toUtc().millisecondsSinceEpoch,
      'start_amount': start_amount,
      'end_amount': end_amount,
      'variance_amount': variance_amount,
      'variance_reason': variance_reason,
      'approved_employee_id': approved_employee_id,
    };
    return map;
  }

  factory Cashier.fromMap(Map<String, dynamic> map) {
    Cashier cashier = Cashier(id: map['id']);

    cashier.employee_id = map['employee_id'];
    cashier.terminal_id = map['terminal_id'];
    cashier.cashier_in = map['cashier_in'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['cashier_in'], isUtc: true);
    cashier.cashier_out = map['cashier_out'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['cashier_out'], isUtc: true);
    cashier.start_amount = map['start_amount'];
    cashier.end_amount = map['end_amount'];
    cashier.variance_amount = map['variance_amount'];
    cashier.variance_reason = map['variance_reason'];
    cashier.approved_employee_id = map['approved_employee_id'];
    return cashier;
  }

  factory Cashier.fromJson(Map<String, dynamic> json) {
    List<CashierDetail> _cashierDetail = List<CashierDetail>.empty(growable: true);
    if (json.containsKey('details') && json['details'] != null)
      // ignore: curly_braces_in_flow_control_structures
      for (var item in json['details']) {
        _cashierDetail.add(CashierDetail.fromJson(item));
      }

    DateTime _cashierIn = DateTime.fromMillisecondsSinceEpoch(int.parse(json['cashier_in'].substring(6, json['cashier_in'].length - 7)));

    DateTime _cashierOut = DateTime.now();
    if (json.containsKey('cashier_out') && json['cashier_out'] != null) {
      _cashierOut = DateTime.fromMillisecondsSinceEpoch(int.parse(json['cashier_out'].substring(6, json['cashier_out'].length - 7)));
    }

    return Cashier(
      id: json['id'],
      employee_id: json['employee_id'],
      terminal_id: json['terminal_id'],
      cashier_in: _cashierIn,
      cashier_out: _cashierOut,
      start_amount: double.parse(json['start_amount'] == null ? "0" : json['start_amount'].toString()),
      end_amount: double.parse(json['end_amount'] == null ? "0" : json['end_amount'].toString()),
      variance_amount: double.parse(json['variance_amount'] == null ? "0" : json['variance_amount'].toString()),
      variance_reason: json['variance_reason'],
      approved_employee_id: json['approved_employee_id'],
      details: _cashierDetail,
    );
  }
}
