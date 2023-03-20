import 'package:invo_mobile/models/discount.dart';

abstract class DiscountLoadState {}

class DiscountIsLoading extends DiscountLoadState {}

class DiscountIsLoaded extends DiscountLoadState {
  final Discount discount;
 DiscountIsLoaded(this.discount);
}