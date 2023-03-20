import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/discount.dart';

class CategorySalesModel {
  String category;
  double itemQty;
  double orderSum;
  double percentage;
  CategorySalesModel({this.category = "", this.itemQty = 0, this.orderSum = 0, this.percentage = 0});
  factory CategorySalesModel.fromMap(Map<String, dynamic> map) {
    CategorySalesModel categorySalesModel = CategorySalesModel();
    categorySalesModel.category = map['category'];
    categorySalesModel.itemQty = map['itemQty'];
    categorySalesModel.orderSum = map['orderSum'];
    categorySalesModel.percentage = map['percentage'];
    return categorySalesModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'Category': category,
      'Item_qty': itemQty,
      'order_sum': orderSum,
      'Percentage': percentage,
    };
    return map;
  }

  factory CategorySalesModel.fromJson(Map<String, dynamic> json) {
    return CategorySalesModel(
      category: json['category'],
      itemQty: json['itemQty'],
      orderSum: json['orderSum'],
      percentage: json['percentage'],
    );
  }
  String get totalprice {
    return Number.formatCurrency(orderSum);
  }
}

class PaymentMethodSalesModel {
  String? name;
  double? amountPaid;
  double? percentage;
  int? totalTransaction;

  PaymentMethodSalesModel.fromMap(Map<String, dynamic> map) {
    name = (map['name'] == null) ? "card" : map['name'];
    amountPaid = (map['amountPaid'] == null) ? 0 : map['amountPaid'];
    percentage = (map['percentage'] == null) ? 0 : map['percentage'];
    totalTransaction = (map['totalTransaction'] == null) ? 0 : map['totalTransaction'];
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'name': name,
      'amount_paid': amountPaid,
      'Percentage': percentage,
      'total_transaction': totalTransaction,
      'totalprice': totalprice
    };
    return map;
  }

  String get totalprice {
    return Number.formatCurrency(amountPaid!);
  }
}

class SummaryModel {
  double? totalVoids;
  double? minimumCharge;
  double? totalDeliveryCharge;
  double? totalDiscount;
  double? totalRounding;
  double? totalTax3;
  double? netsale;
  double? items_total;
  int? total_guests;
  int? total_order;
  double? _total;

  SummaryModel(this.totalVoids, this.minimumCharge, this.totalDiscount, this.totalDeliveryCharge, this.totalRounding, this.totalTax3,
      this.items_total, this.total_guests);
  SummaryModel.fromMap(Map<String, dynamic> map) {
    totalVoids = (map['totalVoids'] == null) ? 0.0 : map['totalVoids'];
    minimumCharge = map['minimumCharge'] ?? 0.0;
    totalDeliveryCharge = map['totalDeliveryCharge'] ?? 0.0;
    totalDiscount = map['totalDiscount'] ?? 0.0;
    totalRounding = map['totalRounding'] ?? 0.0;
    totalTax3 = map['totalTax3'] ?? 0.0;
    items_total = map['items_total'] ?? 0.0;
    total_guests = map['total_guests'] ?? 0;
    netsale = (map['netsale'] == null) ? 0.0 : map['netsale'];
    total_order = map['total_order'] ?? 0;
    _total = map['_total'] ?? 0.0;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'totalVoids': totalVoids,
      'minimumCharge': minimumCharge,
      'totalDiscount': totalDiscount,
      'totalDeliveryCharge': totalDeliveryCharge,
      'totalRounding': totalRounding,
      'totalTax3': totalTax3,
      'total_order': total_order,
      'items_total': items_total,
      'total_guest': total_guests,
      'total_qty': items_total,
      'netsale': netsale,
      '_total_tax3': totalTax3,
      '_total_rounding': totalRounding,
      '_total_void': totalVoids,
      '_total_minimum_charge': minimumCharge,
      '_total_discount_amount': totalDiscount,
      '_total': _total
    };
    return map;
  }

  String get totalvoid {
    return Number.formatCurrency(totalVoids!);
  }

  String get mincharge {
    return Number.formatCurrency(minimumCharge!);
  }

  String get deliveryCharge {
    return Number.formatCurrency(totalDeliveryCharge!);
  }

  String get discount {
    return Number.formatCurrency(totalDiscount!);
  }

  String get rounding {
    return Number.formatCurrency(totalRounding!);
  }

  String get collectedRAT {
    return Number.formatCurrency(totalTax3!);
  }

  String get totalSale {
    return Number.formatCurrency(netsale!);
  }

  String get avgOrderSale {
    return Number.formatCurrency((_total! / total_order!).isNaN ? 0.0 : (_total! / total_order!));
  }

  String get avgGuestSale {
    return Number.formatCurrency((_total! / total_guests!).isNaN ? 0.0 : (_total! / total_guests!));
  }
}

class DiscountModel {
  String? name;
  int? noOfOrders;
  double? discountAmount;

  DiscountModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    noOfOrders = map['noOfOrders'] ?? 0;
    discountAmount = map['discountAmount'] ?? 0.0;
  }
  String get discount {
    return Number.formatCurrency(discountAmount!);
  }
}
