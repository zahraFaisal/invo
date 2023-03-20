import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/surcharge.dart';

abstract class OrderPendingViewState {}

class OrderIsLoading extends OrderPendingViewState {}

class OrderIsLoaded extends OrderPendingViewState {
  final OrderHeader? order;
  OrderIsLoaded({this.order});
}

class OrderIsHidden extends OrderPendingViewState {
  OrderIsHidden();
}

abstract class PopupPanelState {}

class PopUpPanel extends PopupPanelState {}

class RecallDiscountPanel extends PopupPanelState {
  final List<Discount> discounts;
  RecallDiscountPanel(this.discounts);
}

class RecallPayPanel extends PopupPanelState {
  RecallPayPanel();
}

class RecallSurchargePanel extends PopupPanelState {
  final List<Surcharge> surcharges;
  RecallSurchargePanel(this.surcharges);
}
