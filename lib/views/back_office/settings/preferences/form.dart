import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:invo_mobile/blocs/back_office/settings/preference_page/preferences_page_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/preference_page/preferences_page_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/preference_page/preferences_page_state.dart';
import 'package:invo_mobile/helpers/misc.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/widgets/switch_form_field.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../image.dart';

class PreferencesForm extends StatefulWidget {
  PreferencesForm({Key? key}) : super(key: key);

  @override
  _PreferencesFormState createState() => _PreferencesFormState();
}

class _PreferencesFormState extends State<PreferencesForm> {
  List<DropdownMenuItem<int>> types = List<DropdownMenuItem<int>>.empty(growable: true);
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  late PreferenceBlocPage preferenceBlocPage;
  late Preference preference;
  Timer? _timer;
  int? selectedOpenDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    preferenceBlocPage = PreferenceBlocPage();
    types.add(DropdownMenuItem(
      value: 1,
      child: Text("Normal Rounding"),
    ));
    types.add(DropdownMenuItem(
      value: 2,
      child: Text("Negative Rounding"),
    ));
    types.add(DropdownMenuItem(
      value: 3,
      child: Text("Postive Rounding"),
    ));
  }

  @override
  void dispose() {
    super.dispose();

    if (_timer != null) _timer!.cancel();

    preferenceBlocPage.dispose();
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Container(
      color: Colors.white,
      child: StreamBuilder(
        stream: preferenceBlocPage.preference.stream,
        initialData: preferenceBlocPage.preference.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (preferenceBlocPage.preference.value is PreferenceIsLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          Widget saveBox = Center();

          if (preferenceBlocPage.preference.value is PreferenceIsLoaded)
            preference = (preferenceBlocPage.preference.value as PreferenceIsLoaded).preference;
          else if (preferenceBlocPage.preference.value is PreferenceSaved) {
            saveBox = Container(
              height: 50,
              color: Colors.green,
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.translate("Save Successfully"),
                style: TextStyle(color: Colors.white),
              )),
            );
            preference = (preferenceBlocPage.preference.value as PreferenceSaved).preference;

            _timer = new Timer(const Duration(milliseconds: 1500), () {
              setState(() {
                preferenceBlocPage.preference.value = PreferenceIsLoaded(preference);
              });
            });
          } else if (preferenceBlocPage.preference.value is PreferenceError) {
            saveBox = Container(
              height: 50,
              color: Colors.red,
              child: Center(
                  child: Text(
                (preferenceBlocPage.preference.value as PreferenceError).error,
                style: TextStyle(color: Colors.white),
              )),
            );
            preference = (preferenceBlocPage.preference.value as PreferenceError).preference;

            _timer = new Timer(const Duration(milliseconds: 2000), () {
              setState(() {
                preferenceBlocPage.preference.value = PreferenceIsLoaded(preference);
              });
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              saveBox,
              Expanded(
                child: Form(
                  key: _formStateKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: orientation == Orientation.portrait ? portrait() : landscape(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();
      preferenceBlocPage.eventSink.add(SavePreference(preference));
    } else {
      preferenceBlocPage.preference.sinkValue(PreferenceError(preference, "Error Please Check the requirments"));
    }
  }

  void cancel() {
    // Navigator.of(context).pop();
  }

  Widget actionsButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ButtonTheme(
        //     height: 70,
        //     minWidth: 150,
        //     child: ElevatedButton(
        //       color: Colors.blueGrey[900],
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       child: Text(
        //         'Cancel',
        //         style: TextStyle(fontSize: 24, color: Colors.white),
        //       ),
        //       onPressed: () {
        //         cancel();
        //       },
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            height: 70,
            minWidth: 150,
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
      ],
    );
  }

  Widget portrait() {
    return ListView(
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("General"),
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        restaurantName(),
        SizedBox(
          height: 10,
        ),
        openAtField(),
        SizedBox(
          height: 10,
        ),
        telephoneField(),
        SizedBox(
          height: 10,
        ),
        faxField(),
        SizedBox(
          height: 10,
        ),
        address1Field(),
        SizedBox(
          height: 10,
        ),
        address2Field(),
        SizedBox(
          height: 10,
        ),
        websiteField(),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Options"),
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        oneCashierPerTerminalField(),
        SizedBox(
          height: 10,
        ),
        noSalesWhenCountDownField(),
        SizedBox(
          height: 10,
        ),
        hideVoidedItemField(),
        SizedBox(
          height: 10,
        ),
        voidedItemNeedExplanationField(),
        SizedBox(
          height: 10,
        ),
        disableHalfItemField(),
        SizedBox(
          height: 10,
        ),
        maxRefField(),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Currency"),
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        smallestCurrencyField(),
        SizedBox(
          height: 10,
        ),
        roundTypeField(),
        SizedBox(
          height: 10,
        ),
        afterDecimalField(),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Tax"),
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        tax1NameField(),
        SizedBox(
          height: 10,
        ),
        tax1Field(),
        SizedBox(
          height: 10,
        ),
        tax2NameField(),
        SizedBox(
          height: 10,
        ),
        tax2Field(),
        SizedBox(
          height: 10,
        ),
        tax3NameField(),
        SizedBox(
          height: 10,
        ),
        tax3Field(),
        SizedBox(
          height: 10,
        ),
        tax2Tax1Field(),
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Print Options"),
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        printRestaurantNameField(),
        SizedBox(
          height: 10,
        ),
        printTicketWhenSentField(),
        SizedBox(
          height: 10,
        ),
        printTicketWhenPaidField(),
        SizedBox(
          height: 10,
        ),
        printRecipetNameAsSeconderyNameField(),
        SizedBox(
          height: 10,
        ),
        printModPriceOnTicketField(),
        SizedBox(
          height: 30,
        ),
        Container(
          height: 50,
          color: Colors.grey[100],
          child: Center(
            child: Text(
              "Address Format",
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        flatField(),
        SizedBox(
          height: 10,
        ),
        buildingField(),
        SizedBox(
          height: 10,
        ),
        roadField(),
        SizedBox(
          height: 10,
        ),
        streetField(),
        SizedBox(
          height: 10,
        ),
        blockField(),
        SizedBox(
          height: 10,
        ),
        zipCodeField(),
        SizedBox(
          height: 10,
        ),
        cityField(),
        SizedBox(
          height: 10,
        ),
        stateField(),
        SizedBox(
          height: 10,
        ),
        postalCodeField(),
        SizedBox(
          height: 10,
        ),
        line1Field(),
        SizedBox(
          height: 10,
        ),
        line2Field(),
        SizedBox(
          height: 30,
        ),
        actionsButtons(),
      ],
    );
  }

  Widget landscape() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.grey[100],
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("General"),
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    restaurantName(),
                    SizedBox(
                      height: 10,
                    ),
                    openAtField(),
                    SizedBox(
                      height: 10,
                    ),
                    telephoneField(),
                    SizedBox(
                      height: 10,
                    ),
                    faxField(),
                    SizedBox(
                      height: 10,
                    ),
                    address1Field(),
                    SizedBox(
                      height: 10,
                    ),
                    address2Field(),
                    SizedBox(
                      height: 10,
                    ),
                    websiteField(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: logoField(),
              ),
            ],
          ),
          Container(
            height: 50,
            color: Colors.grey[100],
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Options"),
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          oneCashierPerTerminalField(),
          SizedBox(
            height: 10,
          ),
          noSalesWhenCountDownField(),
          SizedBox(
            height: 10,
          ),
          hideVoidedItemField(),
          SizedBox(
            height: 10,
          ),
          voidedItemNeedExplanationField(),
          SizedBox(
            height: 10,
          ),
          disableHalfItemField(),
          SizedBox(
            height: 10,
          ),
          maxRefField(),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            color: Colors.grey[100],
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Currency"),
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          smallestCurrencyField(),
          SizedBox(
            height: 10,
          ),
          roundTypeField(),
          SizedBox(
            height: 10,
          ),
          afterDecimalField(),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            color: Colors.grey[100],
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Tax"),
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(child: tax1NameField()),
              SizedBox(
                width: 20,
              ),
              Expanded(child: tax1Field()),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(child: tax2NameField()),
              SizedBox(
                width: 20,
              ),
              Expanded(child: tax2Field()),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(child: tax3NameField()),
              SizedBox(
                width: 20,
              ),
              Expanded(child: tax3Field()),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          tax2Tax1Field(),
          Container(
            height: 50,
            color: Colors.grey[100],
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("Print Options"),
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ),
          printRestaurantNameField(),
          SizedBox(
            height: 10,
          ),
          printTicketWhenSentField(),
          SizedBox(
            height: 10,
          ),
          printTicketWhenPaidField(),
          SizedBox(
            height: 10,
          ),
          printRecipetNameAsSeconderyNameField(),
          SizedBox(
            height: 10,
          ),
          printModPriceOnTicketField(),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            color: Colors.grey[100],
            child: Center(
              child: Text(
                "Address Format",
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: flatField()),
              Expanded(child: flatRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: buildingField()),
              Expanded(child: buildingRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: roadField()),
              Expanded(child: roadRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: streetField()),
              Expanded(child: streetRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: blockField()),
              Expanded(child: blockRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: zipCodeField()),
              Expanded(child: zipCodeRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: cityField()),
              Expanded(child: cityRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [Expanded(child: stateField()), Expanded(child: stateRequiredField())],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: postalCodeField()),
              Expanded(child: postalCodeRequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: line1Field()),
              Expanded(child: line1RequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(child: line2Field()),
              Expanded(child: line1RequiredField()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          actionsButtons(),
        ],
      ),
    );
  }

  Widget logoField() {
    return Container(
        height: 300,
        child: Center(
            child: ImageGetter(
          initValue: preference.logoByte,
          onPick: (String image) {
            preference.restaurantLogo = image;
          },
          validator: (String? value) {},
        )));
  }

  Widget restaurantName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Restaurant Name'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.restaurantName,
          onSaved: (value) {
            preference.restaurantName = value;
          },
          validator: (value) {
            if (value == "" || value == null) {
              return "Restaurant name is required";
            }
            return null;
          },
          decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget openAtField() {
    if (preference != null) selectedOpenDate = (preference.day_start != null ? preference.day_start!.hour : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Restaurant opening time'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
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
            value: selectedOpenDate,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate('Select Opening Hour')),
            onChanged: (int? value) {
              setState(() {
                preference.day_start = new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day, value!);
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items:
                <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(Misc.shortTime(hour: value)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget address1Field() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Address Line 1'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.address1,
          onSaved: (value) {
            preference.address1 = value!;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: 'will appear in the receipt', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget address2Field() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Address Line 2'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.address2,
          onSaved: (value) {
            preference.address2 = value!;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: 'will appear in the receipt', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget telephoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Telephone'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.phone,
          onSaved: (value) {
            preference.phone = value!;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: 'will appear in the receipt', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget faxField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Fax'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.fax,
          onSaved: (value) {
            preference.fax = value!;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: 'will appear in the receipt', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget websiteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Website'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.url,
          onSaved: (value) {
            preference.url = value!;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: 'will appear in the receipt', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget oneCashierPerTerminalField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Allow Only one Cashier Per Terminal'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.onlyOneCashierPerTerminal = value!;
      },
      initialValue: preference.onlyOneCashierPerTerminal,
    );
  }

  Widget noSalesWhenCountDownField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('No Sales When Count Down is Zero'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.dontAllowSaleWhenCountDownIsZero = value!;
      },
      initialValue: preference.dontAllowSaleWhenCountDownIsZero,
    );
  }

  Widget hideVoidedItemField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Hide Voided Item'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.hideVoidedItem = value!;
      },
      initialValue: preference.hideVoidedItem,
    );
  }

  Widget voidedItemNeedExplanationField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Voided Item Need Explanation'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.voidedItemNeedExplantion = value!;
      },
      initialValue: preference.dontAllowSaleWhenCountDownIsZero,
    );
  }

  Widget maxRefField() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.translate('Max Ticket Reference'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 100,
            child: TextFormField(
              initialValue: preference.maxRef.toString(),
              onSaved: (String? value) {
                if (int.tryParse(value!) != null) {
                  preference.maxRef = int.parse(value);
                }
              },
              validator: (value) {
                return null;
              },
              maxLength: 3,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget disableHalfItemField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Disable Half Item'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.disableHalfItem = value!;
      },
      initialValue: preference.disableHalfItem,
    );
  }

  Widget smallestCurrencyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Smallest Currency'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.smallestCurrency.toString(),
          onSaved: (String? value) {
            preference.smallestCurrency = double.tryParse(value!);
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget roundTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Round Type'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
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
            value: preference.roundType,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate('Select Type')),
            onChanged: (int? value) {
              setState(() {
                preference.roundType = value;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: types,
          ),
        ),
      ],
    );
  }

  Widget afterDecimalField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('After Decimal'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
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
            value: preferenceBlocPage.connectionRepository!.cash!.after_decimal,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(''),
            onChanged: (int? value) {
              setState(() {
                preferenceBlocPage.connectionRepository!.cash!.after_decimal = value!;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: <int>[0, 1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(10.toStringAsFixed(value)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget tax1NameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Tax 1 Name'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.tax1Alias,
          onSaved: (value) {
            if (value != "") {
              preference.tax1_name = value!;
            } else {
              preference.tax1_name = preference.tax1Alias!;
            }
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget tax1Field() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Tax 1 (exclusive)'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.tax1 == null ? "0.0" : preference.tax1.toString(),
          onSaved: (String? value) {
            preference.tax1 = double.parse(value!);
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget tax2NameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Tax 2 Name'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.tax2Alias,
          onSaved: (value) {
            if (value != "") {
              preference.tax2_name = value!;
            } else {
              preference.tax2_name = preference.tax2Alias!;
            }
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget tax2Field() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Tax 2 (exclusive)'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.tax2 == null ? "0.0" : preference.tax2.toString(),
          onSaved: (String? value) {
            preference.tax2 = double.parse(value!);
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget tax3NameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Tax 3 Name'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.tax3Alias,
          onSaved: (value) {
            if (value != "") {
              preference.tax3_name = value!;
            } else {
              preference.tax3_name = preference.tax3Alias!;
            }
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget tax3Field() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Tax 3 (inclusive)'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: preference.tax3 == null ? "0.0" : preference.tax3.toString(),
          onSaved: (String? value) {
            preference.tax3 = double.parse(value!);
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget tax2Tax1Field() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Tax 2 is Comulative with tax 1'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.tax2_tax1 = value!;
      },
      initialValue: preference.tax2_tax1,
    );
  }

  Widget printRestaurantNameField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Print Restaurant Name'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.printRestaurantName = value;
      },
      initialValue: preference.printRestaurantName != null ? preference.printRestaurantName! : false,
    );
  }

  Widget printTicketWhenSentField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Print Ticket When Sent'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.printTicketWhenSent = value!;
      },
      initialValue: preference.printTicketWhenSent != null ? preference.printTicketWhenSent : false,
    );
  }

  Widget printTicketWhenPaidField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Print Receipt When Paid'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.printTicketWhenSettle = value!;
      },
      initialValue: preference.printTicketWhenSettle != null ? preference.printTicketWhenSettle : false,
    );
  }

  Widget printRecipetNameAsSeconderyNameField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Print Receipt Name As Secondary Name'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.printRecipetNameAsSeconderyName = value;
      },
      initialValue: preference.printRecipetNameAsSeconderyName != null ? preference.printRecipetNameAsSeconderyName! : false,
    );
  }

  Widget printModPriceOnTicketField() {
    return SwitchFormField(
      title: Text(
        AppLocalizations.of(context)!.translate('Print Modifier Price On Ticket'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.printModPriceOnTicket = value;
      },
      initialValue: preference.printModPriceOnTicket != null ? preference.printModPriceOnTicket! : false,
    );
  }

  Widget flatField() {
    return SwitchFormField(
      title: Text(
        "Flat",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.flat = value;
      },
      initialValue: preference.flat != null ? preference.flat! : false,
    );
  }

  Widget flatRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.flat_required = value;
      },
      initialValue: preference.flat_required != null ? preference.flat_required! : false,
    );
  }

  Widget buildingField() {
    return SwitchFormField(
      title: Text(
        "Building",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.building = value;
      },
      initialValue: preference.building != null ? preference.building! : false,
    );
  }

  Widget buildingRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.building_required = value;
      },
      initialValue: preference.building_required != null ? preference.building_required! : false,
    );
  }

  Widget houseField() {
    return SwitchFormField(
      title: Text(
        "House",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.house = value;
      },
      initialValue: preference.house != null ? preference.house! : false,
    );
  }

  Widget houseRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.house_required = value;
      },
      initialValue: preference.house_required != null ? preference.house_required! : false,
    );
  }

  Widget roadField() {
    return SwitchFormField(
      title: Text(
        "Road",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.road = value;
      },
      initialValue: preference.road != null ? preference.road! : false,
    );
  }

  Widget roadRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.road_required = value;
      },
      initialValue: preference.road_required != null ? preference.road_required! : false,
    );
  }

  Widget streetField() {
    return SwitchFormField(
      title: Text(
        "Street",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.street = value;
      },
      initialValue: preference.street != null ? preference.street! : false,
    );
  }

  Widget streetRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.street_required = value;
      },
      initialValue: preference.street_required != null ? preference.street_required! : false,
    );
  }

  Widget blockField() {
    return SwitchFormField(
      title: Text(
        "Block",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.block = value;
      },
      initialValue: preference.block != null ? preference.block! : false,
    );
  }

  Widget blockRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.block_required = value;
      },
      initialValue: preference.block_required != null ? preference.block_required! : false,
    );
  }

  Widget zipCodeField() {
    return SwitchFormField(
      title: Text(
        "ZipCode",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.zipCode = value;
      },
      initialValue: preference.zipCode != null ? preference.zipCode! : false,
    );
  }

  Widget zipCodeRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.zipCode_required = value;
      },
      initialValue: preference.zipCode_required != null ? preference.zipCode_required! : false,
    );
  }

  Widget cityField() {
    return SwitchFormField(
      title: Text(
        "City",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.city = value;
      },
      initialValue: preference.city != null ? preference.city! : false,
    );
  }

  Widget cityRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.city_required = value;
      },
      initialValue: preference.city_required != null ? preference.city_required! : false,
    );
  }

  Widget stateField() {
    return SwitchFormField(
      title: Text(
        "State",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.state = value;
      },
      initialValue: preference.state != null ? preference.state! : false,
    );
  }

  Widget stateRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.state_required = value;
      },
      initialValue: preference.state_required != null ? preference.state_required! : false,
    );
  }

  Widget postalCodeField() {
    return SwitchFormField(
      title: Text(
        "Postal Code",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.postalCode = value;
      },
      initialValue: preference.postalCode != null ? preference.postalCode! : false,
    );
  }

  Widget postalCodeRequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.postalCode_required = value;
      },
      initialValue: preference.postalCode_required != null ? preference.postalCode_required! : false,
    );
  }

  Widget line1Field() {
    return SwitchFormField(
      title: Text(
        "Line 1",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.line1 = value;
      },
      initialValue: preference.line1 != null ? preference.line1! : false,
    );
  }

  Widget line1RequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.line1_required = value;
      },
      initialValue: preference.line1_required != null ? preference.line1_required! : false,
    );
  }

  Widget line2Field() {
    return SwitchFormField(
      title: Text(
        "Line 2",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.line2 = value;
      },
      initialValue: preference.line2 != null ? preference.line2! : false,
    );
  }

  Widget line2RequiredField() {
    return SwitchFormField(
      title: Text(
        "Required",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSaved: (value) {
        preference.line2_required = value;
      },
      initialValue: preference.line2_required != null ? preference.line2_required! : false,
    );
  }
}
