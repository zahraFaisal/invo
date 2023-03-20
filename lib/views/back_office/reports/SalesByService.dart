import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_state.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SalesBServiceReport extends StatefulWidget {
  final Property<double> scale;
  final SalesByServiceReport report;
  SalesBServiceReport({Key? key, required this.scale, required this.report}) : super(key: key);

  @override
  _SalesBServiceReportState createState() => _SalesBServiceReportState();
}

class _SalesBServiceReportState extends State<SalesBServiceReport> {
  Uint8List? temp;
  @override
  Widget build(BuildContext context) {
    var scale = widget.scale;
    return StreamBuilder(
      stream: scale.stream,
      initialData: scale.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return PdfPreview(
          canChangePageFormat: false,
          initialPageFormat: PdfPageFormat.a4,
          maxPageWidth: (scale.value == null ? 4.0 : scale.value)! * 400,
          build: (format) {
            if (temp == null)
              return generateDocument();
            else
              return temp!;
          },
        );
      },
    );
  }

  Future<Uint8List> generateDocument() async {
    const tableHeaders = ['Service', 'Total Order', 'Total Sales'];
    List<List<dynamic>> dataTable = [];
    List<dynamic> temp;

    int countOrder = 0;
    double countTotal = 0;
    for (var item in widget.report.data) {
      temp = List<dynamic>.empty(growable: true);
      temp.add(item.serviceName);
      temp.add(item.totalOrder);
      temp.add(item.orderTotalPrice);
      dataTable.add(temp);

      countOrder += item.totalOrder;
      countTotal += item.orderSum;
    }

    temp = List<dynamic>.empty(growable: true);
    temp.add("Total");
    temp.add(countOrder);
    temp.add(Number.formatCurrency(countTotal));
    dataTable.add(temp);

    var max = countTotal;

    // Create a PDF document.
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(5),
          build: (context) {
            final chart2 = pw.Chart(
              title: pw.ChartLegend(position: pw.Alignment.center),
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                  List<String>.generate(widget.report.data.length + 1, (index) {
                    if (index < widget.report.data.length) {
                      return widget.report.data[index].serviceName!;
                    } else {
                      return '';
                    }
                  }),
                  marginStart: 50,
                  marginEnd: 50,
                ),
                yAxis: pw.FixedAxis(
                  [0, max + 50],
                  divisions: true,
                ),
              ),
              datasets: [
                pw.BarDataSet(
                  legend: "Order Sum",
                  width: 50,
                  drawSurface: true,
                  color: PdfColors.blue700,
                  data: List<pw.LineChartValue>.generate(
                    widget.report.data.length + 1,
                    (i) {
                      if (i < widget.report.data.length) {
                        final num v = widget.report.data[i].orderSum;
                        return pw.LineChartValue(i.toDouble(), v.toDouble());
                      } else {
                        return pw.LineChartValue(0, 0);
                      }
                    },
                  ),
                ),
              ],
            );
            final table = pw.Table.fromTextArray(
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(fontSize: 14),
              headerAlignment: pw.Alignment.center,
              border: pw.TableBorder(),
              headers: tableHeaders,
              data: dataTable,
              headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 16),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.blueGrey900,
              ),
              rowDecoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    width: 5,
                    color: PdfColors.blueGrey900,
                  ),
                  left: pw.BorderSide(
                    width: 5,
                    color: PdfColors.blueGrey900,
                  ),
                  right: pw.BorderSide(
                    width: 5,
                    color: PdfColors.blueGrey900,
                  ),
                ),
              ),
            );

            return <pw.Widget>[
              pw.Column(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 20),
                    child: pw.Container(child: pw.Text("Sales By Service", style: pw.TextStyle(fontSize: 20))),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 10),
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                      pw.Expanded(
                          flex: 4,
                          child: pw.Row(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(right: 20),
                              child: pw.Container(child: pw.Text("From:", style: pw.TextStyle(fontSize: 15))),
                            ),
                            pw.Expanded(child: pw.Text(Misc.toShortDate(widget.report.from), style: pw.TextStyle(fontSize: 15))),
                          ])),
                      pw.Expanded(
                          child: pw.Row(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(right: 20),
                          child: pw.Container(child: pw.Text("To:", style: pw.TextStyle(fontSize: 15))),
                        ),
                        pw.Expanded(child: pw.Text(Misc.toShortDate(widget.report.to), style: pw.TextStyle(fontSize: 15))),
                      ]))
                    ]),
                  ),
                  pw.Container(
                    child: table,
                  ),
                  pw.Container(child: pw.Padding(padding: pw.EdgeInsets.all(20), child: chart2))
                ],
              )
            ];
          }),
    );

    temp = await document.save();
    return temp as Uint8List;
  }
}