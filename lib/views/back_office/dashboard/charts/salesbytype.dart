import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/SalesByServiceModel.dart';

class SalesByTypeChart extends StatelessWidget {
  final List<charts.Series<SalesByServiceModel, String>> seriesList;
  final bool animate;

  SalesByTypeChart(this.seriesList, {this.animate = false});

  /// Creates a [PieChart] with sample data and no transition.
  factory SalesByTypeChart.withSampleData(List<SalesByServiceModel> sales) {
    return SalesByTypeChart(
      _createSampleData(sales),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart<String>(seriesList,
        animate: animate,
        // Configure the width of the pie slices to 60px. The remaining space in
        // the chart will be left as a hole in the center.
        behaviors: [
          charts.DatumLegend(
            position: charts.BehaviorPosition.end,
            horizontalFirst: false,
            legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          )
        ],
        defaultRenderer: charts.ArcRendererConfig(arcWidth: 60, arcRendererDecorators: [charts.ArcLabelDecorator()]));
  }

  /// Create one series with sample hard coded data.
  /// List<charts.Series>
  static List<charts.Series<SalesByServiceModel, String>> _createSampleData(List<SalesByServiceModel> sales) {
    final data = sales;

    return [
      charts.Series<SalesByServiceModel, String>(
        id: 'Sales',
        domainFn: (SalesByServiceModel sales, _) => sales.serviceName!,
        measureFn: (SalesByServiceModel sales, _) => sales.orderSum,
        data: data,
        labelAccessorFn: (SalesByServiceModel sales, _) => '${Number.getNumber(sales.orderSum).toString()}',
        colorFn: (SalesByServiceModel sales, _) {
          switch (sales.serviceName) {
            case "Pick up":
              return charts.ColorUtil.fromDartColor(Colors.orange[300]!);
            case "Dine In":
              return charts.ColorUtil.fromDartColor(Colors.pink[200]!);
            case "Car Hop":
              return charts.ColorUtil.fromDartColor(Colors.green[200]!);
            case "Delivery":
              return charts.ColorUtil.fromDartColor(Colors.blue[300]!);
            default:
              return charts.ColorUtil.fromDartColor(Colors.orange[300]!);
          }
        } /* (SalesByServiceModel sales, _)=>charts.ColorUtil.fromDartColor(sales.colorval) */,
      )
    ];
  }
}
