import 'package:invo_mobile/models/price_label.dart';


abstract class PricesLoadState {}

class PriceIsLoading extends PricesLoadState {}

class PriceIsLoaded extends PricesLoadState {
  final PriceLabel price;
  PriceIsLoaded(this.price);
}
