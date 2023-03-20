import 'dart:async';

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_state.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/widgets/check_box.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class ServicesForm extends StatefulWidget {
  ServicesForm({Key? key}) : super(key: key);

  @override
  _ServicesFormState createState() => _ServicesFormState();
}

class _ServicesFormState extends State<ServicesForm> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late ServiceFormBloc serviceFormBloc;

  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;

  late Service dineIn;
  late Service delivery;
  late Service takeAway;
  late Service carHop;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceFormBloc = new ServiceFormBloc();
    serviceFormBloc.loadServices();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    if (_timer != null) _timer!.cancel();

    super.dispose();

    serviceFormBloc.dispose();
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _formStateKey.currentState!.save();
    serviceFormBloc.eventSink.add(SaveServices(dineIn, delivery, carHop, takeAway));
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Form(
      key: _formStateKey,
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: StreamBuilder(
          stream: serviceFormBloc.services.stream,
          initialData: serviceFormBloc.services.value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget saveBox = Center();

            if (serviceFormBloc.services.value is ServicesIsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (serviceFormBloc.services.value is ServicesIsLoaded) {
              ServicesIsLoaded temp = (serviceFormBloc.services.value as ServicesIsLoaded);
              dineIn = temp.dineIn!;
              carHop = temp.carHop!;
              delivery = temp.delivery!;
              takeAway = temp.takeAway!;
            } else if (serviceFormBloc.services.value is ServicesIsSaving) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    "Saving...",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ],
              ));
            } else if (serviceFormBloc.services.value is ServicesSaved) {
              saveBox = FadeTransition(
                opacity: _animation,
                child: Container(
                  height: 50,
                  color: Colors.green,
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context)!.translate("Save Successfully"),
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )),
                ),
              );
              ServicesSaved temp = (serviceFormBloc.services.value as ServicesSaved);
              dineIn = temp.dineIn!;
              carHop = temp.carHop!;
              delivery = temp.delivery!;
              takeAway = temp.takeAway!;

              _controller.reset();
              _controller.forward();
            }

            return Column(
              children: <Widget>[
                saveBox,
                Expanded(child: orientation == Orientation.portrait ? portrait() : landscape()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget portrait() {
    return ListView(
      children: <Widget>[
        dineInSettings(),
        SizedBox(
          height: 20,
        ),
        deliverySettings(),
        SizedBox(
          height: 20,
        ),
        takeAwaySettings(),
        SizedBox(
          height: 20,
        ),
        carServiceSettings(),
        SizedBox(
          height: 10,
        ),
        actionsButtons(),
      ],
    );
  }

  Widget landscape() {
    return ListView(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: dineInSettings(),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: deliverySettings(),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: takeAwaySettings(),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: carServiceSettings(),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        actionsButtons(),
      ],
    );
  }

  Widget dineInSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Dine In"),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Alias'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: dineIn.alternative,
          onSaved: (value) {
            dineIn.alternative = value;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
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
          child: DropdownButton<int>(
            value: dineIn.price_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Price")),
            onChanged: (int? newValue) {
              setState(() {
                dineIn.price_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.labels.value!.map<DropdownMenuItem<int>>((PriceLabel value) {
              return DropdownMenuItem<int>(
                value: value.id,
                child: Text(value.name!),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Charge'),
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
          child: DropdownButton<int>(
            value: dineIn.surcharge_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Surcharge")),
            onChanged: (int? newValue) {
              setState(() {
                dineIn.surcharge_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.surcharges.value!.map<DropdownMenuItem<int>>((SurchargeList value) {
              return DropdownMenuItem<int>(
                value: value.id,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 60,
          child: CheckBox(
            "",
            isSelected: dineIn.showTableSelection,
            child: Text(
              AppLocalizations.of(context)!.translate("Show Table Selection"),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            size: 40,
            onTap: () {
              setState(() {
                dineIn.showTableSelection = !dineIn.showTableSelection;
              });
            },
          ),
        ),
        SizedBox(
          height: 60,
          child: CheckBox(
            "",
            isSelected: dineIn.allowOneTicketPerTable,
            child: Text(
              AppLocalizations.of(context)!.translate("Allow Only One Ticket Per Table"),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            size: 40,
            onTap: () {
              setState(() {
                dineIn.allowOneTicketPerTable = !dineIn.allowOneTicketPerTable;
              });
            },
          ),
        ),
        SizedBox(
          height: 60,
          child: CheckBox(
            "",
            isSelected: dineIn.showCustomerCount,
            child: Text(
              AppLocalizations.of(context)!.translate("Show Guest Number Dialog"),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            size: 40,
            onTap: () {
              setState(() {
                dineIn.showCustomerCount = !dineIn.showCustomerCount;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget deliverySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Delivery"),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Alias'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: delivery.alternative,
          onSaved: (value) {
            delivery.alternative = value;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Delivery Charge'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: delivery.deliveryCharge.toString(),
          onSaved: (value) {
            delivery.deliveryCharge = double.parse(value!);
          },
          validator: (value) {
            return null;
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
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
          child: DropdownButton<int>(
            value: delivery.price_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Price")),
            onChanged: (int? newValue) {
              setState(() {
                delivery.price_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.labels.value!.map<DropdownMenuItem<int>>((PriceLabel value) {
              return DropdownMenuItem<int>(
                value: value.id,
                child: Text(value.name!),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Charge'),
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
          child: DropdownButton<int>(
            value: delivery.surcharge_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Surcharge")),
            onChanged: (int? newValue) {
              setState(() {
                delivery.surcharge_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.surcharges.value!.map<DropdownMenuItem<int>>((SurchargeList value) {
              return DropdownMenuItem<int>(
                value: value.id,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
        // SizedBox(
        //   height: 80,
        //   child: CheckBox(
        //     "",
        //     child: Text(
        //       "Allow Driver To dispatch Order",
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        //     ),
        //     size: 40,
        //     isSelected: false,
        //     onTap: () {
        //       delivery.setShowCustomerCount = !dineIn.showCustomerCount();
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget takeAwaySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Take Away"),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Alias'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: takeAway.alternative,
          onSaved: (value) {
            takeAway.alternative = value;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
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
          child: DropdownButton<int>(
            value: takeAway.price_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Price")),
            onChanged: (int? newValue) {
              setState(() {
                takeAway.price_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.labels.value!.map<DropdownMenuItem<int>>((PriceLabel value) {
              return DropdownMenuItem<int>(
                value: value.id,
                child: Text(value.name!),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Charge'),
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
          child: DropdownButton<int>(
            value: takeAway.surcharge_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Surcharge")),
            onChanged: (int? newValue) {
              setState(() {
                takeAway.surcharge_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.surcharges.value!.map<DropdownMenuItem<int>>((SurchargeList value) {
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

  Widget carServiceSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Car Service"),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Alias'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: carHop.alternative,
          onSaved: (value) {
            carHop.alternative = value;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
        SizedBox(
          height: 10,
        ),
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
          child: DropdownButton<int>(
            value: carHop.price_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Price")),
            onChanged: (int? newValue) {
              setState(() {
                carHop.price_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.labels.value!.map<DropdownMenuItem<int>>((PriceLabel value) {
              return DropdownMenuItem<int>(
                value: value.id,
                child: Text(value.name!),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.translate('Charge'),
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
          child: DropdownButton<int>(
            value: carHop.surcharge_id,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate("Select Surcharge")),
            onChanged: (int? newValue) {
              setState(() {
                carHop.surcharge_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: serviceFormBloc.surcharges.value!.map<DropdownMenuItem<int>>((SurchargeList value) {
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

  Widget actionsButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
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
                  cancel();
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(left: 8.0),
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
    );
  }
}
