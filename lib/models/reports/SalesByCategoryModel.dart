import '../Number.dart';

class SalesByCategoryModel {
  String category;
  double orderSum;
  SalesByCategoryModel({this.category = "", this.orderSum = 0});
  factory SalesByCategoryModel.fromMap(Map<String, dynamic> map) {
    SalesByCategoryModel salesByCategoryModel = SalesByCategoryModel();
    salesByCategoryModel.category = map['category'];
    salesByCategoryModel.orderSum = map['orderSum'];
    return salesByCategoryModel;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'Category': category,
      'Total': orderSum,
    };
    return map;
  }

  String get orderTotalPrice {
    return Number.formatCurrency(orderSum);
  }
}
