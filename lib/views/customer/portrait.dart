import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/customer_page/customer_page_bloc.dart';
import 'package:invo_mobile/blocs/customer_page/customer_page_event.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../blocProvider.dart';

class CustomerPageProtrait extends StatefulWidget {
  CustomerPageProtrait({Key? key}) : super(key: key);

  @override
  _CustomerPageProtraitState createState() => _CustomerPageProtraitState();
}

class _CustomerPageProtraitState extends State<CustomerPageProtrait> {
  late CustomerPageBloc customerPageBloc;
  TextEditingController name = TextEditingController();
  TextEditingController note = TextEditingController();

  @override
  void initState() {
    super.initState();
    customerPageBloc = BlocProvider.of<CustomerPageBloc>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: customerPageBloc.customer.stream,
      initialData: customerPageBloc.customer.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (customerPageBloc.customer.value == null) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          name.text = customerPageBloc.customer.value!.name;
          note.text = customerPageBloc.customer.value!.note;

          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("Name"),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                TextField(
                                  controller: name,
                                  onChanged: (_name) {
                                    customerPageBloc.customer.value!.name = _name;
                                  },
                                  style: TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    fillColor: customerPageBloc.customer.value!.name == null ? Colors.redAccent[700] : Colors.white,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                customerPageBloc.customer.value!.name == null
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 10.0, top: 6),
                                        child: Text(
                                          'This Field is Required',
                                          style: TextStyle(color: Colors.redAccent[700], fontSize: 14),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            color: Theme.of(context).primaryColor,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("Type"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("Contact"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                                left: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            child: StreamBuilder(
                              stream: customerPageBloc.contactUpdate.stream,
                              initialData: customerPageBloc.contactUpdate.value,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                List<Widget> widgets = List<Widget>.empty(growable: true);
                                Color color;
                                for (var item in customerPageBloc.customer.value!.activeContacts) {
                                  color = Colors.white;
                                  if (item == customerPageBloc.selectedContact) {
                                    color = Colors.lightBlue;
                                  }
                                  widgets.add(InkWell(
                                    onTap: () {
                                      customerPageBloc.eventSink.add(SelectContact(item));
                                    },
                                    child: Container(
                                      height: 50,
                                      color: color,
                                      padding: EdgeInsets.all(4),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              item.typeText,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              item.contact,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                                }

                                return Column(
                                  children: widgets,
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 65,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            )),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: PrimaryButton(
                                        onTap: () {
                                          customerPageBloc.eventSink.add(AddContact());
                                        },
                                        text: AppLocalizations.of(context)!.translate("Add Contact"),
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: PrimaryButton(
                                        onTap: () {
                                          customerPageBloc.eventSink.add(EditContact());
                                        },
                                        text: AppLocalizations.of(context)!.translate("Edit Contact"),
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: PrimaryButton(
                                        onTap: () {
                                          customerPageBloc.eventSink.add(DeleteContact());
                                        },
                                        text: AppLocalizations.of(context)!.translate("Delete Contact"),
                                      )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          (customerPageBloc.customer.value!.activeContacts.length < 0)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                                  child: Text(
                                    'Please Enter Contact Info',
                                    style: TextStyle(color: Colors.redAccent[700], fontSize: 14),
                                  ),
                                )
                              : SizedBox(),
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            color: Theme.of(context).primaryColor,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("Address"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                                left: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            child: StreamBuilder(
                              stream: customerPageBloc.addressUpdate.stream,
                              initialData: customerPageBloc.addressUpdate.value,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                List<Widget> widgets = List<Widget>.empty(growable: true);
                                Color color;

                                for (var item in customerPageBloc.customer.value!.activeAddresses) {
                                  color = Colors.white;
                                  if (item == customerPageBloc.selectedAddress) {
                                    color = Colors.lightBlue;
                                  }

                                  widgets.add(InkWell(
                                      onTap: () {
                                        customerPageBloc.eventSink.add(SelectAddress(item));
                                      },
                                      child: Container(
                                        height: 50,
                                        color: color,
                                        padding: EdgeInsets.all(4),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                item.fullAddress,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )));
                                }

                                return Column(
                                  children: widgets,
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 65,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            )),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: PrimaryButton(
                                  onTap: () {
                                    customerPageBloc.eventSink.add(AddAddress());
                                  },
                                  text: AppLocalizations.of(context)!.translate("Add Address"),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: PrimaryButton(
                                  onTap: () {
                                    customerPageBloc.eventSink.add(EditAddress());
                                  },
                                  text: AppLocalizations.of(context)!.translate("Edit Address"),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: PrimaryButton(
                                  onTap: () {
                                    customerPageBloc.eventSink.add(DeleteAddress());
                                  },
                                  text: AppLocalizations.of(context)!.translate("Delete Address"),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 190,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)!.translate("Note"),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: TextField(
                                    maxLines: 4,
                                    controller: note,
                                    onChanged: (_note) {
                                      customerPageBloc.customer.value!.note = _note;
                                    },
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: PrimaryButton(
                          onTap: () {
                            customerPageBloc.eventSink.add(CustomerPageGoBack());
                          },
                          text: AppLocalizations.of(context)!.translate("Back"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: PrimaryButton(
                          onTap: () {
                            if (customerPageBloc.customer.value!.name != null && customerPageBloc.customer.value!.activeContacts.length > 0)
                              customerPageBloc.eventSink.add(SaveCustomer());
                          },
                          text: AppLocalizations.of(context)!.translate("Done"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
