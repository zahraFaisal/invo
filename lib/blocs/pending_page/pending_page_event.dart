import 'package:flutter/cupertino.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/mini_order.dart';
import 'package:invo_mobile/models/custom/search.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/surcharge.dart';

abstract class PendingPageEvent {}

class GoBack extends PendingPageEvent {}

class LoadPendingOrders extends PendingPageEvent {
  LoadPendingOrders();
}

class AcceptPendingOrder extends PendingPageEvent {}

class RejectPendingOrder extends PendingPageEvent {}

class PrintPendingOrder extends PendingPageEvent {}

class ClickOnOrderSummary extends PendingPageEvent {
  final MiniOrder? order;
  final Orientation? orientation;
  ClickOnOrderSummary({this.order, this.orientation});
}
