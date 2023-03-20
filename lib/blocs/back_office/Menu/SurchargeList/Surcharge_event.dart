import 'package:invo_mobile/models/surcharge.dart';

abstract class SurchargeListEvent {}

class LoadSurcharge extends SurchargeListEvent {}

class DeleteSurcharge extends SurchargeListEvent {
 
  Surcharge surcharge;
  DeleteSurcharge(this.surcharge);
}

