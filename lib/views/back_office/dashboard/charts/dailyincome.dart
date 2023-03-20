// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:invo_mobile/models/Number.dart';
import 'package:invo_mobile/models/reports/DailySalesModel.dart';

class DailyIncomeChart extends StatelessWidget {
  final List<charts.Series>? seriesList;
  final bool? animate;

  DailyIncomeChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory DailyIncomeChart.withSampleData(List<DailySalesModel> sales) {
    return DailyIncomeChart(
      _createSampleData(sales),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return charts.TimeSeriesChart(
      seriesList as List<charts.Series<dynamic, DateTime>>,
      animate: animate,
      behaviors: [charts.LinePointHighlighter(symbolRenderer: charts.CircleSymbolRenderer(isSolid: false))],
      domainAxis: charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(day: charts.TimeFormatterSpec(format: 'd', transitionFormat: 'dd/MM/yyyy'))),
      defaultRenderer: charts.LineRendererConfig(
        includePoints: true,
      ),
      selectionModels: [
        charts.SelectionModelConfig(changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
        })
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<DailySalesModel, DateTime>> _createSampleData(List<DailySalesModel> sales) {
    final data = sales;

    return [
      // ignore: unnecessary_new
      charts.Series<DailySalesModel, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DailySalesModel sales, _) => DateTime(int.parse(sales.year), int.parse(sales.month), int.parse(sales.day)),
        measureFn: (DailySalesModel sales, _) => sales.orderSum,
        data: data,
        labelAccessorFn: (DailySalesModel sales, _) => '${Number.getNumber(sales.orderSum).toString()}',
      )
    ];
  }
}
