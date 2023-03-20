
import 'package:invo_mobile/models/price_managment.dart';

abstract class PriceManagmentLoadState {}

class PriceManagmentIsLoading extends PriceManagmentLoadState {}

class PriceManagmentIsLoaded extends PriceManagmentLoadState {
  final PriceManagement price;
 PriceManagmentIsLoaded(this.price);
}
