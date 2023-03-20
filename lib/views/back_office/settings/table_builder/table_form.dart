import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_form/table_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_form/table_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_form/table_form_state.dart';
import 'package:invo_mobile/helpers/dineIn_image.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

class TableForm extends StatefulWidget {
  final int id;
  final int groupId;
  TableForm(this.id, this.groupId, {Key? key}) : super(key: key);
  @override
  _TableFormState createState() => _TableFormState();
}

class _TableFormState extends State<TableForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late DineInTable table;
  late TableFormBloc tableFormBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableFormBloc = TableFormBloc();
    tableFormBloc.loadTable(widget.id, groupId: widget.groupId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tableFormBloc.dispose();
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    tableFormBloc.nameValidation = "";
    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await tableFormBloc.asyncValidate(table)) {
        tableFormBloc.eventSink.add(SaveTable(table));
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
          AppLocalizations.of(context)!.translate('Table'),
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
          stream: tableFormBloc.table.stream,
          initialData: tableFormBloc.table.value,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (tableFormBloc.table.value is TableIsLoading) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            } else if (tableFormBloc.table.value is TableIsLoaded) {
              table = (tableFormBloc.table.value as TableIsLoaded).table;
              return Form(
                key: _formStateKey,
                child: ListView(
                  children: <Widget>[
                    nameField(),
                    tableImageField(),
                    surchargeField(),
                    minimumChargeField(),
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
        Text(
          AppLocalizations.of(context)!.translate('Name'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onSaved: (String? value) {
            table.name = value!;
          },
          initialValue: table.name,
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'Please enter some text';
            }
            //else if (tableGroupFormBloc.nameValidation != "") {
            //   return tableGroupFormBloc.nameValidation;
            // }
            return null;
          },
          decoration: const InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget surchargeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Surcharge'),
          textAlign: TextAlign.left,
          // ignore: prefer_const_constructors
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
              borderRadius: BorderRadius.all(const Radius.circular(5.0)),
            ),
          ),
          child: DropdownButton<int>(
            value: table.surcharge_id,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            hint: Text(AppLocalizations.of(context)!.translate("Select Surcharge")),
            isExpanded: true,
            onChanged: (int? newValue) {
              setState(() {
                table.surcharge_id = newValue!;
              });
            },
            style: const TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: tableFormBloc.surcharges.value!.map<DropdownMenuItem<int>>((SurchargeList value) {
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

  Widget minimumChargeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Minimum Charge'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onSaved: (value) {
            if (double.tryParse(value!) != null) {
              table.min_charge = double.parse(value);
            } else
              table.min_charge = 0;
          },
          initialValue: "${table.min_charge}",
          validator: (String? value) {
            return null;
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  var list = DineInImageSetup.getImages();

  Widget tableImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Image'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          decoration: const ShapeDecoration(
            shape: const RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: _getListItemTile,
          ),
        ),
      ],
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          for (var i = 0; list.length > i; i++) {
            list[i].isSelected = false;
          }
          list[index].isSelected = true;
          table.image_type = list[index].type!;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: list[index].isSelected! ? Colors.red[100] : Colors.white,
        child: Image.asset(list[index].image_green!),
      ),
    );
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
