import 'package:flutter/material.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/layout/footer_landscape.dart';
import 'package:invo_mobile/widgets/layout/header_landscape.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class ReservationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReservationsPageState();
  }
}

class _ReservationsPageState extends State<ReservationsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            HeaderLandscape(),
            Expanded(
                child: Column(
              children: <Widget>[
                Padding(
                  // reservation page header
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: TextField(
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.date_range),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                labelText: AppLocalizations.of(context)!.translate("Search"),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: SizedBox(
                              height: 50,
                              child: PrimaryButton(
                                text: "X",
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 0.5,
                ),
                Expanded(
                  child: Padding(
                    // datatable of reservations
                    padding: EdgeInsets.all(5),
                    child: DataTable(
                      horizontalMargin: 1,
                      columns: [
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.translate("Time"),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.translate("Table"),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.translate("Server"),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.translate("Customer"),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.translate("Telephone"),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(context)!.translate("Guest"),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                        )),
                      ],
                      rows: [],
                    ),
                  ),
                )
              ],
            )),
            FooterLandscape()
          ],
        ),
      ),
    ));
  }
}
