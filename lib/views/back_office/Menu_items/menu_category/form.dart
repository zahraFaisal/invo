import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/categoryForm/menu_category_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/categoryForm/menu_category_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/categoryForm/menu_category_state.dart';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';

import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/widgets/pickers/pick_menu_item.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../blocProvider.dart';

class MenuCategoryForm extends StatefulWidget {
  final int id;
  final bool isCopy;
  MenuCategoryForm({Key? key, this.id = 0, this.isCopy = false}) : super(key: key);
  @override
  _MenuCategoryFormState createState() => _MenuCategoryFormState();
}

class _MenuCategoryFormState extends State<MenuCategoryForm> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late MenuCategory category;
  late mi.MenuItem item;
  late MenuCategoryFormBloc menuCategoryFormBloc;

  @override
  void initState() {
    super.initState();

    menuCategoryFormBloc = MenuCategoryFormBloc(BlocProvider.of<NavigatorBloc>(context));
    menuCategoryFormBloc.loadCategory(widget.id, isCopy: widget.isCopy);
  }

  @override
  void dispose() {
    super.dispose();
    menuCategoryFormBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: menuCategoryFormBloc.menuCategory!.stream,
            builder: (BuildContext context, AsyncSnapshot<MenuCategoryLoadState> snapshot) {
              if (menuCategoryFormBloc.menuCategory!.value is MenuCategoryIsLoading) {
                return const Center(child: const CircularProgressIndicator());
              } else if (menuCategoryFormBloc.menuCategory!.value is MenuCategoryIsLoaded) category = (menuCategoryFormBloc.menuCategory!.value as MenuCategoryIsLoaded).menuCategory;

              return Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              cancel();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.translate("Menu Category"),
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          InkWell(
                              child: Text(AppLocalizations.of(context)!.translate("Save"), style: const TextStyle(color: Colors.white, fontSize: 20)),
                              onTap: () {
                                save();
                              })
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _formStateKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          children: <Widget>[
                            nameFeild(),
                            inActiveField(),
                            menuItemList(),
                            actionsButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await menuCategoryFormBloc.asyncValidate(category)) {
        menuCategoryFormBloc.eventSink!.add(SaveMenuCategory(category));
        Navigator.of(context).pop();
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  Widget nameFeild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.translate('Name'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          initialValue: (category != null) ? category.name : "",
          onChanged: (value) {
            setState(() {
              category.name = value;
            });
          },
          onSaved: (value) {
            setState(() {
              category.name = value!;
            });
          },
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.translate('Please enter some text');
            } else if (menuCategoryFormBloc.nameValidation != "") {
              return menuCategoryFormBloc.nameValidation;
            }
            return null;
          },
          decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget inActiveField() {
    return FormField(
        onSaved: (bool? value) {
          category.in_active = value!;
        },
        validator: null,
        initialValue: category.in_active,
        builder: (FormFieldState<bool> state) {
          return SwitchListTile(
            activeColor: Colors.green,
            title: Text(
              AppLocalizations.of(context)!.translate('In Active'),
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: state.value!,
            onChanged: (bool value) => state.didChange(value),
          );
        });
  }

  Widget menuItemList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            color: Colors.blueGrey[900],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      AppLocalizations.of(context)!.translate('Item'),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey[900],
                    ),
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: AppLocalizations.of(context)!.translate('Add Menu Item'),
                      color: Colors.white,
                      onPressed: () async {
                        List<MenuItemList> temp = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PickMenuItem();
                          },
                        );
                        menuCategoryFormBloc.addMenuItem(temp);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: menuCategoryFormBloc.items!.stream,
            initialData: menuCategoryFormBloc.items!.value,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Widget> widgets = List<Widget>.empty(growable: true);

              if (menuCategoryFormBloc.items!.value != null)
                // ignore: curly_braces_in_flow_control_structures
                for (var item in menuCategoryFormBloc.items!.value!) {
                  widgets.add(Container(
                      padding: const EdgeInsets.only(left: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5),
                      ),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(item.name, style: const TextStyle(color: Colors.black, fontSize: 20)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, size: 30),
                            color: Colors.grey,
                            onPressed: () {
                              menuCategoryFormBloc.deleteMenuItems(item);
                            },
                          )
                        ],
                      )));
                }
              return Container(
                child: Container(constraints: const BoxConstraints(minHeight: 100), color: Colors.white, child: Column(children: widgets)),
              );
            },
          ),
        ],
      ),
    );
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
