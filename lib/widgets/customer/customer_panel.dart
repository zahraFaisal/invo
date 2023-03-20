import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/customer_list_page/customer_list_page_bloc.dart';
import 'package:invo_mobile/blocs/customer_list_page/customer_list_page_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/customer/customer.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';

//typedef Discount2VoidFunc = void Function(Discount);

typedef Customer2VoidFunc = void Function(String);
typedef Customer2Func = void Function(CustomerList);

class CustomerPanel extends StatefulWidget {
  final CustomerListPageBloc bloc;
  final Void2VoidFunc onCancel;
  final Customer2VoidFunc onCustomerEdit;
  final Customer2Func onCustomerSelect;

  CustomerPanel({
    Key? key,
    required this.onCancel,
    required this.bloc,
    required this.onCustomerEdit,
    required this.onCustomerSelect,
  }) : super(key: key);

  @override
  _CustomerPanelState createState() => _CustomerPanelState();
}

List<CustomerList> list = [];

class _CustomerPanelState extends State<CustomerPanel> {
  Property<bool> isTelephoneHit = new Property<bool>(); // determine if telephone number is set or empty
  late String number;
  late CustomerList customer;
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isTelephoneHit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerListPageBloc>(
      bloc: widget.bloc,
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.portrait) {
            return portrait();
          } else {
            return landscape();
          }
        },
      ),
    );
  }

  Widget portrait() {
    var width = MediaQuery.of(context).size.width / 1.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  decoration: InputDecoration(labelText: 'Search', border: OutlineInputBorder()),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 60,
                  width: 100,
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Add"),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Keypad(
                                      isTelephoneStyle: true,
                                      onChange: (s) {
                                        number = s;
                                        if (number == "" && isTelephoneHit.value != false) {
                                          isTelephoneHit.sinkValue(false);
                                        } else if (isTelephoneHit.value != true) {
                                          isTelephoneHit.sinkValue(true);
                                        }
                                      },
                                      EnterText: AppLocalizations.of(context)!.translate('Enter Telephone'),
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: isTelephoneHit.stream,
                                    initialData: false,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return Container(
                                        padding: EdgeInsets.all(1),
                                        height: 100,
                                        child: PrimaryButton(
                                          text: AppLocalizations.of(context)!.translate('Enter'),
                                          onTap: () {
                                            if (widget.onCustomerEdit != null) widget.onCustomerEdit(number);
                                            Navigator.of(context).pop();
                                          },
                                          fontSize: 35,
                                          isEnabled: (isTelephoneHit.value != null) ? isTelephoneHit.value! : false,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: EdgeInsets.only(top: 8),
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: customerListPortrait(),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 70,
                  child: PrimaryButton(
                    text: AppLocalizations.of(context)!.translate("Cancel"),
                    onTap: widget.onCancel,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget landscape() {
    var width = MediaQuery.of(context).size.width / 1.5;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                width: width / 1.2,
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  decoration: InputDecoration(labelText: 'Search', border: OutlineInputBorder()),
                ),
              ),
              Expanded(flex: 5, child: Container(margin: EdgeInsets.only(top: 8), width: width / 1.2, child: customerList())),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    height: 70,
                    width: 200,
                    child: PrimaryButton(
                      text: AppLocalizations.of(context)!.translate("Add"),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Keypad(
                                        isTelephoneStyle: true,
                                        onChange: (s) {
                                          number = s;
                                          if (number == "" && isTelephoneHit.value != false) {
                                            isTelephoneHit.sinkValue(false);
                                          } else if (isTelephoneHit.value != true) {
                                            isTelephoneHit.sinkValue(true);
                                          }
                                        },
                                        EnterText: AppLocalizations.of(context)!.translate('Enter Telephone'),
                                      ),
                                    ),
                                    StreamBuilder(
                                      stream: isTelephoneHit.stream,
                                      initialData: false,
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        return Container(
                                          padding: EdgeInsets.all(1),
                                          height: 100,
                                          child: PrimaryButton(
                                            text: AppLocalizations.of(context)!.translate('Enter'),
                                            onTap: () {
                                              if (widget.onCustomerEdit != null) widget.onCustomerEdit(number);
                                              Navigator.of(context).pop();
                                            },
                                            fontSize: 35,
                                            isEnabled: (isTelephoneHit.value != null) ? isTelephoneHit.value! : false,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    height: 70,
                    width: 200,
                    child: PrimaryButton(
                      text: AppLocalizations.of(context)!.translate("Select"),
                      onTap: () {
                        if (customer != null && widget.onCustomerSelect != null) widget.onCustomerSelect(customer);
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                    height: 70,
                    width: 200,
                    child: PrimaryButton(
                      text: AppLocalizations.of(context)!.translate("Edit"),
                      onTap: () {
                        if (customer != null && widget.onCustomerEdit != null) widget.onCustomerEdit(customer.contact);
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 70,
                        width: 200,
                        child: PrimaryButton(
                          text: AppLocalizations.of(context)!.translate("Cancel"),
                          onTap: widget.onCancel,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  late int _selectedIndex;
  _onSelected(int index, CustomerList selectedCustomer) {
    setState(() {
      _selectedIndex = index;
      customer = selectedCustomer;
    });
  }

  Future<void> filterSearchResults(String query) async {
    if (query == "" || query == null) {
      widget.bloc.eventSink.add(LoadCustomerList(''));
    } else {
      widget.bloc.eventSink.add(LoadCustomerList(query));
    }
  }

  late Orientation orientation;
  void listItemTapped(int index, CustomerList cust) {
    _onSelected(index, cust);
  }

  Widget customerListPortrait() {
    return StreamBuilder(
        stream: widget.bloc.model.stream,
        builder: (context, snapshot) {
          if (widget.bloc.model.value == null || widget.bloc.model.value!.length < 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            AppLocalizations.of(context)!.translate('Name'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate('Contact'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate('Select'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate('Edit'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemExtent: 60,
                      itemCount: widget.bloc.model.value!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            color: (_selectedIndex != null && _selectedIndex == index) ? Colors.orange[200] : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  widget.bloc.model.value![index].name == null ? "" : widget.bloc.model.value![index].name.toString(),
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    widget.bloc.model.value![index].contact == null ? "" : widget.bloc.model.value![index].contact.toString(),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PrimaryButton(
                                      text: AppLocalizations.of(context)!.translate("Select"),
                                      onTap: () {
                                        if (widget.bloc.model.value![index] != null && widget.onCustomerSelect != null)
                                          widget.onCustomerSelect(widget.bloc.model.value![index]);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PrimaryButton(
                                      text: AppLocalizations.of(context)!.translate("Edit"),
                                      onTap: () {
                                        if (widget.onCustomerEdit != null) widget.onCustomerEdit(widget.bloc.model.value![index].contact);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        });
  }

  Widget customerList() {
    return StreamBuilder(
        stream: widget.bloc.model.stream,
        builder: (context, snapshot) {
          if (widget.bloc.model.value == null || widget.bloc.model.value!.length < 0) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Name',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Contact',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      itemExtent: 60,
                      itemCount: widget.bloc.model.value!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            color: (_selectedIndex != null && _selectedIndex == index) ? Colors.orange[200] : Colors.white,
                          ),
                          child: ListTile(
                            onTap: () {
                              listItemTapped(index, widget.bloc.model.value![index]);
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: AutoSizeText(
                                    widget.bloc.model.value![index].name == null ? "" : widget.bloc.model.value![index].name.toString(),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.bloc.model.value![index].contact == null ? "" : widget.bloc.model.value![index].contact.toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        });
  }
}
