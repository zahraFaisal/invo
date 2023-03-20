import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_state.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesbyEmployee extends StatefulWidget {
  final SalesByEmployeeReport report;
  final Property<double> scale;
  SalesbyEmployee({Key? key, required this.scale, required this.report}) : super(key: key);

  @override
  _SalesbyEmployeeState createState() => _SalesbyEmployeeState();
}

class _SalesbyEmployeeState extends State<SalesbyEmployee> {
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
    const tableHeaders = [
      'Employee',
      'Orders Qty',
      'Order Total',
      'Items Qty',
      ' Item Total ',
    ];
    List<List<dynamic>> dataTable = [];
    List<dynamic> temp;
    int countOrder = 0;
    double countTotal = 0;
    double totalItems = 0;
    double grandTotal = 0;
    for (var item in widget.report.data) {
      temp = List<dynamic>.empty(growable: true);
      temp.add(item.employee);
      temp.add(item.totalOrder);
      temp.add(item.grandTotalPrice);
      temp.add(item.itemsQty);
      temp.add(item.orderTotalPrice);

      dataTable.add(temp);
      countOrder += item.totalOrder;
      grandTotal += item.grandTotal;
      totalItems += item.itemsQty;
      countTotal += item.sumOrder;
    }

    temp = List<dynamic>.empty(growable: true);
    temp.add("Total");
    temp.add(countOrder);
    temp.add(Number.formatCurrency(grandTotal));
    temp.add(totalItems);
    temp.add(Number.formatCurrency(countTotal));
    dataTable.add(temp);

    //  var max = countTotal;

    List<List<dynamic>> data2Table = [];

    for (var item in widget.report.details) {
      data2Table = [
        ["Total charge per hour:", Number.formatCurrency(item.chargePerHour)],
        ["Total min charge:", Number.formatCurrency(item.minimumCharge)],
        ["Total Discount:", Number.formatCurrency(item.discount)],
        ["Total Surcharge:", Number.formatCurrency(item.surcharge)],
        ["Total Delivery Charge:", Number.formatCurrency(item.deliveryCharge)],
        ["SubTotal:", Number.formatCurrency(item.subTotal)],
        ["Total Tax:", Number.formatCurrency(item.totalTax)],
        ["Rounding:", Number.formatCurrency(item.totalRounding)],
        ["GrandTotal:", Number.formatCurrency(item.grandTotal)],
      ];
    }

    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(5),
          build: (context) {
            final table = pw.Table.fromTextArray(
              columnWidths: {
                0: pw.FixedColumnWidth(3),
                1: pw.FixedColumnWidth(3),
                2: pw.FixedColumnWidth(3),
                3: pw.FixedColumnWidth(3),
                4: pw.FixedColumnWidth(3)
              },
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

            final table2 = pw.Table.fromTextArray(
              cellAlignment: pw.Alignment.topLeft,
              cellStyle: pw.TextStyle(fontSize: 16),
              border: null,
              cellPadding: pw.EdgeInsets.all(10),
              headerAlignment: pw.Alignment.topLeft,
              headerStyle: pw.TextStyle(fontSize: 16),
              headerPadding: pw.EdgeInsets.all(10),
              data: data2Table,
            );

            return <pw.Widget>[
              pw.Column(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 20),
                    child: pw.Container(child: pw.Text("Sales By Employee", style: pw.TextStyle(fontSize: 20))),
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
                  pw.Container(margin: pw.EdgeInsets.only(left: 300), child: pw.Padding(padding: pw.EdgeInsets.only(top: 10), child: table2)),
                ],
              )
            ];
          }),
    );

    temp = await document.save();
    return temp as Uint8List;
  }
}
