abstract class ReportPageEvent {}

class SalesSummary extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesSummary(this.from, this.to);
}

class SalesByService extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesByService(this.from, this.to);
}

class SalesByTable extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesByTable(this.from, this.to);
}

class SalesBySectionTable extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesBySectionTable(this.from, this.to);
}

class SalesByItem extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesByItem(this.from, this.to);
}

class SalesByCategory extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesByCategory(this.from, this.to);
}

class TaxReport extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  TaxReport(this.from, this.to);
}

class SalesByEmployee extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesByEmployee(this.from, this.to);
}

class DriverSummary extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  DriverSummary(this.from, this.to);
}

class VoidReport extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  VoidReport(this.from, this.to);
}

class DailySales extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  DailySales(this.from, this.to);
}

class SalesByHours extends ReportPageEvent {
  final DateTime from;
  final DateTime to;
  SalesByHours(this.from, this.to);
}
