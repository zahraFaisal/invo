import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/SalesByEmployeeModel.dart';

class SalesByEmployeeChart extends StatelessWidget {
  final List<charts.Series>? seriesList;
  final bool? animate;

  SalesByEmployeeChart(this.seriesList, {this.animate});

  factory SalesByEmployeeChart.withSampleData(List<SalesByEmployeeModel> sales) {
    return SalesByEmployeeChart(
      _createSampleData(sales),
      animate: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList as List<charts.Series<dynamic, String>>,
      animate: animate,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<SalesByEmployeeModel, String>> _createSampleData(List<SalesByEmployeeModel> sales) {
    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(2);
    final green = charts.MaterialPalette.green.makeShades(2);

    var data = sales;

    return [
      charts.Series<SalesByEmployeeModel, String>(
          id: 'Sales',
          domainFn: (SalesByEmployeeModel sales, _) => sales.employee,
          measureFn: (SalesByEmployeeModel sales, _) => sales.grandTotal,
          data: data,
          labelAccessorFn: (SalesByEmployeeModel sales, _) => '${Number.getNumber(sales.grandTotal)}',
          insideLabelStyleAccessorFn: (SalesByEmployeeModel sales, _) {
            return charts.TextStyleSpec(color: charts.MaterialPalette.white, fontSize: 25);
          },
          colorFn: (SalesByEmployeeModel sales, _) {
            switch (sales.employee) {
              default:
                return blue[1];
            }
          }),
    ];
  }
}
