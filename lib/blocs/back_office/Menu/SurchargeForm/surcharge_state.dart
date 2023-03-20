import 'package:invo_mobile/models/surcharge.dart';

abstract class SurchargeLoadState {}

class SurchargeIsLoading extends SurchargeLoadState {}

class SurchargeIsLoaded extends SurchargeLoadState {
  final Surcharge surcharge;
  SurchargeIsLoaded(this.surcharge);
}
