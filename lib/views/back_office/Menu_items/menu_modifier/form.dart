import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/back_office/Menu/modifierForm/Modifier_Form_page_bloc.dart';
import 'package:invo_mobile/blocs/back_office/Menu/modifierForm/Modifier_Form_state.dart';
import 'package:invo_mobile/blocs/back_office/Menu/modifierForm/Modifier_form_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/menu_item.dart' as mi;
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../../../../service_locator.dart';
import '../../../blocProvider.dart';

class MenuModifierForm extends StatefulWidget {
  final int id;
  final bool isCopy;
  MenuModifierForm({Key? key, this.id = 0, this.isCopy = false}) : super(key: key);

  @override
  _MenuModifierFormState createState() => _MenuModifierFormState();
}

class _MenuModifierFormState extends State<MenuModifierForm> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  late TabController _tabController;
  late ModifierFormPageBloc modifierFormBloc;
  late MenuModifier modifier;
  late mi.MenuItem item;

  void initState() {
    super.initState();
    modifier = new MenuModifier();
    modifierFormBloc = ModifierFormPageBloc(BlocProvider.of<NavigatorBloc>(context));
    loadData();
    _tabController = TabController(vsync: this, length: 3);
  }

  void loadData() async {
    await modifierFormBloc.loadModifier(widget.id, isCopy: widget.isCopy);
  }

  @override
  void dispose() {
    super.dispose();
    modifierFormBloc.dispose();
  }

  void save() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formStateKey.currentState!.validate()) {
      _formStateKey.currentState!.save();

      if (await modifierFormBloc.asyncValidate(modifier)) {
        MenuModifier temp = await modifierFormBloc.saveMenuModifier(modifier);
        Navigator.of(context).pop(temp);
      } else {
        _formStateKey.currentState!.validate();
      }
    }
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  late Orientation orientation;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          AppLocalizations.of(context)!.translate('Menu Modifiers'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("save", style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                save();
              })
        ],
      ),
      body: StreamBuilder(
          stream: modifierFormBloc.modifiers.stream,
          initialData: ModifierIsLoading(),
          builder: (BuildContext context, AsyncSnapshot<ModifierLoadState> snapshot) {
            if (snapshot.data is ModifierIsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data is ModifierIsLoaded) modifier = (snapshot.data as ModifierIsLoaded).modifier;
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
                        print(modifier.name);
                      },
                      indicatorSize: TabBarIndicatorSize.tab,
                      isScrollable: true,
                      indicator: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(fontSize: 24),
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
                              AppLocalizations.of(context)!.translate('Prices'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate('Food Nutrition'),
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
                      priceTab(),
                      Container(color: Colors.white, height: 800, child: foodNutritionTab()),
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
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(4)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Cancel'),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(4)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]!),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Save'),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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

  Widget foodNutritionTab() {
    return ListView(
      children: <Widget>[
        Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.translate('Total Kcal'),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                onSaved: (value) {},
                                initialValue: '0',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Total Carb'),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                onChanged: (String newAmount) {
                                  setState(() {});
                                },
                                initialValue: '0',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
                              ),
                            ),
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
                                onChanged: (String newAmount) {
                                  setState(() {});
                                },
                                initialValue: '0',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Total Protien'),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                onChanged: (String newAmount) {
                                  setState(() {});
                                },
                                initialValue: '0',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget generalTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: orientation == Orientation.portrait
          ? ListView(
              itemExtent: 110,
              children: <Widget>[nameField(), displayNameField(), displaySecondaryNameField(), receiptNameField(), kitchenNameField(), priceField(), descriptionField(), descriptionSecondaryField(), multipleField(), visibleField(), inActiveField(), actionsButtons()],
            )
          : ListView(
              itemExtent: 110,
              children: <Widget>[
                Row(children: [
                  Expanded(
                    child: nameField(),
                  ),
                ]),
                Row(children: [
                  Expanded(
                    child: displayNameField(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: displaySecondaryNameField(),
                  )
                ]),
                Row(children: [
                  Expanded(
                    child: receiptNameField(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: kitchenNameField(),
                  )
                ]),
                Row(children: [
                  Expanded(
                    child: descriptionField(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: descriptionSecondaryField(),
                  )
                ]),
                Row(children: [
                  Expanded(
                    child: priceField(),
                  ),
                ]),
                Row(children: [
                  Expanded(
                    child: multipleField(),
                  ),
                  Expanded(
                    child: visibleField(),
                  ),
                  Expanded(
                    child: inActiveField(),
                  )
                ]),
                actionsButtons()
              ],
            ),
    );
  }

  Widget priceTab() {
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
                decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: const Radius.circular(15))),
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 100),
                      child: Text(
                        AppLocalizations.of(context)!.translate('Price'),
                        style: const TextStyle(
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
                    itemCount: modifier.prices!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                          height: 70,
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2)),
                          child: InkWell(
                            onTap: () {},
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                              AutoSizeText(
                                modifier.prices![index].label!.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      width: 100,
                                      child: TextFormField(
                                        controller: TextEditingController(text: modifier.prices![index].priceTxt),
                                        decoration: const InputDecoration(
                                          contentPadding: const EdgeInsets.all(8),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (s) {
                                          modifier.prices![index].priceTxt = s;
                                        },
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel, size: 40),
                                      onPressed: () {
                                        modifierFormBloc.deletePrice(modifier.prices![index]);
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

  Widget nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          initialValue: modifier.name,
          onChanged: (value) {
            setState(() {
              modifier.name = value;
            });
          },
          onSaved: (value) {
            setState(() {
              modifier.name = value!;
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter some text';
            } else if (modifierFormBloc.nameValidation != "") {
              return modifierFormBloc.nameValidation;
            }
            return null;
          },
          decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget receiptNameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          AppLocalizations.of(context)!.translate('Receipt Name'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextFormField(
        initialValue: modifier.receipt_text,
        onSaved: (value) {
          setState(() {
            modifier.receipt_text = value!;
          });
        },
        onChanged: (value) {
          setState(() {
            modifier.receipt_text = value;
          });
        },
        decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget kitchenNameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          AppLocalizations.of(context)!.translate('Kitchen Name'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextFormField(
        initialValue: modifier.kitchen_name,
        onChanged: (value) {
          setState(() {
            modifier.kitchen_name = value;
          });
        },
        onSaved: (value) {
          setState(() {
            modifier.kitchen_name = value!;
          });
        },
        decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget displayNameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          AppLocalizations.of(context)!.translate('Display Name (primary)'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextFormField(
        initialValue: modifier.display_name,
        onChanged: (value) {
          setState(() {
            modifier.display_name = value;
          });
        },
        onSaved: (value) {
          setState(() {
            modifier.display_name = value!;
          });
        },
        decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget displaySecondaryNameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          AppLocalizations.of(context)!.translate('Display Name (secondary)'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextFormField(
        initialValue: modifier.secondary_display_name,
        onChanged: (value) {
          setState(() {
            modifier.secondary_display_name = value;
          });
        },
        onSaved: (value) {
          setState(() {
            modifier.secondary_display_name = value!;
          });
        },
        decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget priceField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        AppLocalizations.of(context)!.translate('Price'),
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextFormField(
        initialValue: modifier.additional_price.toString(),
        onChanged: (value) {
          setState(() {
            modifier.additional_price = double.parse(value);
          });
        },
        onSaved: (value) {
          setState(() {
            modifier.additional_price = double.parse(value!);
          });
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget descriptionField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          AppLocalizations.of(context)!.translate('Description(primary)'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextFormField(
        initialValue: modifier.description,
        onChanged: (value) {
          setState(() {
            modifier.description = value;
          });
        },
        onSaved: (value) {
          setState(() {
            modifier.description = value!;
          });
        },
        decoration: const InputDecoration(labelText: '', border: const OutlineInputBorder()),
      ),
    ]);
  }

  Widget descriptionSecondaryField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          AppLocalizations.of(context)!.translate('Description(secondary)'),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextFormField(
        initialValue: modifier.secondary_description,
        onChanged: (value) {
          setState(() {
            modifier.secondary_description = value;
          });
        },
        onSaved: (value) {
          setState(() {
            modifier.secondary_description = value!;
          });
        },
        decoration: const InputDecoration(labelText: '', border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget multipleField() {
    return Center(
        child: FormField(
            onSaved: (bool? value) {
              modifier.is_multiple = value!;
            },
            validator: null,
            initialValue: modifier.is_multiple,
            builder: (FormFieldState<bool> state) {
              return SwitchListTile(
                activeColor: Colors.green,
                title: Text(
                  AppLocalizations.of(context)!.translate('Can Be Multiple (2x)'),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: state.value!,
                onChanged: (bool value) => state.didChange(value),
              );
            }));
  }

  Widget visibleField() {
    return Center(
        child: FormField(
            onSaved: (bool? value) {
              modifier.is_visible = value!;
            },
            validator: null,
            initialValue: modifier.is_visible,
            builder: (FormFieldState<bool> state) {
              return SwitchListTile(
                activeColor: Colors.green,
                title: Text(
                  AppLocalizations.of(context)!.translate('Visible'),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: state.value!,
                onChanged: (bool value) => state.didChange(value),
              );
            }));
  }

  Widget inActiveField() {
    return Center(
        child: FormField(
            onSaved: (bool? value) {
              modifier.in_active = value!;
            },
            validator: null,
            initialValue: modifier.in_active,
            builder: (FormFieldState<bool> state) {
              return SwitchListTile(
                activeColor: Colors.green,
                title: Text(
                  AppLocalizations.of(context)!.translate('In Active'),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: state.value!,
                onChanged: (bool value) => state.didChange(value),
              );
            }));
  }
}
