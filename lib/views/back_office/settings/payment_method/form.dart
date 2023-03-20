import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/backoffice/backoffice_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/payment_method_form_page/payment_method_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/payment_method_form_page/payment_method_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/payment_method_form_page/payment_method_form_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/payment_method.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:invo_mobile/widgets/translation/application.dart';

import '../../../blocProvider.dart';
import '../../image.dart';

class PaymentMethodForm extends StatefulWidget {
  int id;
  PaymentMethodForm({Key? key, this.id = 0}) : super(key: key);

  @override
  _PaymentMethodFormState createState() => _PaymentMethodFormState();
}

class _PaymentMethodFormState extends State<PaymentMethodForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late PaymentMethodFormPageBloc paymentMethodFormBloc;
  late PaymentMethod method;
  List<DropdownMenuItem<int>> types = List<DropdownMenuItem<int>>.empty(growable: true);

  void initState() {
    super.initState();
    paymentMethodFormBloc = new PaymentMethodFormPageBloc(BlocProvider.of<NavigatorBloc>(context));
    loadData();
    types.add(DropdownMenuItem(
      value: 1,
      child: Text("Cash"),
    ));
    types.add(DropdownMenuItem(
      value: 2,
      child: Text("Card"),
    ));
    types.add(DropdownMenuItem(
      value: 3,
      child: Text("cheque"),
    ));
  }

  void loadData() async {
    await paymentMethodFormBloc.loadPaymentMethod(widget.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    paymentMethodFormBloc.dispose();
  }

  late String dropdownValue;
  late String dropdownCategoryValue;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formStateKey,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: StreamBuilder(
                stream: paymentMethodFormBloc.method.stream,
                initialData: PaymentMethodIsLoading(),
                builder: (BuildContext context, AsyncSnapshot<PaymentMethodLoadState> snapshot) {
                  if (paymentMethodFormBloc.method.value is PaymentMethodIsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (paymentMethodFormBloc.method.value is PaymentMethodIsLoaded)
                    method = (paymentMethodFormBloc.method.value as PaymentMethodIsLoaded).method;

                  return Column(children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
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
                                AppLocalizations.of(context)!.translate("Payment Method"),
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: (orientation == Orientation.landscape) ? landscape() : portrait(),
                      ),
                    ),
                  ]);
                })),
      ),
    );
  }

  Widget portrait() {
    return ListView(
      children: <Widget>[
        logoField(),
        nameField(),
        SizedBox(
          height: 10,
        ),
        typeField(),
        SizedBox(
          height: 10,
        ),
        method.type == 1 ? rateField() : Container(),
        SizedBox(
          height: 10,
        ),
        method.type == 1 ? symbolField() : Container(),
        SizedBox(
          height: 10,
        ),
        method.type == 1 ? afterDecimalField() : Container(),
        SizedBox(
          height: 10,
        ),
        inActiveField(),
        SizedBox(
          height: 10,
        ),
        actionsButtons()
      ],
    );
  }

  Widget landscape() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            // itemExtent: 100,
            children: <Widget>[
              nameField(),
              SizedBox(
                height: 15,
              ),
              typeField(),
              SizedBox(
                height: 15,
              ),
              method.type == 1 ? rateField() : Container(),
              SizedBox(
                height: 15,
              ),
              method.type == 1 ? symbolField() : Container(),
              SizedBox(
                height: 15,
              ),
              method.type == 1 ? afterDecimalField() : Container(),
              SizedBox(
                height: 15,
              ),
              inActiveField(),
              SizedBox(
                height: 15,
              ),
              actionsButtons()
            ],
          ),
        ),
        Container(
          width: 300,
          child: logoField(),
        )
      ],
    );
  }

  Widget logoField() {
    return Container(
        height: 300,
        child: Center(
            child: ImageGetter(
          onPick: (String) {},
          validator: (String? value) {},
        )));
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
          initialValue: method.name,
          onSaved: (value) {
            method.name = value!;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter some text';
            } else if (paymentMethodFormBloc.nameValidation != "") {
              return paymentMethodFormBloc.nameValidation;
            }
            return null;
          },
          decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
        )
      ],
    );
  }

  Widget typeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Type'),
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
              value: method.type,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              hint: Text(AppLocalizations.of(context)!.translate('Select Type')),
              onChanged: (int? value) {
                setState(() {
                  method.type = value!;
                });
              },
              style: TextStyle(color: Colors.black),
              underline: Container(
                color: Colors.white,
              ),
              items: types),
        )
      ],
    );
  }

  Widget rateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Rate'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: TextEditingController(text: method.rate.toString()),
          validator: (String? value) {
            double? x = double.tryParse(value!);
            if (x! <= 0) {
              return 'Rate must be greater than 0';
            }
            return null;
          },
          onChanged: (value) {
            method.rate = double.parse(value);
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        )
      ],
    );
  }

  Widget symbolField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Symbol'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onChanged: (value) {
            method.symbol = value;
          },
          controller: TextEditingController(text: method.symbol.toString()),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        )
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onChanged: (value) {
            method.after_decimal = int.parse(value);
          },
          controller: TextEditingController(text: method.after_decimal.toString()),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        )
      ],
    );
  }

  Widget inActiveField() {
    return FormField(
        onSaved: (bool? value) {
          method.in_active = value!;
        },
        validator: null,
        initialValue: method.in_active,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              AppLocalizations.of(context)!.translate('In Active'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: state.value!,
            onChanged: (bool value) => state.didChange(value),
          );
        });
  }

  Widget actionsButtons() {
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
                    AppLocalizations.of(context)!.translate('Done'),
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

      if (await paymentMethodFormBloc.asyncValidate(method)) {
        paymentMethodFormBloc.eventSink.add(SavePaymentMethod(method));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }
}
