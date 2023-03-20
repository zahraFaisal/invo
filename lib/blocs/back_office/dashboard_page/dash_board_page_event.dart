abstract class DashBoardPageEvent {}

class DashBoardLoadReport extends DashBoardPageEvent {
  final DateTime date;
  DashBoardLoadReport(this.date);
}