import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/pricesForm/prices_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/pricesForm/prices_form_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/pricesForm/prices_form_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../../service_locator.dart';
import '../../../blocProvider.dart';

class PriceLabelForm extends StatefulWidget {
  final int id;
  final bool isCopy;
  PriceLabelForm({Key? key, this.id = 0, this.isCopy = false}) : super(key: key);

  @override
  _PriceLabelFormState createState() => _PriceLabelFormState();
}

class _PriceLabelFormState extends State<PriceLabelForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late PriceFormBloc priceFormBloc;
  late PriceLabel price;
  void initState() {
    super.initState();

    priceFormBloc = PriceFormBloc(BlocProvider.of<NavigatorBloc>(context));
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    priceFormBloc.dispose();
  }

  void loadData() async {
    await priceFormBloc.loadPrice(widget.id, isCopy: widget.isCopy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        cancel();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.translate("Prices"),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    InkWell(
                        child: Text(
                          AppLocalizations.of(context)!.translate("Save"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () {
                          save();
                        })
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: priceFormBloc.price.stream,
                  initialData: priceFormBloc.price.value,
                  builder: (BuildContext context, AsyncSnapshot<PricesLoadState> snapshot) {
                    if (priceFormBloc.price.value is PriceIsLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (priceFormBloc.price.value is PriceIsLoaded) price = (priceFormBloc.price.value as PriceIsLoaded).price;
                    return Form(
                      key: _formStateKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          children: <Widget>[
                            nameField(),
                            inActiveField(),
                            actionsButtons(),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await priceFormBloc.asyncValidate(price)) {
        priceFormBloc.eventSink.add(SavePrice(price));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  Widget nameField() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(
        AppLocalizations.of(context)!.translate('Name'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: price.name,
        onSaved: (value) {
          price.name = value;
        },
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please enter some text';
          } else if (priceFormBloc.nameValidation != "") {
            return priceFormBloc.nameValidation;
          }
          return null;
        },
        decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget inActiveField() {
    return FormField(
        onSaved: (bool? value) {
          price.in_active = value;
        },
        validator: null,
        initialValue: price.in_active,
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ButtonTheme(
            height: 70,
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
              child: Text(
                AppLocalizations.of(context)!.translate('Cancel'),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {
                cancel();
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: ButtonTheme(
              height: 70,
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                child: Text(
                  AppLocalizations.of(context)!.translate('Save'),
                  style: TextStyle(fontSize: 20, color: Colors.white),
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
