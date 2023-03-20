class SalesByHoursModel {
  int hour;
  double orderSum;
  int totalOrder;

  // SalesByHoursModel(int i, int i, int i, {this.hour = 0, this.orderSum = 0, this.totalOrder = 0});
  SalesByHoursModel({this.hour = 0, this.orderSum = 0, this.totalOrder = 0});

  factory SalesByHoursModel.fromMap(Map<String, dynamic> map) {
    SalesByHoursModel salesByHoursModel = SalesByHoursModel();
    DateTime x = DateTime.fromMillisecondsSinceEpoch(map['date_time']);
    salesByHoursModel.hour = x.hour;
    salesByHoursModel.orderSum = map['orderSum'];
    salesByHoursModel.totalOrder = map['totalOrder'];
    return salesByHoursModel;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'hour': hours,
      'order_sum': orderSum,
      'total_order': totalOrder,
    };
    return map;
  }

  get hours {
    if (hour != null) {
      if (hour < 10) {
        return "0" + hour.toString() + ":00";
      } else {
        return hour.toString() + ":00";
      }
    } else
      return "";
  }
}

class Orderly {
  int? id;
  double? grand_price;
  Orderly.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    grand_price = map['grand_price'];
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{'id': id, 'grand_price': grand_price};
    return map;
  }
}
