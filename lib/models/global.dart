import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/cashier.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/views/order/widgets/popup_modifiers.dart';

class Global {
  Employee? _authEmployee;
  Cashier? _authCashier;
  late Service selectedService;
  Bool2VoidFunc? onEmployeeChange;

  setEmployee(Employee? employee) {
    _authEmployee = employee;
    if (onEmployeeChange != null) onEmployeeChange!(true);
  }

  Employee? get authEmployee {
    return _authEmployee;
  }

  setCashier(Cashier? cashier) {
    _authCashier = cashier;
  }

  Cashier? get authCashier {
    return _authCashier;
  }
}
