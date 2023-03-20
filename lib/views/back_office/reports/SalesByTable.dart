import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_state.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesbyTable extends StatefulWidget {
  final Property<double> scale;
  final SalesByTableReport report;
  SalesbyTable({Key? key, required this.scale, required this.report}) : super(key: key);

  @override
  _SalesbyTableState createState() => _SalesbyTableState();
}

class _SalesbyTableState extends State<SalesbyTable> {
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
            return generateDocument();
          },
        );
      },
    );
  }

  Future<Uint8List> generateDocument() async {
    const tableHeaders = ['Name', 'Total Order', 'Total Sale', 'Average', 'Guest', 'Average Guest'];
    List<List<dynamic>> dataTable = [];
    List<dynamic> temp;
    int countOrder = 0;
    double countTotal = 0;
    double avgGuest = 0;
    int guest = 0;
    double avg = 0;
    for (var item in widget.report.data) {
      temp = List<dynamic>.empty(growable: true);
      temp.add(item.tableName);
      temp.add(item.totalOrder);
      temp.add(item.orderTotalPrice);
      temp.add(item.average);
      temp.add(item.guest);
      temp.add(item.avgarageGuest);
      dataTable.add(temp);
      countOrder += item.totalOrder;
      countTotal += item.orderSum;
      avgGuest += item.avgarageGuest;
      guest += item.guest;
      if (item.average != null) {
        avg += item.average;
      }
    }
    temp = List<dynamic>.empty(growable: true);
    temp.add("Total");
    temp.add(countOrder);
    temp.add(Number.formatCurrency(countTotal));
    temp.add(avg);
    temp.add(guest);
    temp.add(avgGuest);
    dataTable.add(temp);
    var max = countTotal;

    try {
      final document = pw.Document();
      document.addPage(
        pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(5),
            build: (context) {
              // final chart2 = pw.Chart(
              //   title: pw.ChartLegend(position: pw.Alignment.center),
              //   grid: pw.CartesianGrid(
              //     xAxis: pw.FixedAxis.fromStrings(
              //       List<String>.generate(widget.report.data.length, (index) {
              //         if (index < widget.report.data.length) {
              //           return widget.report.data[index].tableName;
              //         } else {
              //           return '';
              //         }
              //       }),
              //       marginStart: 50,
              //       marginEnd: 50,
              //     ),
              //     yAxis: pw.FixedAxis(
              //       [0, max + 50],
              //       divisions: true,
              //     ),
              //   ),
              //   datasets: [
              //     pw.BarDataSet(
              //       legend: "Order_Sum",
              //       width: 50,
              //       drawSurface: true,
              //       color: PdfColors.blue700,
              //       data: List<pw.LineChartValue>.generate(
              //         widget.report.data.length,
              //         (i) {
              //           if (i < widget.report.data.length) {
              //             final num v = widget.report.data[i].orderSum;
              //             return pw.LineChartValue(i.toDouble(), v.toDouble());
              //           } else {
              //             return pw.LineChartValue(0, 0);
              //           }
              //         },
              //       ),
              //     ),
              //   ],
              // );
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
                      child: pw.Container(child: pw.Text("Sales By Table", style: pw.TextStyle(fontSize: 20))),
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
                          pw.Expanded(child: pw.Text(Misc.toShortDate(widget.report.from), style: pw.TextStyle(fontSize: 15))),
                        ]))
                      ]),
                    ),
                    pw.Container(
                      child: table,
                    ),
                    // pw.Container(
                    //     child: pw.Padding(
                    //         padding: pw.EdgeInsets.all(20), child: chart2))
                  ],
                )
              ];
            }),
      );
      return await document.save();
    } catch (e) {
      final document = pw.Document();
      return await document.save();

      print(e.toString());
    }
    // Create a PDF document.
  }
}
