import 'package:invo_mobile/helpers/misc.dart';

class TableStatus {
  int orderCount;
  bool bill_printed;
  DateTime? open_date;
  int table_id;

  TableStatus({this.orderCount = 0, this.bill_printed = false, this.open_date, this.table_id = 0});

  factory TableStatus.fromJson(Map<String, dynamic> json) {
    TableStatus temp = TableStatus(orderCount: json['OrderCount'], bill_printed: json['bill_printed'], table_id: json['table_id']);

    String openDate = json['open_date'];

    temp.open_date = DateTime.fromMillisecondsSinceEpoch(int.parse(openDate.substring(6, openDate.length - 7)));

    return temp;
  }

  factory TableStatus.fromMap(Map<String, dynamic> map) {
    TableStatus tableStatus = TableStatus();
    DateTime? _openDate = (map.containsKey('open_date') && map['open_date'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['open_date']) : null;

    tableStatus.orderCount = map['OrderCount'] ?? 0;
    tableStatus.table_id = map['table_id'] ?? 0;
    tableStatus.open_date = _openDate;
    tableStatus.bill_printed = (map["bill_printed"] == 1) ? true : false;
    return tableStatus;
  }

  String get openOrderSince {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(open_date!);

    return Misc.sinceDate(difference);
  }

  int get tableStatus {
    if (orderCount > 0) {
      if (bill_printed == true) {
        return 4;
      } else {
        return 2;
      }
    } else {
      return 1;
    }
  }

  // enum status
  // {
  //     Available = 1,
  //     Busy = 2,
  //     Reserved = 3,
  //     Bill_Printed = 4
  // }
}
