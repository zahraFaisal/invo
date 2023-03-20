import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/SurchargeForm/surcharge_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/SurchargeForm/surcharge_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/SurchargeForm/surcharge_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/widgets/check_box.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import '../../../blocProvider.dart';

class SurchargeForm extends StatefulWidget {
  final bool isCopy;
  SurchargeForm({Key? key, this.id = 0, this.isCopy = false}) : super(key: key);
  int id;

  @override
  _SurchargeFormState createState() => _SurchargeFormState();
}

class _SurchargeFormState extends State<SurchargeForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  late SurchargeFormBloc surchargeFormBloc;
  late Surcharge surcharge;
  TextEditingController nameController = TextEditingController();

  void initState() {
    super.initState();
    surchargeFormBloc = SurchargeFormBloc(BlocProvider.of<NavigatorBloc>(context));
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    surchargeFormBloc.dispose();
  }

  void loadData() async {
    await surchargeFormBloc.loadSurcharge(widget.id, isCopy: widget.isCopy);
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: surchargeFormBloc.surcharge.stream,
          initialData: surchargeFormBloc.surcharge.value,
          builder: (BuildContext context, AsyncSnapshot<SurchargeLoadState> snapshot) {
            if (surchargeFormBloc.surcharge.value is SurchargeIsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (surchargeFormBloc.surcharge.value is SurchargeIsLoaded)
              surcharge = (surchargeFormBloc.surcharge.value as SurchargeIsLoaded).surcharge;
            return Form(
              key: _formStateKey,
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
                              AppLocalizations.of(context)!.translate("Surcharge"),
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
                      padding: const EdgeInsets.all(10.0),
                      child: orientation == Orientation.portrait ? portrait() : landscape(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget portrait() {
    return ListView(
      children: <Widget>[
        nameField(),
        typeField(),
        amountField(),
        Container(margin: EdgeInsets.only(top: 10, bottom: 10), child: descriptionField()),
        tax1Field(),
        tax2Field(),
        tax3Field(),
        inActiveField(),
        actionsButtons(),
      ],
    );
  }

  Widget landscape() {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: nameField(),
            ),
            Container(
              width: 200,
              child: inActiveField(),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: typeField(),
            ),
            Expanded(
              child: amountField(),
            ),
          ],
        ),
        descriptionField(),
        Row(
          children: <Widget>[
            Expanded(
              child: tax1Field(),
            ),
            Expanded(
              child: tax2Field(),
            ),
            Expanded(
              child: tax3Field(),
            ),
          ],
        ),
        actionsButtons(),
      ],
    );
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await surchargeFormBloc.asyncValidate(surcharge)) {
        surchargeFormBloc.eventSink.add(SaveSurcharge(surcharge));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  Widget actionsButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            height: 70,
            minWidth: 150,
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            height: 70,
            minWidth: 150,
            child: ElevatedButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(4)),
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
      ],
    );
  }

  Widget nameField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          initialValue: surcharge.name,
          onSaved: (String? value) {
            surcharge.name = value!;
          },
          decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget typeField() {
    return Container(
      height: 100,
      child: Row(children: [
        Container(
          width: 100,
          child: Text(
            AppLocalizations.of(context)!.translate('Type'),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: CheckBox(
            AppLocalizations.of(context)!.translate("Amount"),
            isSelected: !surcharge.is_percentage,
            onTap: () {
              setState(() {
                surcharge.is_percentage = false;
              });
            },
          ),
        ),
        Expanded(
          child: CheckBox(
            AppLocalizations.of(context)!.translate("Percentage"),
            isSelected: surcharge.is_percentage,
            onTap: () {
              setState(() {
                surcharge.is_percentage = true;
              });
            },
          ),
        ),
      ]),
    );
  }

  Widget amountField() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.translate('Amount'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              initialValue: surcharge.amount.toString(),
              onSaved: (String? value) {
                surcharge.amount = double.parse(value!);
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'This Field is Required', border: OutlineInputBorder()),
            ),
          ),
          surcharge.is_percentage
              ? Container(
                  width: 40,
                  child: Text(
                    "%",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                )
              : Center(),
        ],
      ),
    ]);
  }

  Widget inActiveField() {
    return FormField(
        onSaved: (bool? value) {
          surcharge.in_active = value!;
        },
        validator: null,
        initialValue: surcharge.in_active,
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

  Widget descriptionField() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        AppLocalizations.of(context)!.translate('Description'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: surcharge.description == null ? "" : surcharge.description,
        onSaved: (value) {
          surcharge.description = value!;
        },
        decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget tax1Field() {
    return StreamBuilder(
        stream: surchargeFormBloc.preference!.stream,
        builder: (context, snapshot) {
          return FormField(
              onSaved: (bool? value) {
                surcharge.apply_tax1 = value!;
              },
              validator: null,
              initialValue: surcharge.apply_tax1,
              builder: (FormFieldState<bool> state) {
                return SwitchListTile(
                  activeColor: Colors.green,
                  title: Text(
                    surchargeFormBloc.preference != null ? surchargeFormBloc.preference!.value!.tax1Alias! : 'Tax 1',
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
        });
  }

  Widget tax2Field() {
    return StreamBuilder(
        stream: surchargeFormBloc.preference!.stream,
        builder: (context, snapshot) {
          return FormField(
              onSaved: (bool? value) {
                surcharge.apply_tax2 = value!;
              },
              validator: null,
              initialValue: surcharge.apply_tax2,
              builder: (FormFieldState<bool> state) {
                return SwitchListTile(
                  activeColor: Colors.green,
                  title: Text(
                    surchargeFormBloc.preference != null ? surchargeFormBloc.preference!.value!.tax2Alias! : 'Tax 2',
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
        });
  }

  Widget tax3Field() {
    return StreamBuilder(
        stream: surchargeFormBloc.preference!.stream,
        builder: (context, snapshot) {
          return FormField(
              onSaved: (bool? value) {
                surcharge.apply_tax3 = value!;
              },
              validator: null,
              initialValue: surcharge.apply_tax3,
              builder: (FormFieldState<bool> state) {
                return SwitchListTile(
                  activeColor: Colors.green,
                  title: Text(
                    surchargeFormBloc.preference != null ? surchargeFormBloc.preference!.value!.tax3Alias! : 'Tax 3',
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
        });
  }
}
