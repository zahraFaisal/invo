
import 'package:invo_mobile/models/price_label.dart';

abstract class PricesListEvent {}

class LoadPrice extends PricesListEvent {}

class DeletePrice extends PricesListEvent {
 
  PriceLabel price;
  DeletePrice(this.price);
}
