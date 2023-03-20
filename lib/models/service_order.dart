class ServiceOrder {
  int order_count;
  int service_id;

  ServiceOrder({this.order_count = 0, this.service_id = 0});

  factory ServiceOrder.fromJson(Map<String, dynamic> json) {
    return ServiceOrder(
      order_count: json["order_count"],
      service_id: json["service_id"],
    );
  }

  factory ServiceOrder.fromMap(Map<String, dynamic> map) {
    ServiceOrder serviceOrder = ServiceOrder();
    serviceOrder.order_count = map['order_count'] ?? 0;
    serviceOrder.service_id = map['service_id'] ?? 0;
    return serviceOrder;
  }
}
