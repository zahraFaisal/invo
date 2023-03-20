import 'package:invo_mobile/models/employee.dart';

abstract class EmployeeFormEvent {}

class SaveEmployee extends EmployeeFormEvent{
  Employee employee;
  SaveEmployee(this.employee);
} 
