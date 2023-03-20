class EmployeeList {
  int id;
  String name;
  String role;

  EmployeeList({this.id = 0, this.name = "", this.role = ""});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'role': role,
    };
    return map;
  }

  factory EmployeeList.fromMap(Map<String, dynamic> map) {
    EmployeeList employeeList = EmployeeList();
    employeeList.id = map['id'] ?? 0;
    employeeList.name = map['name'] ?? "";
    employeeList.role = map['role'] ?? "";
    return employeeList;
  }
}
