import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/order/TransactionModifier.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/order/order_transaction.dart';
import 'package:invo_mobile/models/surcharge.dart';

abstract class OrderPageEvent {}

class MenuTypeClicked extends OrderPageEvent {
  final MenuType menu;
  MenuTypeClicked(this.menu);
}

class PayOrder extends OrderPageEvent {}

class MenuGroupClicked extends OrderPageEvent {
  final MenuGroup group;
  MenuGroupClicked(this.group);
}

class MenuItemClicked extends OrderPageEvent {
  final MenuItem item;
  MenuItemClicked(this.item);
}

class ServiceChanged extends OrderPageEvent {
  final Service service;
  ServiceChanged(this.service);
}

class AddNewTicket extends OrderPageEvent {}

class ChangeTicket extends OrderPageEvent {
  final OrderHeader order;
  ChangeTicket(this.order);
}

class SelectTransaction extends OrderPageEvent {
  final OrderTransaction transaction;
  SelectTransaction(this.transaction);
}

class RemoveTransaction extends OrderPageEvent {
  final OrderTransaction transaction;
  RemoveTransaction(this.transaction);
}

class RemoveTransactionDiscount extends OrderPageEvent {
  RemoveTransactionDiscount();
}

class AddTransactionModifier extends OrderPageEvent {
  final MenuModifier modifier;
  final bool isForced;
  final bool selectedTranscation;
  AddTransactionModifier(this.modifier,
      {this.isForced = false, this.selectedTranscation = false});
}

class AddSubItemModifier extends OrderPageEvent {
  final MenuModifier modifier;
  final bool isForced;
  AddSubItemModifier(this.modifier, {this.isForced = false});
}

class AddComboItemModifier extends OrderPageEvent {
  final MenuModifier modifier;
  final bool isForced;
  AddComboItemModifier(this.modifier, {this.isForced = false});
}

class RemoveTransactionModifier extends OrderPageEvent {
  final TransactionModifier modifier;
  final bool selectedTranscation;
  RemoveTransactionModifier(this.modifier, {this.selectedTranscation = false});
}

class AddTransactionSubItem extends OrderPageEvent {
  final MenuItem item;
  AddTransactionSubItem(this.item);
}

class CancelPopUpModifier extends OrderPageEvent {
  final bool deleteItem;
  CancelPopUpModifier(this.deleteItem);
}

class FinishSubItemPopUpModifier extends OrderPageEvent {
  final bool deleteItem;
  FinishSubItemPopUpModifier(this.deleteItem);
}

class FinishComboItemPopUpModifier extends OrderPageEvent {
  final bool deleteItem;
  FinishComboItemPopUpModifier(this.deleteItem);
}

class SearchItem extends OrderPageEvent {}

class ShowShortNote extends OrderPageEvent {}

class IncreaseTransactionQty extends OrderPageEvent {}

class DecreaseTransactionQty extends OrderPageEvent {}

class AdjTransactionPrice extends OrderPageEvent {}

class AdjTransactionQty extends OrderPageEvent {}

class AdjGuestNumber extends OrderPageEvent {}

class ReOrderTransaction extends OrderPageEvent {}

class HoldUntilFire extends OrderPageEvent {}

class DiscountOrder extends OrderPageEvent {}

class SurchargeOrder extends OrderPageEvent {}

class AddCustomer extends OrderPageEvent {}

class EditCustomer extends OrderPageEvent {
  final String phone;
  EditCustomer(this.phone);
}

class SelectCustomer extends OrderPageEvent {
  final CustomerList customerList;
  SelectCustomer(this.customerList);
}

class OrderDiscountItem extends OrderPageEvent {}

class AddTag extends OrderPageEvent {}

class OrderDiscountClicked extends OrderPageEvent {
  final Discount discount;
  OrderDiscountClicked(this.discount);
}

class OrderItemDiscountClicked extends OrderPageEvent {
  final Discount discount;
  OrderItemDiscountClicked(this.discount);
}

class SurchargeClicked extends OrderPageEvent {
  final Surcharge surcharge;
  SurchargeClicked(this.surcharge);
}

class VoidOrder extends OrderPageEvent {}

class SaveOrder extends OrderPageEvent {}

class SaveAndPrintOrder extends OrderPageEvent {}

class GoBack extends OrderPageEvent {}
