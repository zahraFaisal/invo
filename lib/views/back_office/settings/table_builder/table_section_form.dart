import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_group_form/table_group_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_group_form/table_group_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_group_form/table_group_form_state.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class TableSectionForm extends StatefulWidget {
  final int id;
  TableSectionForm(this.id, {Key? key}) : super(key: key);

  @override
  _TableSectionFormState createState() => _TableSectionFormState();
}

class _TableSectionFormState extends State<TableSectionForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late DineInGroup group;
  late TableGroupFormBloc tableGroupFormBloc;
  @override
  void initState() {
    super.initState();

    tableGroupFormBloc = TableGroupFormBloc();
    tableGroupFormBloc.loadTableGroup(widget.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tableGroupFormBloc.dispose();
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    tableGroupFormBloc.nameValidation = "";
    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await tableGroupFormBloc.asyncValidate(group)) {
        tableGroupFormBloc.eventSink.add(SaveTableGroup(group));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          AppLocalizations.of(context)!.translate('Table Section'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.translate("Save"),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              save();
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: tableGroupFormBloc.group.stream,
          initialData: tableGroupFormBloc.group.value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (tableGroupFormBloc.group.value is TableGroupIsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (tableGroupFormBloc.group.value is TableGroupIsLoaded) {
              group = (tableGroupFormBloc.group.value as TableGroupIsLoaded).group;
              return Form(
                key: _formStateKey,
                child: ListView(
                  children: <Widget>[
                    nameField(),
                    priceLableField(),
                    actionsButtons(),
                  ],
                ),
              );
            }

            return const Center();
          },
        ),
      ),
    );
  }

  Widget nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            AppLocalizations.of(context)!.translate('Name'),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: TextFormField(
            onSaved: (value) {
              group.name = value!;
            },
            initialValue: group.name,
            validator: (String? value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context)!.translate('Please enter some text');
              } else if (tableGroupFormBloc.nameValidation != "") {
                return tableGroupFormBloc.nameValidation;
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget priceLableField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(
        AppLocalizations.of(context)!.translate('Apply this price'),
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        decoration: const ShapeDecoration(
          shape: const RoundedRectangleBorder(
            side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        child: DropdownButton<int>(
          value: group.price_id,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          hint: Text(AppLocalizations.of(context)!.translate("Select Price")),
          onChanged: (int? newValue) {
            setState(() {
              group.price_id = newValue!;
            });
          },
          style: const TextStyle(color: Colors.black),
          underline: Container(
            color: Colors.white,
          ),
          items: tableGroupFormBloc.labels.value!.map<DropdownMenuItem<int>>((PriceLabel value) {
            return DropdownMenuItem<int>(
              value: value.id,
              child: Text(value.name!),
            );
          }).toList(),
        ),
      ),
    ]);
  }

  Widget actionsButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
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
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              onPressed: () {
                cancel();
              },
            ),
          ),
        ),
        Container(
          width: 150,
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
                style: const TextStyle(fontSize: 24, color: Colors.white),
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
}
