import '../Number.dart';

class SalesByServiceModel {
  int serviceId;
  String alternative;
  String service;
  double orderSum;
  int totalOrder;
  SalesByServiceModel({
    this.serviceId = 0,
    this.alternative = "",
    this.service = "",
    this.orderSum = 0,
    this.totalOrder = 0,
  });

  factory SalesByServiceModel.fromMap(Map<String, dynamic> map) {
    SalesByServiceModel salesByServiceModel = SalesByServiceModel();
    salesByServiceModel.serviceId = map['serviceId'];
    salesByServiceModel.alternative = map['alternative'];
    salesByServiceModel.service = map['service'];
    salesByServiceModel.orderSum = map['orderSum'];
    salesByServiceModel.totalOrder = map['totalOrder'] ?? 0;
    return salesByServiceModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'serviceId': serviceId,
      'alternative': alternative,
      'service': service,
      'order_sum': orderSum,
      'total_order': totalOrder,
      'Service_name': serviceName
    };
    return map;
  }

  String? get serviceName {
    if (alternative == "" || alternative == null) {
      return service;
    }
    return alternative;
  }

  String get orderTotalPrice {
    return Number.formatCurrency(orderSum);
  }
}
