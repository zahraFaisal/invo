import '../Number.dart';

class SalesByItemModel {
  String name;
  double totalQty;
  String barcode;
  String? category;
  double totalSale;

  SalesByItemModel({this.name = "", this.totalQty = 0, this.barcode = "", this.category = "", this.totalSale = 0});
  factory SalesByItemModel.fromMap(Map<String, dynamic> map) {
    SalesByItemModel salesByItemModel = SalesByItemModel();
    salesByItemModel.name = map['name'];
    salesByItemModel.totalQty = map['totalQty'];
    salesByItemModel.category = map['category'];
    salesByItemModel.barcode = map['barcode'];
    salesByItemModel.totalSale = map['totalSale'];
    return salesByItemModel;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{'Name': name, 'total_qty': totalQty, 'Barcode': barcode, 'Category': category, 'TotalSale': totalSale};
    return map;
  }

  String get orderTotalPrice {
    return Number.formatCurrency(totalSale);
  }
}

class SalesByItemDetails {
  double? Discount;
  double? Surcharge;
  double? SubTotal;
  double? Minimum_charge;
  double? Delivery_Charge;
  double? ChargePerHour;
  double? GrandTotal;
  double? TotalTax;
  double? TotalRounding;

  SalesByItemDetails.fromMap(Map<String, dynamic> map) {
    Discount = map['Discount'] == null ? 0.0 : double.parse(map['Discount'].toString());
    Surcharge = map['Surcharge'] == null ? 0.0 : double.parse(map['Surcharge'].toString());
    SubTotal = map['SubTotal'] == null ? 0.0 : double.parse(map['SubTotal'].toString());
    Minimum_charge = map['Minimum_charge'] == null ? 0.0 : double.parse(map['Minimum_charge'].toString());
    Delivery_Charge = map['Delivery_Charge'] == null ? 0.0 : double.parse(map['Delivery_Charge'].toString());
    ChargePerHour = map['ChargePerHour'] == null ? 0.0 : double.parse(map['ChargePerHour'].toString());
    GrandTotal = map['GrandTotal'] == null ? 0.0 : double.parse(map['GrandTotal'].toString());
    TotalTax = map['TotalTax'] == null ? 0.0 : double.parse(map['TotalTax'].toString());
    TotalRounding = map['TotalRounding'] == null ? 0.0 : double.parse(map['TotalRounding'].toString());
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'Discount': Discount == null ? 0.0 : Discount,
      'Surcharge': Surcharge == null ? 0.0 : Surcharge,
      'SubTotal': SubTotal == null ? 0.0 : SubTotal,
      'Minimum_charge': Minimum_charge == null ? 0.0 : Minimum_charge,
      'Delivery_Charge': Delivery_Charge == null ? 0.0 : Delivery_Charge,
      'ChargePerHour': ChargePerHour == null ? 0.0 : ChargePerHour,
      'GrandTotal': GrandTotal == null ? 0.0 : GrandTotal,
      'TotalTax': TotalTax == null ? 0.0 : TotalTax,
      'TotalRounding': TotalRounding == null ? 0.0 : TotalRounding,
    };
    return map;
  }
}
