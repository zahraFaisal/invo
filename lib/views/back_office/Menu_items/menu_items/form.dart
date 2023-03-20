import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuitemForm/Menu_item_Form_event.dart';

import 'package:invo_mobile/blocs/back_office/Menu/menuitemForm/Menu_item_form_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuitemForm/Menu_item_state.dart';

import 'package:invo_mobile/blocs/back_office/Menu/modifierList/menu_modifier_list_bloc.dart';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/custom/menu_modifier_list.dart';

import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/views/back_office/Menu_items/menu_modifier/form.dart';
import 'package:invo_mobile/views/back_office/color_picker.dart';

import 'package:invo_mobile/views/back_office/image.dart';
import 'package:invo_mobile/widgets/pickers/pick_Modifier.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../../service_locator.dart';
import '../../../blocProvider.dart';
import 'dart:convert';

class MenuItemForm extends StatefulWidget {
  final int id;
  final bool isCopy;
  MenuItemForm({Key? key, this.id = 0, this.isCopy = false}) : super(key: key);

  @override
  _MenuItemFormState createState() => _MenuItemFormState();
}

class _MenuItemFormState extends State<MenuItemForm> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late MenuItemBloc itemBloc;

  late MenuModifierListBloc menuModifierListBloc;
  MenuItemList? quickModifierDropdownValue;
  MenuItemList? popupModifierDropdownValue;
  String? dropdownCategoryValue;
  String? dropdownRepeatValue;

  bool firstpress = true;
  late MenuModifier modifier;

  List<DropdownMenuItem<int>> types = List<DropdownMenuItem<int>>.empty(growable: true);

  late mi.MenuItem item;
  late TabController _tabController;

  int tabIndex = 0;
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);

    itemBloc = MenuItemBloc(BlocProvider.of<NavigatorBloc>(context));
    itemBloc.loadMenuItem(widget.id, isCopy: widget.isCopy);

    types.add(DropdownMenuItem(
      value: 1,
      child: Text("Normal"),
    ));
    types.add(DropdownMenuItem(
      value: 2,
      child: Text("Combo Items"),
    ));
    types.add(DropdownMenuItem(
      value: 3,
      child: Text("Menu Selection"),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    itemBloc.dispose();
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await itemBloc.asyncValidate(item)) {
        mi.MenuItem temp = await itemBloc.saveMenuItem(item);
        Navigator.of(context).pop(temp);
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop(null);
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          AppLocalizations.of(context)!.translate('Menu Items'),
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
          stream: itemBloc.item.stream,
          initialData: itemBloc.item.value,
          builder: (BuildContext context, AsyncSnapshot<MenuItemLoadState> snapshot) {
            if (itemBloc.item.value is MenuItemIsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (itemBloc.item.value is MenuItemIsLoaded) item = (itemBloc.item.value as MenuItemIsLoaded).item;
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
                              AppLocalizations.of(context)!.translate('Option'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('Prices'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('Quick Modifier'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('Popup Modifier'),
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
                      optionTab(),
                      pricesTab(),
                      quickModifierTab(),
                      popupModeTab(),
                    ]),
                  ),
                ]),
              ),
            );
          }),
    );
  }

  Widget actionsButtons() {
    return Container(
      color: Colors.grey[100],
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
      ),
    );
  }

  Widget generalTab() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: orientation == Orientation.portrait
            ? ListView(
                children: <Widget>[
                  imageField(),
                  colorField(),
                  nameField(),
                  secondaryNameField(),
                  barcodeField(),
                  // typeField(),
                  categoryField(),
                  defaultPriceField(),
                  preperationTimeField(),
                  weightUnitField(),
                  countDownField(),
                  descriptionField(),
                  secondaryDescriptionField(),
                  applyTax1Field(),
                  applyTax2Field(),
                  applyTax3Field(),
                  actionsButtons()
                ],
              )
            : ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              nameField(),
                              SizedBox(
                                height: 10,
                              ),
                              secondaryNameField(),
                              SizedBox(
                                height: 10,
                              ),
                              barcodeField(),
                              SizedBox(
                                height: 10,
                              ),
                              defaultPriceField(),
                              SizedBox(
                                height: 10,
                              ),
                              categoryField(),
                              SizedBox(
                                height: 10,
                              ),
                              preperationTimeField(),
                              SizedBox(
                                height: 10,
                              ),
                              descriptionField(),
                              SizedBox(
                                height: 10,
                              ),
                              secondaryDescriptionField()
                            ],
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          imageField(),
                          colorField(),
                          SizedBox(
                            height: 10,
                          ),
                          countDownField(),
                          SizedBox(
                            height: 10,
                          ),
                          weightUnitField(),
                          SizedBox(
                            height: 10,
                          ),
                          applyTax1Field(),
                          SizedBox(
                            height: 10,
                          ),
                          applyTax2Field(),
                          SizedBox(
                            height: 10,
                          ),
                          applyTax3Field(),
                        ],
                      )),
                    ],
                  ),
                  actionsButtons()
                ],
              ),
      ),
    );
  }

  Widget optionTab() {
    if (orientation == Orientation.portrait) {
      return Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.grey[100],
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.translate("Nutrations"),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            kcalField(),
            fatField(),
            carbField(),
            protienField(),
            Container(
              height: 50,
              color: Colors.grey[100],
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.translate("Options"),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            openPriceField(),
            availableField(),
            seasonalPriceField(),
            discountableField(),
            inActiveField()
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: Colors.grey[100],
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate("Nutrations"),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    kcalField(),
                    fatField(),
                    carbField(),
                    protienField(),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: Colors.grey[100],
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate("Options"),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    openPriceField(),
                    availableField(),
                    seasonalPriceField(),
                    discountableField(),
                    inActiveField()
                  ],
                ),
              ),
            ]),
          ],
        ),
      );
    }
  }

  Widget pricesTab() {
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppLocalizations.of(context)!.translate('Label'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        AppLocalizations.of(context)!.translate('Price'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 4),
                child: ListView.builder(
                    itemCount: item.prices!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                          height: 70,
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2)),
                          child: InkWell(
                            onTap: () {},
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  item.prices![index].label!.name!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      width: 100,
                                      child: TextFormField(
                                        controller: TextEditingController(text: item.prices![index].priceTxt),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (s) {
                                          item.prices![index].priceTxt = s;
                                        },
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.cancel, size: 40),
                                      onPressed: () {
                                        itemBloc.deletePrice(item.prices![index]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ));
  }

  Widget popupModeTab() {
    return Container(
        color: Colors.white,
        child: ListView(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 20, left: 10),
                height: 60,
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('Copy from'),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.translate('*Copy popup modifier list from \n another item*'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton<MenuItemList>(
                    value: popupModifierDropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    hint: Text(AppLocalizations.of(context)!.translate('Select item')),
                    onChanged: (MenuItemList? newValue) {
                      setState(() {
                        popupModifierDropdownValue = newValue!;
                        // itemBloc.copyQuickModifiers(newValue.id);
                      });
                    },
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      color: Colors.white,
                    ),
                    items: itemBloc.items.value != null
                        ? itemBloc.items.value!.map<DropdownMenuItem<MenuItemList>>((MenuItemList value) {
                            return DropdownMenuItem<MenuItemList>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList()
                        : [],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  height: 80,
                  child: ListView.builder(
                      itemCount: item.popup_mod!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                itemBloc.changeLevel(item.popup_mod![index]);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, top: 10, bottom: 0),
                                decoration: BoxDecoration(
                                  color: item.popup_mod![index] == itemBloc.currentPopUpLevel.value ? Colors.white : Colors.grey[350],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  border: Border.all(width: 0, color: Colors.white),
                                ),
                                width: 100,
                                height: 80,
                                child: Center(
                                  child: Text('level ' + item.popup_mod![index].level.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
              StreamBuilder(
                stream: itemBloc.currentPopUpLevel.stream,
                initialData: itemBloc.currentPopUpLevel.value,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (itemBloc.currentPopUpLevel.value == null)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  List<Widget> widgets = List<Widget>.empty(growable: true);
                  for (var item in itemBloc.currentPopUpLevel.value!.modifiers.where((element) => element.Is_Deleted == false)) {
                    widgets.add(Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                        ),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(item.modifier!.name, style: TextStyle(color: Colors.black, fontSize: 20)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, size: 30),
                              color: Colors.grey,
                              onPressed: () {
                                itemBloc.deletePopUpModifier(item);
                              },
                            )
                          ],
                        )));
                  }

                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 0, color: Colors.white), left: BorderSide(width: 0, color: Colors.black), right: BorderSide(width: 0, color: Colors.black), bottom: BorderSide(width: 0, color: Colors.black))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          AppLocalizations.of(context)!.translate('Repeat'),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        child: DropdownButton<int>(
                                          value: itemBloc.currentPopUpLevel.value!.repeat,
                                          icon: Icon(Icons.arrow_downward),
                                          iconSize: 24,
                                          elevation: 16,
                                          isExpanded: true,
                                          hint: Text(AppLocalizations.of(context)!.translate('None')),
                                          onChanged: (int? newValue) {
                                            setState(() {
                                              itemBloc.currentPopUpLevel.value!.repeat = newValue!;
                                            });
                                          },
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                            color: Colors.white,
                                          ),
                                          items: <int>[
                                            1,
                                            2,
                                            3,
                                            4,
                                            5,
                                            6,
                                            7,
                                            8,
                                            9,
                                            10,
                                          ].map<DropdownMenuItem<int>>((int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(
                                                value.toString(),
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)!.translate('Force'),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      onChanged: (value) {
                                        setState(() {
                                          itemBloc.currentPopUpLevel.value!.is_forced = value;
                                        });
                                      },
                                      value: itemBloc.currentPopUpLevel.value!.is_forced == null ? false : itemBloc.currentPopUpLevel.value!.is_forced,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Local',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      onChanged: (value) {
                                        setState(() {
                                          itemBloc.currentPopUpLevel.value!.local = value;
                                        });
                                      },
                                      value: itemBloc.currentPopUpLevel.value!.local == null ? false : itemBloc.currentPopUpLevel.value!.local,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Online',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      onChanged: (value) {
                                        setState(() {
                                          itemBloc.currentPopUpLevel.value!.online = value;
                                        });
                                      },
                                      value: itemBloc.currentPopUpLevel.value!.online == null ? false : itemBloc.currentPopUpLevel.value!.online,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Text(
                            AppLocalizations.of(context)!.translate('Description(primary)'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: TextFormField(
                            controller: TextEditingController(text: itemBloc.currentPopUpLevel.value!.description),
                            onChanged: (String newDesc) {
                              itemBloc.currentPopUpLevel.value!.description = newDesc;
                            },
                            decoration: InputDecoration(labelText: 'Description(primary)', border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Text(
                            AppLocalizations.of(context)!.translate('Description(secondary)'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: TextFormField(
                            controller: TextEditingController(text: itemBloc.currentPopUpLevel.value!.secondary_description),
                            onChanged: (String newDesc) {
                              itemBloc.currentPopUpLevel.value!.secondary_description = newDesc;
                            },
                            decoration: InputDecoration(labelText: 'Description(secondary)', border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.translate('Name'),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Expanded(
                                child: addPopUpModifierBtn(),
                              ),
                              Expanded(
                                child: pickPopUpModifierBtn(),
                              ),
                            ],
                          ),
                        ),
                        widgets.length > 0
                            ? Container(
                                child: Container(color: Colors.grey[100], child: Column(children: widgets)),
                              )
                            : Container(
                                height: 500,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)!.translate("Please click here to add new modifier to popup modifier list"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 20, bottom: 20),
                                              width: 180,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.blueGrey[900],
                                              ),
                                              child: addPopUpModifierBtn(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!.translate("Or click here to pick an existing modifier"),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Container(
                                            width: 180,
                                            margin: EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.blueGrey[900],
                                            ),
                                            child: pickPopUpModifierBtn(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ]));
  }

  Widget addPopUpModifierBtn() {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Text(
            AppLocalizations.of(context)!.translate("Add modifier"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: () async {
        MenuModifier? temp = await showDialog<MenuModifier>(
          context: context,
          builder: (BuildContext context) {
            return MenuModifierForm();
          },
        );

        if (temp != null) {
          itemBloc.addNewPopUpModifiers(temp);
        }
      },
    );
  }

  Widget pickPopUpModifierBtn() {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.arrow_drop_down,
            size: 10,
            color: Colors.white,
          ),
          Text(
            AppLocalizations.of(context)!.translate("Pick modifier"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: () async {
        List<ModifierList>? temp = await showDialog<List<ModifierList>>(
          context: context,
          builder: (BuildContext context) {
            return PickModifier();
          },
        );

        itemBloc.addPopUpModifiers(temp!);
      },
    );
  }

  Widget quickModifierTab() {
    return SizedBox(
      height: 300,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate('Copy from'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.translate('*Copy quick modifier list \n from another item*'),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: DropdownButton<MenuItemList>(
                  value: quickModifierDropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!.translate('Select item')),
                  onChanged: (MenuItemList? newValue) {
                    setState(() {
                      quickModifierDropdownValue = newValue!;
                      itemBloc.copyQuickModifiers(newValue.id);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    color: Colors.white,
                  ),
                  items: itemBloc.items.value != null
                      ? itemBloc.items.value!.map<DropdownMenuItem<MenuItemList>>((MenuItemList value) {
                          return DropdownMenuItem<MenuItemList>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList()
                      : [],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 0),
              padding: const EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate('Name'),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Expanded(
                    child: addQuickModifierBtn(),
                  ),
                  Expanded(
                    child: pickQuickModifierBtn(),
                  ),
                ],
              ),
            ),
            Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              child: item.quick_mod!.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: item.quick_mod!.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2),
                            ),
                            height: 55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(item.quick_mod![index].modifier!.name, style: TextStyle(color: Colors.black, fontSize: 20)),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.grey,
                                  onPressed: () {
                                    itemBloc.deleteQuickModifier(item.quick_mod![index]);
                                  },
                                )
                              ],
                            ));
                      })
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 500,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)!.translate("Please click here to add new modifier to quick modifier list"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 20,
                                  ),
                                  width: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueGrey[900],
                                  ),
                                  child: addQuickModifierBtn(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.translate("Or click here to pick an existing modifier"),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Container(
                                width: 180,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blueGrey[900],
                                ),
                                child: pickQuickModifierBtn(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addQuickModifierBtn() {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add,
            size: 10,
            color: Colors.white,
          ),
          Text(
            AppLocalizations.of(context)!.translate("Add modifier"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: () async {
        MenuModifier? temp = await showDialog<MenuModifier>(
          context: context,
          builder: (BuildContext context) {
            return MenuModifierForm();
          },
        );

        if (temp != null) {
          itemBloc.addNewQuickModifiers(temp);
        }
      },
    );
  }

  Widget pickQuickModifierBtn() {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: Colors.white,
          ),
          Text(
            AppLocalizations.of(context)!.translate("Pick modifier"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: () async {
        List<ModifierList>? temp = await showDialog<List<ModifierList>>(
          context: context,
          builder: (BuildContext context) {
            return PickModifier();
          },
        );

        itemBloc.addQuickModifiers(temp!);
      },
    );
  }

  Widget imageField() {
    return Center(
        child: ImageGetter(
      initValue: item.imageByte,
      onPick: (String base64Image) {
        item.icon = base64Image;
      },
      validator: (String? value) {},
    ));
  }

  Widget colorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Color'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        ColorPicker(
          initColor: item.color.toString(),
          onChange: (color) {
            item.default_forecolor = color;
          },
        ),
      ],
    );
  }

  Widget nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Name(primary)'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (item != null) ? item.name : "",
          onChanged: (value) {
            setState(() {
              item.name = value;
            });
          },
          validator: (String? value) {
            if (value!.isEmpty) {
              return 'Please enter some text';
            } else if (itemBloc.nameValidation != "") {
              return itemBloc.nameValidation;
            }
            return null;
          },
          decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget secondaryNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Name(secondary)'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (item != null) ? item.secondary_name : "",
          onChanged: (value) {
            setState(() {
              item.secondary_name = value;
            });
          },
          decoration: InputDecoration(labelText: 'Required', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget barcodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Barcode'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (item != null) ? item.barcode : "",
          onChanged: (value) {
            setState(() {
              item.barcode = value;
            });
          },
          validator: (String? value) {
            if (itemBloc.barcodeValidation != "") {
              return itemBloc.barcodeValidation;
            }
            return null;
          },
          decoration: InputDecoration(labelText: 'BarCode', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget typeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            value: item.type,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate('Select Type')),
            onChanged: (int? value) {
              setState(() {
                item.type = value;
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

  Widget categoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Menu Category'),
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
            value: itemBloc.menuCategoryId,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.translate('Select Category')),
            onChanged: (int? newValue) {
              setState(() {
                item.menu_category_id = newValue;
              });
            },
            style: TextStyle(color: Colors.black),
            underline: Container(
              color: Colors.white,
            ),
            items: itemBloc.categories.value!.map<DropdownMenuItem<int>>((MenuCategoryList value) {
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

  Widget defaultPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Default Price'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: item.default_price.toString(),
          onChanged: (value) {
            item.default_price = value != "" ? double.parse(value) : 0;
          },
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget receiptNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Receipt Name'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: item.receipt_text,
          onChanged: (value) {
            item.receipt_text = value;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget preperationTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Preperation Time'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: item.preperation_time.toString(),
          onChanged: (value) {
            int temp = int.parse(value);
            item.preperation_time = temp;
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget weightUnitField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('Order by weight'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              onChanged: (value) {
                setState(() {
                  item.order_By_Weight = value;
                });
              },
              value: item.order_By_Weight!,
            ),
          ],
        ),
        TextFormField(
          initialValue: item.weight_unit,
          onSaved: (value) {
            item.weight_unit = value;
          },
          enabled: item.order_By_Weight,
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget countDownField() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('Count Down'),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: item.enable_count_down!,
              onChanged: (value) {
                setState(() {
                  item.enable_count_down = value;
                });
              },
            ),
          ],
        ),
        TextFormField(
          initialValue: item.countDown.toString(),
          onSaved: (value) {
            item.countDown = int.parse(value!);
          },
          enabled: item.enable_count_down,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'optional', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Description(primary)'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          maxLines: 9,
          initialValue: item.description,
          onChanged: (value) {
            item.description = value;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget secondaryDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Description(secondary)'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          maxLines: 9,
          initialValue: item.secondary_description,
          onChanged: (value) {
            item.secondary_description = value;
          },
          decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget applyTax1Field() {
    return FormField(
        onSaved: (bool? value) {
          item.apply_tax1 = value!;
        },
        validator: null,
        initialValue: item.apply_tax1,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              'Apply ${itemBloc.preference!.tax1Alias}',
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

  Widget applyTax2Field() {
    return FormField(
        onSaved: (bool? value) {
          item.apply_tax2 = value!;
        },
        validator: null,
        initialValue: item.apply_tax2 == null ? false : item.apply_tax2,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              'Apply ${itemBloc.preference!.tax2Alias}',
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

  Widget applyTax3Field() {
    return FormField(
        onSaved: (bool? value) {
          item.apply_tax3 = value!;
        },
        validator: null,
        initialValue: item.apply_tax3 == null ? false : item.apply_tax3,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              'Apply ${itemBloc.preference!.tax3Alias}',
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

  Widget openPriceField() {
    return FormField(
        onSaved: (bool? value) {
          item.open_price = value!;
        },
        validator: null,
        initialValue: item.open_price,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              AppLocalizations.of(context)!.translate('Open price'),
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

  Widget availableField() {
    return FormField(
        onSaved: (bool? value) {
          item.in_stock = value;
        },
        validator: null,
        initialValue: item.in_stock,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              AppLocalizations.of(context)!.translate('Available'),
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

  Widget seasonalPriceField() {
    return FormField(
        onSaved: (bool? value) {
          item.seasonale_price = value;
        },
        validator: null,
        initialValue: item.seasonale_price,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              AppLocalizations.of(context)!.translate('Seasonal price'),
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

  Widget discountableField() {
    return FormField(
        onSaved: (bool? value) {
          item.discountable = value!;
        },
        validator: null,
        initialValue: item.discountable,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              AppLocalizations.of(context)!.translate('Discountable'),
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

  Widget inActiveField() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FormField(
            onSaved: (bool? value) {
              item.in_active = value;
            },
            validator: null,
            initialValue: item.in_active,
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
            }));
  }

  Widget kcalField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Total Kcal'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextFormField(
            onSaved: (String? value) {
              item.calories = double.tryParse(value!)!;
            },
            initialValue: '0',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget carbField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Total Carb'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextFormField(
            onSaved: (String? value) {
              item.carb = double.tryParse(value!)!;
            },
            initialValue: '0',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget fatField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Total Fat'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextFormField(
            onSaved: (String? value) {
              item.fat = double.tryParse(value!)!;
            },
            initialValue: '0',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget protienField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Total Protien'),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextFormField(
            onSaved: (String? value) {
              item.protein = double.tryParse(value!)!;
            },
            initialValue: '0',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: '', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}
