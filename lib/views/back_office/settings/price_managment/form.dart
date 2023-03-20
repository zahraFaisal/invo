// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:invo_mobile/blocs/back_office/settings/price_managment_form_page/price_Managment_state.dart';
import 'package:invo_mobile/blocs/back_office/settings/price_managment_form_page/price_Mangment_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/price_managment_form_page/price_Mnagment_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/widgets/check_box.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class PriceManagmentForm extends StatefulWidget {
  final int id;
  PriceManagmentForm({Key? key, this.id = 0}) : super(key: key);

  @override
  _PriceManagmentFormState createState() => _PriceManagmentFormState();
}

class _PriceManagmentFormState extends State<PriceManagmentForm> {
  late PriceManagmentFormPageBloc priceManagmentBloc;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  PriceManagement priceManagment = new PriceManagement();
  List<DropdownMenuItem<int>> repeats = List<DropdownMenuItem<int>>.empty(growable: true);

  void initState() {
    super.initState();
    priceManagmentBloc = new PriceManagmentFormPageBloc(BlocProvider.of<NavigatorBloc>(context));

    repeats.add(DropdownMenuItem(
      value: 0,
      child: Text("one time"),
    ));
    repeats.add(DropdownMenuItem(
      value: 1,
      child: Text("Daily"),
    ));
    repeats.add(DropdownMenuItem(
      value: 2,
      child: Text("Weekly"),
    ));
    repeats.add(DropdownMenuItem(
      value: 3,
      child: Text("monthly"),
    ));
    repeats.add(DropdownMenuItem(
      value: 4,
      child: Text("yearly"),
    ));
    priceManagmentBloc.loadPriceManagment(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: BlocProvider(
        bloc: priceManagmentBloc,
        child: StreamBuilder(
          stream: priceManagmentBloc.priceManagment.stream,
          initialData: priceManagmentBloc.priceManagment.value,
          builder: (BuildContext context, AsyncSnapshot<PriceManagmentLoadState> snapshot) {
            if (priceManagmentBloc.priceManagment.value is PriceManagmentIsLoaded) {
              priceManagment = (priceManagmentBloc.priceManagment.value as PriceManagmentIsLoaded).price;
              return Form(
                key: _formStateKey,
                child: (orientation == Orientation.landscape) ? landscape() : portrait(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget portrait() {
    return Column(
      children: <Widget>[
        header(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              //itemExtent: 120,
              children: <Widget>[
                //name
                nameField(),
                //From Date
                fromDateField(),
                //To Date
                toDateField(),
                //Start Time
                startTimeField(),
                //End Time
                endTimeField(),
                //Repeat
                repeatField(),
                //Price Label
                priceLableField(),
                //Discount
                discountField(),
                //Surcharge
                surchargeField(),
                //Services
                servicesField(),
                actionButtons(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget landscape() {
    return Column(
      children: <Widget>[
        header(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                //name
                nameField(),
                SizedBox(height: 17),
                //From Date  //To Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: fromDateField(),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: toDateField(),
                    ),
                  ],
                ),
                SizedBox(height: 17),
                //Start Time  //End Time
                Row(
                  children: <Widget>[
                    Expanded(
                      child: startTimeField(),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: endTimeField(),
                    ),
                  ],
                ),
                SizedBox(height: 17),
                //Repeat //Price Label
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: repeatField(),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Expanded(child: priceLableField()),
                    ],
                  ),
                ),
                SizedBox(height: 17),
                //Discount //Surcharge
                Row(
                  children: <Widget>[
                    Expanded(
                      child: discountField(),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: surchargeField(),
                    ),
                  ],
                ),
                SizedBox(height: 17),
                servicesField(),
                SizedBox(height: 17),
                actionButtons(),
                SizedBox(height: 17),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget header() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.only(),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate("Price Management"),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            InkWell(
                child: Text(AppLocalizations.of(context)!.translate("Save"), style: TextStyle(color: Colors.white, fontSize: 20)),
                onTap: () {
                  save();
                })
          ],
        ),
      ),
    );
  }

  Widget nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Name'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (priceManagment != null) ? priceManagment.title : "",
          onChanged: (value) {
            setState(() {
              priceManagment.title = value;
            });
          },
          onSaved: (value) {
            setState(() {
              priceManagment.title = value!;
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter some text';
            } else if (priceManagmentBloc.nameValidation != "") {
              return priceManagmentBloc.nameValidation;
            }
            return null;
          },
          decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget fromDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('From'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: new TextEditingController(text: priceManagment.fromDateText),
          readOnly: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Select From Date';
            }
            return null;
          },
          onTap: () {
            DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2019, 1, 1), maxTime: DateTime(3000, 12, 31),
                onConfirm: (date) {
              print('confirm $date');
              priceManagment.setStartDate(date);

              setState(() {
                priceManagment.from_date = date;
              });
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget toDateField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.translate('To'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        controller: new TextEditingController(text: priceManagment.toDateText),
        readOnly: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Select To Date';
          }
          return null;
        },
        onTap: () {
          DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2019, 1, 1), maxTime: DateTime(3000, 12, 31),
              onConfirm: (date) {
            priceManagment.setEndDate(date);

            setState(() {
              priceManagment.to_date = date;
            });
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget startTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Start Time'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: new TextEditingController(text: priceManagment.fromTimeText),
          readOnly: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Select From Time';
            }
            return null;
          },
          onTap: () {
            DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              onConfirm: (time) {
                priceManagment.setStartTime(time);

                print('confirm $time');
                setState(() {
                  priceManagment.from_time = time;
                });
              },
            );
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget endTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('End Time'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: new TextEditingController(text: priceManagment.toTimeText),
          readOnly: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Select To Time';
            }
            return null;
          },
          onTap: () {
            DatePicker.showTimePicker(context, showSecondsColumn: false, onConfirm: (time) {
              priceManagment.setEndTime(time);

              print('confirm $time');
              setState(() {
                priceManagment.to_time = time;
              });
            });
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget repeatField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.translate('Repeat'),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: new DropdownButton<int>(
              value: priceManagment.repeat,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              onChanged: (int? value) {
                setState(() {
                  priceManagment.repeat = value!;
                });
              },
              style: TextStyle(color: Colors.black),
              underline: Container(
                color: Colors.white,
              ),
              items: repeats,
            ),
          ),
          priceManagment.repeat == 2
              ? Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Sunday"),
                              Switch(
                                value: priceManagment.sunday,
                                onChanged: (value) {
                                  setState(() {
                                    priceManagment.sunday = value;
                                  });
                                },
                                activeTrackColor: Colors.lightGreen,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Monday"),
                              Switch(
                                value: priceManagment.monday,
                                onChanged: (value) {
                                  setState(() {
                                    priceManagment.monday = value;
                                  });
                                },
                                activeTrackColor: Colors.lightGreen,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Tuesday"),
                              Switch(
                                value: priceManagment.tuesday,
                                onChanged: (value) {
                                  setState(() {
                                    priceManagment.tuesday = value;
                                  });
                                },
                                activeTrackColor: Colors.lightGreen,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Wednesday"),
                              Switch(
                                value: priceManagment.wednesday,
                                onChanged: (value) {
                                  setState(() {
                                    priceManagment.wednesday = value;
                                  });
                                },
                                activeTrackColor: Colors.lightGreen,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Thursday"),
                              Switch(
                                value: priceManagment.thursday,
                                onChanged: (value) {
                                  setState(() {
                                    priceManagment.thursday = value;
                                  });
                                },
                                activeTrackColor: Colors.lightGreen,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Friday"),
                              Switch(
                                value: priceManagment.friday,
                                onChanged: (value) {
                                  setState(() {
                                    priceManagment.friday = value;
                                  });
                                },
                                activeTrackColor: Colors.lightGreen,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Saturday"),
                              Switch(
                                value: priceManagment.saturday,
                                onChanged: (value) {
                                  setState(() {
                                    priceManagment.saturday = value;
                                  });
                                },
                                activeTrackColor: Colors.lightGreen,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget priceLableField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Apply this price'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: new DropdownButton<int>(
            value: priceManagmentBloc.labelId,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Price")),
            onChanged: (int? newValue) {
              setState(() {
                priceManagment.price_label_id = newValue!;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: priceManagmentBloc.labels.value!.map<DropdownMenuItem<int>>((PriceLabel price) {
              return DropdownMenuItem<int>(
                value: price.id,
                child: Text(price.name!),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  Widget discountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Apply this discount'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: new DropdownButton<int>(
            value: priceManagmentBloc.discountId,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            hint: Text(AppLocalizations.of(context)!.translate("Select Discount")),
            elevation: 16,
            isExpanded: true,
            onChanged: (int? newValue) {
              setState(() {
                priceManagment.discount_id = newValue!;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: priceManagmentBloc.discounts.value!.map<DropdownMenuItem<int>>((DiscountList value) {
              return DropdownMenuItem<int>(
                value: value.id,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget surchargeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Apply this surcharge'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          // ignore: unnecessary_new
          child: new DropdownButton<int>(
            value: priceManagmentBloc.surchargeId,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            hint: Text(AppLocalizations.of(context)!.translate("Select Surcharge")),
            isExpanded: true,
            onChanged: (int? newValue) {
              setState(() {
                priceManagment.surcharge_id = newValue!;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: priceManagmentBloc.surcharges.value!.map<DropdownMenuItem<int>>((SurchargeList surcharge) {
              print(surcharge.id);
              return DropdownMenuItem<int>(
                value: surcharge.id,
                child: Text(surcharge.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget servicesField() {
    return Column(children: [
      Row(children: <Widget>[
        Expanded(
          child: CheckBox(
            AppLocalizations.of(context)!.translate("Dine In"),
            isSelected: priceManagment.dineIn,
            onTap: () {
              setState(() {
                priceManagment.dineIn = !priceManagment.dineIn;
              });
            },
          ),
        ),
        Expanded(
          child: CheckBox(
            AppLocalizations.of(context)!.translate("Delivery"),
            isSelected: priceManagment.delivery,
            onTap: () {
              setState(() {
                priceManagment.delivery = !priceManagment.delivery;
              });
            },
          ),
        ),
      ]),
      Row(children: <Widget>[
        Expanded(
          child: CheckBox(
            AppLocalizations.of(context)!.translate("Take Away"),
            isSelected: priceManagment.takeAway,
            onTap: () {
              setState(() {
                priceManagment.takeAway = !priceManagment.takeAway;
              });
            },
          ),
        ),
        Expanded(
          child: CheckBox(
            AppLocalizations.of(context)!.translate("Car Service"),
            isSelected: priceManagment.carService,
            onTap: () {
              setState(() {
                priceManagment.carService = !priceManagment.carService;
              });
            },
          ),
        ),
      ])
    ]);
  }

  Widget actionButtons() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                height: 70,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Cancel'),
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              child: ButtonTheme(
                height: 70,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Save'),
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  onPressed: () {
                    save();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await priceManagmentBloc.asyncValidate(priceManagment)) {
        priceManagmentBloc.eventSink.add(SavePriceManagment(priceManagment));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }
}
