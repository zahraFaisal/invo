import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/surcharge.dart';

abstract class PopupPanelState {}

class OrderPanel extends PopupPanelState {}

class SearchItemPanel extends PopupPanelState {}

class PopUpModifier extends PopupPanelState {
  final MenuItem item;
  final bool isSubItem;
  final bool isComboItem;
  PopUpModifier(this.item, this.isSubItem, this.isComboItem);
}

class PopUpMenuSelection extends PopupPanelState {
  final MenuItem item;
  final int level;
  final int levelSelectedItem;
  PopUpMenuSelection(this.item, this.level, this.levelSelectedItem);
}

class DiscountPanel extends PopupPanelState {
  final List<Discount> discounts;
  final bool orderDiscount;
  DiscountPanel(this.discounts, this.orderDiscount);
}

class SurchargePanel extends PopupPanelState {
  final List<Surcharge> surcharges;
  SurchargePanel(this.surcharges);
}

class SettlePanel extends PopupPanelState {}

class LoadCustomerPanel extends PopupPanelState {}

class ModifierListPanel extends PopupPanelState {}

class TableSelection extends PopupPanelState {}

abstract class OrderPageOptionState {}

class QuickModifierOption extends OrderPageOptionState {
  final List<MenuModifier>? modifiers;
  final OrderTransaction? transaction;
  QuickModifierOption({this.modifiers, this.transaction});
}

class ItemOption extends OrderPageOptionState {}

class OrderPageOption extends OrderPageOptionState {}
