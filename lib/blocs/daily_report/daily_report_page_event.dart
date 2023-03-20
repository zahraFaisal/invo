abstract class DailyReportPageEvent {}

class DailyReportPageGoBack extends DailyReportPageEvent {}

class PrintDailyClosingReport extends DailyReportPageEvent {
  final DateTime date_time;
  PrintDailyClosingReport(this.date_time);
}

class DailyReportLoadReport extends DailyReportPageEvent {
  final DateTime date;
  DailyReportLoadReport(this.date);
}

