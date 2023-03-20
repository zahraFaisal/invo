abstract class CashierReportPageEvent {}

class CashierReportPageGoBack extends CashierReportPageEvent {}


class CashierReportLoadReport extends CashierReportPageEvent {
  final DateTime date;
  CashierReportLoadReport(this.date);
}

class PrintCashierReport extends CashierReportPageEvent {}



class CashierReportDetailsLoadReport extends CashierReportPageEvent {
  final id;
  CashierReportDetailsLoadReport(this.id);
}