import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Employee_form_page/employee_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Employee_form_page/employee_form_event.dart';
import 'package:invo_mobile/blocs/back_office/Employee/Employee_form_page/employee_form_state.dart';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';
import '../../image.dart';

class EmployeeFormPage extends StatefulWidget {
  final int? id;
  EmployeeFormPage({
    Key? key,
    this.id,
  }) : super(key: key);
  @override
  _EmployeeFormPageState createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  EmployeeFormPageBloc? employeeFormBloc;
  Employee? employee;
  String? dropdownValue;
  List<String>? genders = ['Male', 'Female'];
  String? dropdownValueRole;

  TabController? _tabController;
  void initState() {
    super.initState();
    employee = Employee();
    employeeFormBloc = EmployeeFormPageBloc(BlocProvider.of<NavigatorBloc>(context));
    loadData();
    _tabController = TabController(vsync: this, length: 2);
  }

  void loadData() async {
    if (widget.id != null) await employeeFormBloc?.loadEmployee(widget.id!);
  }

  @override
  void dispose() {
    super.dispose();
    employeeFormBloc?.dispose();
  }

  Orientation? orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          AppLocalizations.of(context)!.translate('Employee Form'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: Text(AppLocalizations.of(context)!.translate("Save"), style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                save();
              })
        ],
      ),
      body: StreamBuilder(
          stream: employeeFormBloc!.employee!.stream,
          initialData: employeeFormBloc!.employee!.value,
          builder: (BuildContext context, AsyncSnapshot<EmployeeLoadState> snapshot) {
            if (employeeFormBloc!.employee!.value is EmployeeIsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (employeeFormBloc!.employee!.value is EmployeeIsLoaded) employee = (employeeFormBloc!.employee!.value as EmployeeIsLoaded).employee;
            return Form(
              key: _formStateKey,
              child: Container(
                child: (orientation == Orientation.landscape) ? landscape() : portrait(),
              ),
            );
          }),
    );
  }

  Widget portrait() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          imageField(),
          nameField(),
          SizedBox(
            height: 10,
          ),
          nickNameField(),
          SizedBox(
            height: 10,
          ),
          passwordField(),
          SizedBox(
            height: 10,
          ),
          emailField(),
          SizedBox(
            height: 10,
          ),
          genderField(),
          SizedBox(
            height: 10,
          ),
          roleField(),
          SizedBox(
            height: 10,
          ),
          primaryAddressField(),
          SizedBox(
            height: 10,
          ),
          secondaryAddressField(),
          SizedBox(
            height: 10,
          ),
          primaryPhoneField(),
          SizedBox(
            height: 10,
          ),
          secondaryPhoneField(),
          SizedBox(
            height: 10,
          ),
          idNumberField(),
          SizedBox(
            height: 10,
          ),
          inActiveField(),
          SizedBox(
            height: 10,
          ),
          actionButtons(),
        ],
      ),
    );
  }

  Widget landscape() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            height: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: nameField(),
                      ),
                      Expanded(
                        child: passwordField(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: imageField(),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: nickNameField(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: genderField(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: primaryAddressField(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: secondaryAddressField(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: primaryPhoneField(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: secondaryPhoneField(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: roleField(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: emailField(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: idNumberField(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: inActiveField(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          actionButtons(),
        ],
      ),
    );
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await employeeFormBloc!.asyncValidate(employee!)) {
        employeeFormBloc!.eventSink!.add(SaveEmployee(employee!));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState?.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  Widget actionButtons() {
    return Container(
      color: Colors.grey[100],
      child: Row(
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
                  style: TextStyle(fontSize: 24, color: Colors.white),
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
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                onPressed: () {
                  save();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageField() {
    return Container(
        height: 300,
        child: Center(
            child: ImageGetter(
          validator: (String? value) {},
          onPick: (String) {},
        )));
  }

  Widget nameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      Text(
        AppLocalizations.of(context)!.translate('Name'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: (employee != null) ? employee?.name : "",
        onSaved: (value) {
          employee?.name = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter some text';
          } else if (employeeFormBloc?.nameValidation != "") {
            return employeeFormBloc?.nameValidation;
          }
          return null;
        },
        decoration: InputDecoration(labelText: 'Employee Name', border: OutlineInputBorder()),
      )
    ]);
  }

  Widget nickNameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        AppLocalizations.of(context)!.translate('Nick Name'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: (employee != null) ? employee?.nick_name : "",
        onSaved: (value) {
          employee?.nick_name = value;
        },
        decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget passwordField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        AppLocalizations.of(context)!.translate('Password'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        obscureText: true,
        initialValue: (employee != null) ? employee?.password : "",
        onSaved: (value) {
          employee!.password = value;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget genderField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        AppLocalizations.of(context)!.translate('Gender'),
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
        child: DropdownButton<String>(
          value: employee!.gender,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          hint: Text('Gender'),
          onChanged: (value) {
            setState(() {
              employee!.gender = value;
            });
          },
          style: TextStyle(color: Colors.black),
          underline: Container(
            color: Colors.white,
          ),
          items: genders?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    ]);
  }

  Widget roleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Role'),
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
            value: employee?.job_title_id_number,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text('select Role'),
            onChanged: (int? value) {
              employee!.job_title_id_number = value!;
              setState(() {});
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: employeeFormBloc?.roles!.map<DropdownMenuItem<int>>((RoleList value) {
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

  Widget birthdayField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('BirthDay'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onTap: () {
            DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2019, 3, 5), maxTime: DateTime(2020, 12, 12), onChanged: (date) {
              print('change $date');
            }, onConfirm: (date) {
              employee!.setBirthDate(date);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          decoration: InputDecoration(labelText: 'optional', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget idNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('IDNumber'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (employee != null) ? employee!.social_number : "",
          onSaved: (value) {
            employee!.social_number = value;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget mscCodeField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        AppLocalizations.of(context)!.translate('MSC Code'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: (employee != null) ? employee!.msc_code : "",
        onSaved: (value) {
          employee!.msc_code = value;
        },
        decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget inActiveField() {
    return FormField(
        onSaved: (bool? value) {
          employee!.in_active = value!;
        },
        validator: null,
        initialValue: employee!.in_active,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              AppLocalizations.of(context)!.translate('In Active'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: state.value!,
            onChanged: (bool value) => state.didChange(value),
          );
        });
  }

  Widget emailField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      Text(
        AppLocalizations.of(context)!.translate('Email'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: (employee != null) ? employee?.email : "",
        onSaved: (value) {
          employee?.email = value;
        },
        decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget primaryAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Primary Adress'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (employee != null) ? employee?.address1 : "",
          onSaved: (value) {
            employee?.address1 = value;
          },
          decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget secondaryAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Secondary Adress'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (employee != null) ? employee?.address2 : "",
          onSaved: (value) {
            employee?.address2 = value;
          },
          decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget primaryPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Primary phone'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (employee != null) ? employee?.phone1 : "",
          onSaved: (value) {
            employee?.phone1 = value;
          },
          decoration: InputDecoration(labelText: 'phone', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget secondaryPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Secondary phone'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (employee != null) ? employee?.phone2 : "",
          onSaved: (value) {
            employee?.phone2 = value;
          },
          decoration: InputDecoration(labelText: 'phone', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget dateHierdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Date Hired'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onTap: () {
            DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2019, 1, 1), maxTime: DateTime(2020, 12, 30), onConfirm: (date) {
              employee?.setDateHired(date);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget dateReleasedField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Date Released'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onTap: () {
            DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime(2019, 1, 1), maxTime: DateTime(2020, 12, 30), onConfirm: (date) {
              employee?.setDateReleased(date);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
