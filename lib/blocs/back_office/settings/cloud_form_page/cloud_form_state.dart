abstract class CloudLoadState {}

class CloudIsLoading extends CloudLoadState {}

class CloudIsLoaded extends CloudLoadState {

 // ServicesIsLoaded({this.dineIn, this.delivery, this.carHop, this.takeAway});
}

class CloudIsSaving extends CloudLoadState {}

class CloudSaved extends CloudLoadState {


//  ServicesSaved({this.dineIn, this.delivery, this.carHop, this.takeAway});
}