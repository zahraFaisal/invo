import 'package:invo_mobile/models/price_label.dart';
abstract class PricesFormEvent {}

class SavePrice extends PricesFormEvent{
 PriceLabel price;
  SavePrice(this.price);
} 