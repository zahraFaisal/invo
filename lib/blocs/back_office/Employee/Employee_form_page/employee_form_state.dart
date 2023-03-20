
import 'package:invo_mobile/models/employee.dart';

abstract class EmployeeLoadState {}

class EmployeeIsLoading extends EmployeeLoadState {}

class EmployeeIsLoaded extends EmployeeLoadState {
  final Employee employee;
  EmployeeIsLoaded(this.employee);
}