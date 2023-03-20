class OrderTotalDetailsModel {
  double discount;
  double surcharge;
  double subTotal;
  double minimumCharge;
  double deliveryCharge;
  double chargePerHour;
  double grandTotal;
  double totalTax;
  double totalRounding;
  OrderTotalDetailsModel(
      {this.discount = 0,
      this.chargePerHour = 0,
      this.subTotal = 1,
      this.deliveryCharge = 0,
      this.grandTotal = 0,
      this.minimumCharge = 0,
      this.surcharge = 0,
      this.totalRounding = 0,
      this.totalTax = 0});
  factory OrderTotalDetailsModel.fromMap(Map<String, dynamic> map) {
    OrderTotalDetailsModel orderTotalDetailsModel = OrderTotalDetailsModel();
    orderTotalDetailsModel.discount = map['discount'] ?? 0.0;
    orderTotalDetailsModel.surcharge = map['surcharge'] ?? 0.0;
    orderTotalDetailsModel.subTotal = map['subTotal'] ?? 0.0;
    orderTotalDetailsModel.minimumCharge = map['minimumCharge'] ?? 0.0;
    orderTotalDetailsModel.deliveryCharge = map['deliveryCharge'] ?? 0.0;
    orderTotalDetailsModel.chargePerHour = map['chargePerHour'] ?? 0.0;
    orderTotalDetailsModel.grandTotal = map['grandTotal'] ?? 0.0;
    orderTotalDetailsModel.totalTax = map['totalTax'] ?? 0.0;
    orderTotalDetailsModel.totalRounding = map['totalRounding'] ?? 0.0;
    return orderTotalDetailsModel;
  }
  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'Discount': discount,
      'Surcharge': surcharge,
      'SubTotal': subTotal,
      'Minimum_charge': minimumCharge,
      'Delivery_Charge': deliveryCharge,
      'ChargePerHour': chargePerHour,
      'GrandTotal': grandTotal,
      'TotalTax': totalTax,
      'TotalRounding': totalRounding,
    };
    return map;
  }
}
