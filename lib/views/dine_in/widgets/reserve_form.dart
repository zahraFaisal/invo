import "package:flutter/material.dart";
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class ReserveForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReserveFormState();
  }
}

class _ReserveFormState extends State<ReserveForm> {
  String BlockTableValue = 'Block Table Before 30 Minute';
  String ReleaseTableValue = 'Release Table After 30 Minute';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 450,
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Theme.of(context).primaryColor, width: 5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                height: 60,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Table'),
                    style: TextStyle(color: Colors.orange[600], fontSize: 22),
                  ),
                )),
            Column(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  // row 1
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        // telephone
                        padding: EdgeInsets.all(5),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 6,
                          height: 100,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              labelText: AppLocalizations.of(context)!.translate("Telephone"),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        // name
                        padding: EdgeInsets.all(5),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 6,
                          height: 100,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.translate("Name"),
                              icon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        // guest no.
                        padding: EdgeInsets.all(5),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 6,
                          height: 100,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.supervisor_account,
                                color: Colors.black,
                              ),
                              labelText: AppLocalizations.of(context)!.translate("Guest No."),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  //row 2
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        // reservation date
                        padding: EdgeInsets.all(5),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 6,
                          height: 100,
                          child: TextField(
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.date_range,
                                color: Colors.black,
                              ),
                              labelText: AppLocalizations.of(context)!.translate("Reservation Date"),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        // reservation time
                        padding: EdgeInsets.all(5),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 6,
                          height: 100,
                          child: TextField(
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.timer,
                                color: Colors.black,
                              ),
                              labelText: AppLocalizations.of(context)!.translate("Reservation Time"),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  //row 3
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      // block before

                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.translate("Block Before"),
                          style: TextStyle(
                            fontSize: 20,
                            //  fontWeight: FontWeight.bold
                          ),
                        ),
                        DropdownButton<String>(
                          value: BlockTableValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              BlockTableValue = newValue!;
                            });
                          },
                          items: <String>[
                            'Block Table Before 30 Minute',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Column(
                      // release after
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.translate("Release After"),
                          style: TextStyle(
                            fontSize: 20,
                            //  fontWeight: FontWeight.bold
                          ),
                        ),
                        DropdownButton<String>(
                          value: ReleaseTableValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              ReleaseTableValue = newValue!;
                            });
                          },
                          items: <String>[
                            'Release Table After 30 Minute',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  //row 4
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: PrimaryButton(
                          text: AppLocalizations.of(context)!.translate('Cancel'),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: PrimaryButton(
                          text: AppLocalizations.of(context)!.translate('Confirm'),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
