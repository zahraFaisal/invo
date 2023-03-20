import 'package:invo_mobile/models/custom/employee_list.dart';
import 'package:invo_mobile/models/employee.dart';

class IEmployeeService {
  Future<List<EmployeeList>>? getActiveList() {}
  Future<List<Employee>>? getList() {}

  Future<Employee>? get(int id) {}
  void save(Employee employee) {}
  void delete(int id) {}

  checkIfNameExists(Employee employee) {}
  Future<Employee>? getEmployeeByName(String name) {}
  Future<bool>? saveIfNotExists(List<Employee> employees) {}
}
