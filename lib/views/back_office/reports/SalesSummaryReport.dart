import 'dart:typed_data';
import 'package:invo_mobile/blocs/back_office/reports/report_page_state.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/Number.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class SalesSummaryReportWidget extends StatefulWidget {
  final Property<double> scale;
  final SalesSummaryReport report;
  SalesSummaryReportWidget({Key? key, required this.scale, required this.report}) : super(key: key);

  @override
  _SalesSummaryReportWidgetState createState() => _SalesSummaryReportWidgetState();
}

class _SalesSummaryReportWidgetState extends State<SalesSummaryReportWidget> {
  late Uint8List temp;
  @override
  Widget build(BuildContext context) {
    var scale = widget.scale;
    return StreamBuilder(
      stream: scale.stream,
      initialData: scale.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RotatedBox(
          quarterTurns: 3,
          child: PdfPreview(
            canChangePageFormat: false,
            allowPrinting: false,
            allowSharing: false,
            initialPageFormat: PdfPageFormat.a4,
            maxPageWidth: (scale.value == null ? 4.0 : scale.value)! * 400,
            build: (format) {
              return generateDocument();
            },
          ),
        );
      },
    );
  }

  Future<Uint8List> generateDocument() async {
    SalesSummaryReport report = widget.report;

    double totalCount = 0;
    List<pw.Widget> items = List<pw.Widget>.empty(growable: true);

    double colWidth = 240;

    items.add(pw.SizedBox(height: 30));
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              "Sales",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
    items.add(pw.Container(
        width: colWidth,
        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Name"),
            pw.Text("Percentage"),
            pw.Text("Total"),
          ],
        )));

    for (var item in report.data) {
      totalCount += item.orderSum;
      items.add(pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(item.category + "[" + item.itemQty.toString() + "]"),
            pw.Text(Number.getNumber(item.percentage)),
            pw.Text(item.totalprice),
          ],
        ),
      ));
    }

    items.add(pw.Container(
        width: colWidth,
        decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Total"),
            pw.Text(report.summary.totalSale),
          ],
        )));
    items.add(pw.SizedBox(height: 30));
    String minimumCharge = "";
    String totalDiscount = "";
    String totalDeliveryCharge = "";
    String collectedRAT = "";
    String rounding = "";
    String totalVoids = "";
    String totalSale = "";

    if (report.summary != null) {
      minimumCharge = report.summary.mincharge;
      totalDiscount = report.summary.discount;
      totalDeliveryCharge = report.summary.deliveryCharge;
      collectedRAT = report.summary.collectedRAT;
      rounding = report.summary.rounding;

      totalVoids = report.summary.totalvoid;
      totalSale = Number.getNumber(report.summary.netsale!);
    }
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Min Charge"), pw.Text(minimumCharge)]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Discount"), pw.Text(totalDiscount)]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child:
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Delivery Charge"), pw.Text(totalDeliveryCharge)]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("RAT collected"), pw.Text(collectedRAT)]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Rounding"), pw.Text(rounding)]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Net Sale"), pw.Text(totalSale)]),
      ),
    );
    items.add(
      pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
          width: colWidth,
          child: pw.Container(
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Voids"), pw.Text(totalVoids)]))),
    );

    items.add(pw.SizedBox(height: 30));
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              "Recieved",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
    items.add(pw.Container(
        width: colWidth,
        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Tender"),
            pw.Text("Percentage"),
            pw.Text("Total"),
          ],
        )));

    for (var item in report.methods) {
      items.add(pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(item.name!),
            pw.Text(Number.getNumber(item.percentage!)),
            pw.Text(Number.getNumber(item.amountPaid!)),
          ],
        ),
      ));
    }
    items.add(pw.Container(
        width: colWidth,
        decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total "), pw.Text(report.summary.totalSale)])));

    items.add(pw.SizedBox(height: 30));
    if (report.discount.isNotEmpty) {
      items.add(
        pw.Container(
          width: colWidth,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "Discounts",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );

      items.add(pw.Container(
          width: colWidth,
          decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Name"),
              pw.Text("no.of orders"),
              pw.Text("Discount Amount"),
            ],
          )));
      for (var item in report.discount) {
        items.add(pw.Container(
          width: colWidth,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(item.name!),
              pw.Text(item.noOfOrders == null ? "0" : item.noOfOrders.toString()),
              pw.Text(item.discount),
            ],
          ),
        ));
      }

      items.add(pw.SizedBox(height: 30));
    }

    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              "Stats",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );

    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Items"), pw.Text(report.summary.items_total.toString())]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Order"), pw.Text(report.summary.total_order.toString())]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [pw.Text("Total Guest"), pw.Text(report.summary.total_guests.toString())]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child:
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Avg Order Sale"), pw.Text(report.summary.avgOrderSale)]),
      ),
    );
    items.add(
      pw.Container(
        width: colWidth,
        child:
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Avg Guest Sale"), pw.Text(report.summary.avgGuestSale)]),
      ),
    );

    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              "Short Over",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
    items.add(pw.Container(
        width: colWidth,
        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Tender"),
            pw.Text("Expected"),
            pw.Text("Count"),
            pw.Text("shortOver"),
          ],
        )));
    for (var item in report.shortOver) {
      items.add(pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(item.payment_method!),
            pw.Text((item.start_amount + item.amount_paid).toString()),
            pw.Text(item.end_amount.toString()),
            pw.Text((item.end_amount - (item.start_amount + item.amount_paid)).toString()),
          ],
        ),
      ));
    }

    items.add(pw.SizedBox(height: 30));
    items.add(
      pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              "Sales By Service",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
    items.add(pw.Container(
        width: colWidth,
        decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: 5, color: PdfColors.blueGrey900))),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Name"),
            pw.Text("Total Order"),
            pw.Text("Total Sales"),
          ],
        )));

    for (var item in report.services) {
      items.add(pw.Container(
        width: colWidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(item.serviceName! + "[" + item.totalOrder.toString() + "]"),
            pw.Text(item.totalOrder == null ? "0.0" : item.totalOrder.toString()),
            pw.Text(item.orderTotalPrice),
          ],
        ),
      ));
    }

    // Create a PDF document.
    final document = pw.Document();

    document.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        // theme: pw.ThemeData.withFont(
        //   base: pw.Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        //   bold: pw.Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        //   italic: pw.Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        //   boldItalic: pw.Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        // ),
        margin: pw.EdgeInsets.all(10),
        build: (context) {
          return [
            pw.Container(
                padding: pw.EdgeInsets.only(bottom: 30),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Center(
                    child: pw.Text("Sales Summery", style: pw.TextStyle(fontSize: 18)),
                  ),
                  pw.Center(
                    child: pw.Text(
                      Misc.toShortDate(report.from),
                    ),
                  ),
                  pw.Center(child: pw.Text(Misc.toShortDate(report.to))),
                ])),
            pw.Wrap(
              direction: pw.Axis.vertical,
              spacing: 5,
              runSpacing: 30,
              children: items,
            )
          ];
        }));

    temp = await document.save();
    // Return the PDF file content
    return temp;
  }
}
