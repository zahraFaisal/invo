
import 'package:invo_mobile/models/price_managment.dart';


abstract class PriceManagmentFormEvent {}

class SavePriceManagment extends PriceManagmentFormEvent {
 PriceManagement price;
  SavePriceManagment(this.price);
} 