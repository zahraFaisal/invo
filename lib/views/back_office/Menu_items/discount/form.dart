import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:invo_mobile/blocs/back_office/Menu/DiscountForm/discount_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/DiscountForm/discount_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/DiscountForm/discount_state.dart';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/discount.dart';
import 'package:invo_mobile/models/menu_item.dart';

import 'package:invo_mobile/views/back_office/pick_role.dart';
import 'package:invo_mobile/widgets/check_box.dart';
import 'package:invo_mobile/widgets/pickers/pick_menu_item.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class DiscountForm extends StatefulWidget {
  final int id;
  final bool isCopy;
  DiscountForm({Key? key, this.id = 0, this.isCopy = false}) : super(key: key);

  @override
  _DiscountFormState createState() => _DiscountFormState();
}

class DiacountType {
  String name;
  bool value;
  DiacountType(this.name, this.value);
}

class _DiscountFormState extends State<DiscountForm> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late DiscountFormBloc discountFormBloc;
  late String dropdownValue;
  late Discount discount;
  late bool startDateisSwitched = false;
  late bool expireDateisSwitched = false;
  var today = DateTime.now();

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    discountFormBloc = DiscountFormBloc(BlocProvider.of<NavigatorBloc>(context));
    discountFormBloc.loadDiscount(widget.id, isCopy: widget.isCopy);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    discountFormBloc.dispose();
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          AppLocalizations.of(context)!.translate('Discounts'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.translate("Save"),
              style: TextStyle(
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
      body: StreamBuilder(
          stream: discountFormBloc.discount.stream,
          initialData: DiscountIsLoading(),
          builder: (BuildContext context, AsyncSnapshot<DiscountLoadState> snapshot) {
            if (discountFormBloc.discount.value is DiscountIsLoaded) {
              discount = (discountFormBloc.discount.value as DiscountIsLoaded).discount;
              return Form(
                key: _formStateKey,
                child: Container(
                  color: Colors.blueGrey[900],
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 0, 0),
                      child: TabBar(
                        onTap: (index) {
                          _formStateKey.currentState!.save();
                        },
                        indicatorSize: TabBarIndicatorSize.tab,
                        isScrollable: true,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.white,
                        labelStyle: TextStyle(fontSize: 26),
                        controller: _tabController,
                        tabs: <Widget>[
                          Container(
                            width: 120,
                            height: 80,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.translate('General'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.translate('Discount Item'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.translate('Role'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: <Widget>[
                        generalTab(),
                        discountTab(),
                        roleTab(),
                      ]),
                    ),
                  ]),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await discountFormBloc.asyncValidate(discount)) {
        discountFormBloc.eventSink.add(SaveDiscount(discount));
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
                  style: TextStyle(fontSize: 20, color: Colors.white),
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

  Widget generalTab() {
    return Container(
      color: Colors.white,
      child: StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: orientation == Orientation.portrait
              ? ListView(
                  itemExtent: 115,
                  children: <Widget>[
                    nameField(),
                    typeField(),
                    amountField(),
                    startDateField(),
                    expireDateField(),
                    minPriceField(),
                    descriptionField(),
                    inActiveField(),
                    actionsButtons(),
                  ],
                )
              : ListView(
                  itemExtent: 115,
                  children: <Widget>[
                    Row(children: [
                      Expanded(
                        child: nameField(),
                      ),
                      Container(
                        width: 250,
                        child: inActiveField(),
                      )
                    ]),
                    Row(children: [
                      Expanded(
                        child: typeField(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: amountField(),
                      )
                    ]),
                    Row(children: [
                      Expanded(
                        child: startDateField(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: expireDateField(),
                      )
                    ]),
                    Row(children: [
                      Expanded(
                        child: minPriceField(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: descriptionField(),
                      )
                    ]),
                    actionsButtons(),
                  ],
                ),
        );
      }),
    );
  }

  Widget nameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      Text(
        AppLocalizations.of(context)!.translate('Name'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: (discount != null) ? discount.name : "",
        onChanged: (value) {
          setState(() {
            discount.name = value;
          });
        },
        onSaved: (value) {
          setState(() {
            discount.name = value!;
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.translate("Please enter some text");
          } else if (discountFormBloc.nameValidation != "") {
            return discountFormBloc.nameValidation;
          }
          return null;
        },
        decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
      )
    ]);
  }

  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Description'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          onChanged: (value) {
            setState(() {
              discount.description = value;
            });
          },
          onSaved: (value) {
            setState(() {
              discount.description = value;
            });
          },
          decoration: InputDecoration(labelText: 'optional', border: OutlineInputBorder()),
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
            isSelected: !discount.is_percentage,
            onTap: () {
              setState(() {
                discount.is_percentage = false;
              });
            },
          ),
        ),
        Expanded(
          child: CheckBox(
            AppLocalizations.of(context)!.translate("Percentage"),
            isSelected: discount.is_percentage,
            onTap: () {
              setState(() {
                discount.is_percentage = true;
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
              initialValue: discount.amount.toString(),
              onSaved: (value) {
                setState(() {
                  discount.amount = double.parse(value!);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'This Field is Required', border: OutlineInputBorder()),
            ),
          ),
          discount.is_percentage
              ? Container(
                  width: 40,
                  child: Text(
                    "%",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                )
              : Center(),
        ],
      ),
    ]);
  }

  Widget startDateField() {
    if (discount.start_date != null) startDateisSwitched = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.translate('Start Date'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: startDateisSwitched == null ? false : startDateisSwitched,
              onChanged: (value) {
                setState(() {
                  startDateisSwitched = value;
                  if (value == false) discount.start_date = null;
                });
              },
              activeTrackColor: Colors.lightGreen,
              activeColor: Colors.green,
            ),
          ],
        ),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: discount.start_date == null ? "" : discount.start_date.toString()),
          onTap: () async {
            var _date = await DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime.now(), maxTime: DateTime(today.year + 1, today.month, today.day), onConfirm: (date) {
              discount.setStartDate(date);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
            setState(() {
              discount.start_date = _date;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'start date',
          ),
        ),
      ],
    );
  }

  Widget expireDateField() {
    if (discount.end_date != null) expireDateisSwitched = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.translate('Expire Date'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: expireDateisSwitched == null ? false : expireDateisSwitched,
              onChanged: (value) {
                setState(() {
                  expireDateisSwitched = value;
                  if (value == false) discount.end_date = null;
                });
              },
              activeTrackColor: Colors.lightGreen,
              activeColor: Colors.green,
            ),
          ],
        ),
        TextFormField(
          enabled: expireDateisSwitched,
          controller: TextEditingController(text: discount.end_date == null ? "" : discount.end_date.toString()),
          readOnly: true,
          onTap: () async {
            await DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime.now(), maxTime: DateTime(today.year + 1, today.month, today.day), onChanged: (date) {}, onConfirm: (date) {
              discount.setEndDate(date);
              setState(() {
                discount.end_date = date;
              });
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'expire date',
          ),
        ),
      ],
    );
  }

  Widget minPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            AppLocalizations.of(context)!.translate('Min Price'),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          initialValue: discount.min_price.toString(),
          onChanged: (value) {
            setState(() {
              discount.min_price = double.parse(value);
            });
          },
          onSaved: (value) {
            setState(() {
              discount.min_price = double.parse(value!);
            });
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget inActiveField() {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FormField(
            onSaved: (bool? value) {
              discount.in_active = value!;
            },
            validator: null,
            initialValue: discount.in_active,
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
            }));
  }

  Widget discountTab() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Text(
                          AppLocalizations.of(context)!.translate('Menu Item'),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[900],
                      ),
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        tooltip: AppLocalizations.of(context)!.translate('New'),
                        color: Colors.white,
                        onPressed: () async {
                          List<MenuItemList> temp = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PickMenuItem();
                            },
                          );
                          discountFormBloc.addDicountItem(temp);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[900],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        tooltip: AppLocalizations.of(context)!.translate('Remove ALL'),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: discount == null ? 0 : discount.activeItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2)),
                      child: ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.cancel, size: 40),
                          tooltip: AppLocalizations.of(context)!.translate('Remove'),
                          onPressed: () {
                            discountFormBloc.deleteDiscountItem(discount.activeItems[index]);
                          },
                        ),
                        onTap: () {},
                        title: Text(
                          discount.activeItems[index].item!.name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget roleTab() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Text(
                          AppLocalizations.of(context)!.translate('Role'),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[900],
                      ),
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(Icons.add),
                        tooltip: AppLocalizations.of(context)!.translate('Add New'),
                        color: Colors.white,
                        onPressed: () async {
                          List<RoleList> temp = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PickRole();
                            },
                          );
                          discountFormBloc.addRole(temp);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[900],
                      ),
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        tooltip: AppLocalizations.of(context)!.translate('Remove ALL'),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: discount.Roles!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2)),
                      child: ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.cancel, size: 40),
                          tooltip: AppLocalizations.of(context)!.translate('Remove'),
                          onPressed: () {
                            discountFormBloc.deleteRole(discount.Roles![index]);
                          },
                        ),
                        onTap: () {},
                        title: Text(
                          discount.Roles![index].name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
