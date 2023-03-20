import 'package:invo_mobile/models/role.dart';

class Employee {
  int id = 0;
  Role? job_title;
  String? phone1;
  String? phone2;
  String? email;
  String? address1;
  String? address2;
  DateTime? date_hierd;
  DateTime? date_released;
  DateTime? birth_date;
  String? msc_code;
  String name;
  String? gender;
  int? job_title_id_number;

  String? nick_name;
  String? password;
  String? social_number;
  bool in_active = false;
  Employee({
    this.id = 0,
    this.name = "",
    this.job_title,
    this.phone1,
    this.phone2,
    this.address1,
    this.address2,
    this.date_hierd,
    this.date_released,
    this.birth_date,
    this.msc_code,
    this.gender,
    this.job_title_id_number,
    this.nick_name,
    this.password,
    this.social_number,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    Role job_title = Role.fromJson(json['job_title'] ?? <String, dynamic>{});

    return Employee(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        job_title: job_title,
        job_title_id_number: json['job_title_id_number'] ?? 0,
        nick_name: json['nick_name'] ?? "",
        password: json['password'] ?? "",
        social_number: json['social_number'] ?? "");
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'name': name,
      'gender': gender,
      'phone1': phone1,
      'email': email,
      'phone2': phone2,
      'address1': address1,
      'address2': address2,
      'date_hierd': date_hierd == null ? null : date_hierd?.toUtc().millisecondsSinceEpoch,
      'date_released': date_released == null ? null : date_released?.toUtc().millisecondsSinceEpoch,
      'birth_date': birth_date == null ? null : birth_date?.toUtc().millisecondsSinceEpoch,
      'msc_code': msc_code,
      'job_title_id_number': job_title_id_number,
      'nick_name': nick_name,
      'password': password,
      'social_number': social_number,
      'in_active': in_active == true ? 1 : 0
    };
    return map;
  }

  factory Employee.fromMap(Map<String, dynamic>? map) {
    if (map != null) {
      Employee employee = Employee(id: map['id'] ?? 0, name: map['name']);
      employee.gender = map['gender'];
      employee.phone1 = map['phone1'];
      employee.phone2 = map['phone2'];
      employee.email = map['email'];
      employee.address1 = map['address1'];
      employee.address2 = map['address2'];
      employee.date_hierd = map['date_hierd'] == null ? null : DateTime.fromMicrosecondsSinceEpoch(map['date_hierd']);
      employee.date_released = map['date_released'] == null ? null : DateTime.fromMicrosecondsSinceEpoch(map['date_released']);
      employee.birth_date = map['birth_date'] == null ? null : DateTime.fromMicrosecondsSinceEpoch(map['birth_date']);
      employee.msc_code = map['msc_code'];
      employee.job_title_id_number = int.parse(map['job_title_id_number'].toString());
      employee.nick_name = map['nick_name'];
      employee.password = map['password'];
      employee.social_number = map['social_number'] == null ? 0 : map['social_number'];
      employee.in_active = (map['in_active'] == 1) ? true : false;
      return employee;
    } else {
      throw ArgumentError('Data is null');
    }
  }
  void setDateHired(DateTime date) {
    date_hierd = date;
  }

  void setDateReleased(DateTime date) {
    date_released = date;
  }

  void setBirthDate(DateTime date) {
    birth_date = date;
  }

  String getName() {
    String name = "";
    if (nick_name != null) {
      name = nick_name!;
    } else {
      name = this.name;
    }
    return name;
  }

  int get_security(int pos) {
    try {
      if (id == 1) return 1; //if owner always has access

      if (job_title != null && job_title?.security == null) {
        return 0;
      }

      if (job_title != null && job_title?.security != null) {
        return int.parse(job_title!.security.split("")[pos]);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  int get New_Order_Security {
    return get_security(0);
  }

  int get Edit_Order_Security {
    return get_security(1);
  }

  int get Print_Order_Security {
    return get_security(3);
  }

  int get FollowUp_Order_Security {
    return get_security(6);
  }

  int get Void_Order_Security {
    return get_security(7);
  }

  int get Discount_Order_Security {
    return get_security(8);
  }

  int get Surcharge_Order_Security {
    return get_security(9);
  }

  int get DineIn_Security {
    return get_security(13);
  }

  int get TakeAway_Security {
    return get_security(14);
  }

  int get DriveThru_Security {
    return get_security(15);
  }

  int get Delivery_Security {
    return get_security(16);
  }

  int get Change_Item_Price_Security {
    return get_security(17);
  }

  int get Show_Setting_Section {
    return get_security(25);
  }

  int get Search_Security {
    return get_security(91);
  }
}
