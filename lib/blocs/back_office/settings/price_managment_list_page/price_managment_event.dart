
import 'package:invo_mobile/models/price_managment.dart';

abstract class PriceManagmentListEvent {}

class LoadPriceManagment extends PriceManagmentListEvent {}

class DeletePriceManagment extends PriceManagmentListEvent {
 
 PriceManagement priceManagment;
   DeletePriceManagment(this.priceManagment);
}

