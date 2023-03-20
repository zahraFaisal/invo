import 'package:flutter/cupertino.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/custom/search.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/surcharge.dart';

abstract class RecallPageEvent {}

class ClickOnOrderSummary extends RecallPageEvent {
  final MiniOrder? order;
  final Orientation? orientation;
  ClickOnOrderSummary({this.order, this.orientation});
}

class ClickOnNewOrderInDelivery extends RecallPageEvent {}

class ClickNewOrder extends RecallPageEvent {
  final Orientation orientation;
  ClickNewOrder({this.orientation = Orientation.landscape});
}

class LoadCustomer extends RecallPageEvent {
  final String phone;
  LoadCustomer(this.phone);
}

class SearchOrder extends RecallPageEvent {
  final SearchModel model;
  SearchOrder(this.model);
}

class ChangeService extends RecallPageEvent {
  final Service? service;
  ChangeService({this.service});
}

class LoadPaidOrders extends RecallPageEvent {
  DateTime date;
  LoadPaidOrders(this.date);
}

class GoBack extends RecallPageEvent {}

class TakeOrderFirst extends RecallPageEvent {}

class EditOrder extends RecallPageEvent {}

class PrintOrder extends RecallPageEvent {}

class PayOrder extends RecallPageEvent {
  final Orientation orientation;
  PayOrder({this.orientation = Orientation.landscape});
}

class VoidOrder extends RecallPageEvent {
  final Orientation orientation;
  VoidOrder({this.orientation = Orientation.landscape});
}

class FollowUpOrder extends RecallPageEvent {}

class SurchargeOrder extends RecallPageEvent {}

class DiscountOrder extends RecallPageEvent {}

class DiscountClicked extends RecallPageEvent {
  final Discount discount;
  DiscountClicked(this.discount);
}

class SurchargeClicked extends RecallPageEvent {
  final Surcharge surcharge;
  SurchargeClicked(this.surcharge);
}
