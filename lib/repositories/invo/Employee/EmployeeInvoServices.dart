import 'package:invo_mobile/models/custom/employee_list.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/repositories/interface/Employee/IEmployeeService.dart';

class EmployeeInvoService implements IEmployeeService {
  @override
  checkIfNameExists(Employee employee) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }

  @override
  Future<Employee> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Employee> getEmployeeByName(String name) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<Employee> employees) {
    throw UnimplementedError();
  }

  @override
  Future<List<EmployeeList>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<Employee>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(Employee employee) {
    // TODO: implement save
  }
}
