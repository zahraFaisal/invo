import 'package:invo_mobile/models/employee.dart';

abstract class EmployeeListEvent {}

class LoadEmployee extends EmployeeListEvent {}

class DeleteEmployee extends EmployeeListEvent {
 
  Employee employee;
  DeleteEmployee(this.employee);
}