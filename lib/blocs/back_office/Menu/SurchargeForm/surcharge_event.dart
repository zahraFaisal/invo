import 'package:invo_mobile/models/surcharge.dart';

abstract class SurchargeFormEvent {}

class SaveSurcharge extends SurchargeFormEvent{
  Surcharge surcharge;
  SaveSurcharge(this.surcharge);
} 
