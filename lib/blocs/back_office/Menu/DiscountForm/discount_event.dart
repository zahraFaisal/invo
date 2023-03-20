import 'package:invo_mobile/models/discount.dart';

abstract class DiscountFormEvent {}

class SaveDiscount extends DiscountFormEvent{
  Discount discount;
  SaveDiscount(this.discount);
} 
