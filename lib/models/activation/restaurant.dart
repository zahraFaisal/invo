import './customer.dart';

class Restaurant {
  String restaurant_name;
  String restaurant_phone;
  int restaurant_type_id;
  int country_id;
  Customer? customer;

  Restaurant({this.restaurant_name = "", this.restaurant_phone = "", this.restaurant_type_id = 0, this.country_id = 0, this.customer}) {
    if (this.customer == null) this.customer = new Customer();
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    Restaurant restaurant = Restaurant();
    restaurant.restaurant_name = map['restaurant_name'];
    restaurant.restaurant_phone = map['restaurant_phone'];
    restaurant.restaurant_type_id = map['restaurant_type_id'];
    restaurant.country_id = map['country_id'];
    restaurant.customer = Customer.fromMap(map['customer']);
    return restaurant;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'restaurant_name': restaurant_name,
      'restaurant_phone': restaurant_phone,
      'restaurant_type_id': restaurant_type_id,
      'country_id': country_id,
      'customer': customer!.toMap(),
    };
    return map;
  }
}
