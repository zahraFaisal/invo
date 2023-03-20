class DailySalesModel {
  String year;
  String month;
  String day;
  double orderSum;
  int totalOrder;
  DailySalesModel({this.day = "", this.month = "", this.year = "", this.orderSum = 0, this.totalOrder = 0});

  factory DailySalesModel.fromMap(Map<String, dynamic> map) {
    DailySalesModel dailySalesModel = DailySalesModel();
    dailySalesModel.year = map['year'];
    dailySalesModel.month = map['month'];
    dailySalesModel.day = map['day'];
    dailySalesModel.orderSum = map['orderSum'];
    dailySalesModel.totalOrder = map['totalOrder'];
    return dailySalesModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'year': year,
      'month': month,
      'day': day,
      'daily': day + '/' + monthName + '/' + year,
      'order_sum': orderSum,
      'total_order': totalOrder
    };
    return map;
  }

  String get monthName {
    switch (month) {
      case '01':
        return "Junaury";
        break;
      case '02':
        return "February";
        break;
      case '03':
        return "March";
        break;
      case '04':
        return "April";
        break;
      case '05':
        return "May";
        break;
      case '06':
        return "June";
        break;
      case '07':
        return "July";
        break;
      case '08':
        return "Augest";
        break;
      case '09':
        return "September";
        break;
      case '10':
        return "October";
        break;
      case '11':
        return "November";
        break;
      case '12':
        return "December";
        break;
      default:
    }
    return "";
  }

  String get date {
    return day + "-" + monthName + "-" + year;
  }
}
