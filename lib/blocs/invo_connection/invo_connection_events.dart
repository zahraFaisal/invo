abstract class InvoConnectionEvent {}

class ConnectionGoBack extends InvoConnectionEvent {}

class ConnectButtonPressed extends InvoConnectionEvent {
  String? part1;
  String? part2;
  String? part3;
  String? part4;

  ConnectButtonPressed({this.part1, this.part2, this.part3, this.part4});
}

class ConnectLoading extends InvoConnectionEvent {}

class ConnectComplete extends InvoConnectionEvent {}
