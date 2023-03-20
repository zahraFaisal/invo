import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:invo_mobile/models/custom/employee_list.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/repositories/interface/Employee/IEmployeeService.dart';
import 'package:sqflite/sqflite.dart';

import '../sqlite_repository.dart';

class EmployeeService implements IEmployeeService {
  @override
  Future<List<EmployeeList>> getActiveList() async {
    List<EmployeeList> employees = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery(
        "Select employees.id, employees.name, roles.name as role from Employees left join roles on roles.id = job_title_id_number where employees.in_active=0");
    for (var item in result) {
      employees.add(new EmployeeList.fromMap(item));
    }
    return employees;
  }

  Future<List<Employee>> getList() async {
    List<Employee> employees = [];

    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.query("Employees");
    for (var employee in result) {
      employees.add(new Employee.fromMap(employee));
    }
    return employees;
  }

  Future<Employee> get(int id) async {
    Database? database = await SqliteRepository().db;
    Map<String, dynamic> employee = (await database!.query("Employees", where: "id = ?", whereArgs: [id])).first;
    return Employee.fromMap(employee);
  }

  Future<Employee> getEmployeeByName(String name) async {
    Database? database = await SqliteRepository().db;
    var temp = await database!.query("Employees", where: "name = ?", whereArgs: [name]);
    Map<String, dynamic>? employee;
    if (temp.isNotEmpty) {
      employee = temp[0];
    }
    return employee != null ? Employee.fromMap(employee) : Employee(name: name);
  }

  @override
  void save(Employee employee) async {
    final Database? database = await SqliteRepository().db;
    int result;
    {
      result = await database!.insert('Employees', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  void delete(int id) async {
    final Database? database = await SqliteRepository().db;
    var result = await database!.rawUpdate('UPDATE  Employees  SET in_Active = ? WHERE id =?', ['1', id]);
  }

  @override
  Future<bool> checkIfNameExists(Employee employee) async {
    Database? database = await SqliteRepository().db;
    List<Map<String, dynamic>> result = await database!.rawQuery("Select Count(*) as count from Employees where id != ? and lower(name) = ?",
        [employee.id == null ? 0 : employee.id, employee.name.toLowerCase()]);

    if (result[0]["count"] > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveIfNotExists(List<Employee> employees) async {
    try {
      final Database? database = await SqliteRepository().db;
      var found = false;
      for (var employee in employees) {
        found = await checkIfNameExists(employee);
        if (!found) {
          await database!.insert('Employees', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}
