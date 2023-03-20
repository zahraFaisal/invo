import 'package:invo_mobile/models/order/employee_reference.dart';

class CashierReference {
  int id;
  DateTime? cashier_in;
  DateTime? cashier_out;
  EmployeeReference? employee;
  int employee_id;
  int terminal_id;

  CashierReference({
    this.id = 0,
    this.cashier_in,
    this.cashier_out,
    this.employee,
    this.employee_id = 0,
    this.terminal_id = 0,
  });

  factory CashierReference.fromMap(Map<String, dynamic> map) {
    CashierReference cashierReference = CashierReference();
    cashierReference.id = map['id'];
    cashierReference.cashier_in = map['cashier_in'];
    cashierReference.cashier_out = map['cashier_out'];
    cashierReference.employee = map['employee'];
    cashierReference.employee_id = map['employee_id'] ?? 0;
    cashierReference.terminal_id = map['terminal_id'] ?? 0;

    return cashierReference;
  }

  factory CashierReference.fromJson(Map<String, dynamic> json) {
    return CashierReference(
      id: json['id'],
      cashier_in: json['cashier_in'],
      cashier_out: json['cashier_out'],
      employee: json['employee'],
      employee_id: json['employee_id'] ?? 0,
      terminal_id: json['terminal_id'] ?? 0,
    );
  }
}
