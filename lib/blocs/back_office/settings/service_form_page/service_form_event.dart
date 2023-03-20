import 'package:invo_mobile/models/Service.dart';

abstract class ServicesFormEvent {}

class SaveServices extends ServicesFormEvent {
  final Service dineIn;
  final Service delivery;
  final Service takeAway;
  final Service carHop;

  SaveServices(this.dineIn, this.delivery, this.carHop, this.takeAway);
}
