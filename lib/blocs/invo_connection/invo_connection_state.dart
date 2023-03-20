abstract class InvoConnectionState {}

class IsLoading extends InvoConnectionState {
  int? progress;
  IsLoading({this.progress});
}

class InitState extends InvoConnectionState {}

class ConnectionError extends InvoConnectionState {
  final String error;
  ConnectionError(this.error);
}
