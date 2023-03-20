import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/customer_page/customer_page_bloc.dart';
import 'package:invo_mobile/blocs/customer_page/customer_page_event.dart';
import 'package:invo_mobile/views/customer/index.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

import '../blocProvider.dart';

class CustomerPageLandscape extends StatefulWidget {
  CustomerPageLandscape({Key? key}) : super(key: key);

  @override
  _CustomerPageLandscapeState createState() => _CustomerPageLandscapeState();
}

class _CustomerPageLandscapeState extends State<CustomerPageLandscape> {
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
    super.dispose();
    name.dispose();
    note.dispose();
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
            padding: EdgeInsets.only(bottom: 5),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.translate("Name"),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                              TextField(
                                controller: name,
                                style: TextStyle(fontSize: 20),
                                onChanged: (_name) {
                                  customerPageBloc.customer.value!.name = _name;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
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
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.translate("Note"),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                            TextField(
                              controller: note,
                              style: TextStyle(fontSize: 20),
                              onChanged: (_note) {
                                customerPageBloc.customer.value!.note = _note;
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 2,
                            color:
                                customerPageBloc.customer.value!.activeContacts.length < 0 ? Colors.redAccent[700]! : Theme.of(context).primaryColor,
                          )),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                padding: EdgeInsets.all(4),
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
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  child: StreamBuilder(
                                    stream: customerPageBloc.contactUpdate.stream,
                                    initialData: customerPageBloc.contactUpdate.value,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return ListView.builder(
                                        itemCount: customerPageBloc.customer.value!.activeContacts.length,
                                        itemBuilder: (context, index) {
                                          Color color = Colors.white;
                                          if (customerPageBloc.customer.value!.activeContacts[index] == customerPageBloc.selectedContact) {
                                            color = Colors.lightBlue;
                                          }
                                          return InkWell(
                                            onTap: () {
                                              customerPageBloc.eventSink.add(SelectContact(customerPageBloc.customer.value!.activeContacts[index]));
                                            },
                                            child: Container(
                                              height: 50,
                                              color: color,
                                              padding: EdgeInsets.all(4),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      customerPageBloc.customer.value!.activeContacts[index].typeText,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      customerPageBloc.customer.value!.activeContacts[index].contact,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          )),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                padding: EdgeInsets.all(4),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      child: Text(
                                        AppLocalizations.of(context)!.translate("Default"),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
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
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  child: StreamBuilder(
                                    stream: customerPageBloc.addressUpdate.stream,
                                    initialData: customerPageBloc.addressUpdate.value,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return ListView.builder(
                                        itemCount: customerPageBloc.customer.value!.activeAddresses.length,
                                        itemBuilder: (context, index) {
                                          Color color = Colors.white;
                                          if (customerPageBloc.customer.value!.activeAddresses[index] == customerPageBloc.selectedAddress) {
                                            color = Colors.lightBlue;
                                          }
                                          return InkWell(
                                              onTap: () {
                                                customerPageBloc.eventSink
                                                    .add(SelectAddress(customerPageBloc.customer.value!.activeAddresses[index]));
                                              },
                                              child: Container(
                                                height: 50,
                                                color: color,
                                                padding: EdgeInsets.all(4),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                        width: 100,
                                                        child: Center(
                                                          child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                              color: Colors.green,
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(50),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        customerPageBloc.customer.value!.activeAddresses[index].fullAddress,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
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
                              )
                            ],
                          ),
                        ),
                      ),
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
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        width: 200,
                        child: PrimaryButton(
                          onTap: () {
                            customerPageBloc.eventSink.add(CustomerPageGoBack());
                          },
                          text: "Back",
                        ),
                      ),
                      Container(
                        width: 200,
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
