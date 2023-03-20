import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/reports/report_page_state.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesByMenuItem extends StatefulWidget {
  final Property<double> scale;
  final SalesByItemReport report;
  SalesByMenuItem({Key? key, required this.scale, required this.report}) : super(key: key);

  @override
  _SalesByMenuItemState createState() => _SalesByMenuItemState();
}

class _SalesByMenuItemState extends State<SalesByMenuItem> {
  late Uint8List temp;
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
              return temp;
          },
        );
      },
    );
  }

  Future<Uint8List> generateDocument() async {
    const tableHeaders = [
      'Item Code',
      'Item Name',
      'Category',
      'Qty',
      'Total',
    ];
    List<List<dynamic>> dataTable = [];
    List<dynamic> temp;

    for (var item in widget.report.data) {
      temp = List<dynamic>.empty(growable: true);
      temp.add(item.barcode == null ? "" : item.barcode);
      temp.add(item.name == null ? "" : item.name);
      temp.add(item.category == null ? "" : item.category);
      temp.add(item.totalQty == null ? 0.0 : item.totalQty);
      temp.add(item.totalSale == null ? 0.0 : item.totalSale);
      dataTable.add(temp);
    }

    // Create a PDF document.
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

            return <pw.Widget>[
              pw.Column(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 20),
                    child: pw.Container(child: pw.Text("Sales By Item", style: pw.TextStyle(fontSize: 20))),
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
                ],
              )
            ];
          }),
    );

    temp = await document.save();
    return temp as Uint8List;
  }
}
