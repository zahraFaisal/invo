import 'package:invo_mobile/models/Service.dart';

abstract class ServiceLoadState {}

class ServicesIsLoading extends ServiceLoadState {}

class ServicesIsLoaded extends ServiceLoadState {
  Service? dineIn;
  Service? delivery;
  Service? takeAway;
  Service? carHop;
  Service? pending;

  ServicesIsLoaded({this.dineIn, this.delivery, this.carHop, this.takeAway, this.pending});
}

class ServicesIsSaving extends ServiceLoadState {}

class ServicesSaved extends ServiceLoadState {
  Service? dineIn;
  Service? delivery;
  Service? takeAway;
  Service? carHop;
  Service? pending;

  ServicesSaved({this.dineIn, this.delivery, this.carHop, this.takeAway, this.pending});
}
