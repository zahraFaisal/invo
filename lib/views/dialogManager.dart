import 'dart:async';

import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_bloc.dart';
import 'package:invo_mobile/blocs/pending_page/pending_page_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_bloc.dart';
import 'package:invo_mobile/blocs/recall_page/recall_page_event.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/customer/customer_address.dart';
import 'package:invo_mobile/models/customer/customer_contact.dart';
import 'package:invo_mobile/models/order/order_header.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/buttons/secondary_button.dart';
import 'package:invo_mobile/widgets/drop_button.dart';
import 'package:invo_mobile/widgets/keypad/keypad.dart';
import 'package:invo_mobile/widgets/keypad/keypad_button.dart';
import 'package:invo_mobile/widgets/order_cart/order_cart.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:collection/collection.dart';

import '../service_locator.dart';

GlobalKey loadingDialogKey = GlobalKey();

class DialogManager extends StatefulWidget {
  final Widget? child;
  DialogManager({Key? key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();
  late List<String> addressList1;

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
    _dialogService.registerPasswordDialogListener(_showPasswordDialog);
    _dialogService.registerPopupTicketListener(_popUpTicket);
    _dialogService.registerPopupPendingTicketListener(_popUpPendingTicket);
    _dialogService.registerLoadingListener(_showLoadingDialog);
    _dialogService.registerTelephoneDialogListener(_showTelephoneDialog);
    _dialogService.registerNumberDialogListener(_showNumberDialog);
    _dialogService.registerRecallTelephoneDialogListener(_showRecallTelephoneDialog);
    _dialogService.registerShortNoteDialogListener(_showShotNoteDialog);
    _dialogService.registerNoteDialogListener(_noteDialog);
    _dialogService.registerLoadingProgressListener(_progressLoading);
    _dialogService.registerCloseDialogListener(closeDialog);
    _dialogService.registerCustomerContactDialogListener(_customerContactDialog);
    _dialogService.registerCustomerAddressDialogListener(_customerAddressDialog);

    _dialogService.registerBalanceDialogListener(_balanceDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }

  void closeDialog() {
    Navigator.of(context).pop();
  }

  void _progressLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: 40,
              height: 100,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate("Loading..."),
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showDialog(DialogRequest request) {
    List<Widget> widgets = List<Widget>.empty(growable: true);

    if (request.okButton != null) {
      widgets.add(new TextButton(
        child: Text(request.okButton!),
        onPressed: () {
          _dialogService.dialogComplete(true);
          Navigator.of(context).pop();
        },
      ));
    }

    if (request.cancelButton != null) {
      widgets.add(new TextButton(
        child: Text(request.cancelButton!),
        onPressed: () {
          _dialogService.dialogComplete(false);
          Navigator.of(context).pop();
        },
      ));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(request.title!),
            content: new Text(request.description!),
            actions: widgets,
          );
        });
  }

  void _showLoadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            key: loadingDialogKey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    AppLocalizations.of(context)!.translate("Loading..."),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _balanceDialog(String balance, OrderHeader? orderHeader) async {
    GlobalKey<KeypadState> keypadState = new GlobalKey<KeypadState>();
    Keypad keypadWidget = Keypad(
      key: keypadState,
      isPassword: true,
      isButtonOfHalfInclude: false,
      EnterText: AppLocalizations.of(context)!.translate('Enter Your Password'),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
          child: Container(
            width: 350,
            height: 350,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          "Change \n" + balance,
                          style: TextStyle(
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate("Done"),
                              onTap: () {
                                _dialogService.balanceDialogComplete();

                                Navigator.of(context).pop("");
                              },
                            ),
                          ),
                          SizedBox(),
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate("Print"),
                              onTap: () {
                                if (orderHeader != null) {
                                  Terminal? terminal = locator.get<ConnectionRepository>().terminal;
                                  PrintService printService = new PrintService(terminal!);
                                  printService.printOrder(orderHeader);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Future<String?> _showPasswordDialog() async {
    GlobalKey<KeypadState> keypadState = new GlobalKey<KeypadState>();
    Keypad keypadWidget = Keypad(
      key: keypadState,
      isPassword: true,
      isButtonOfHalfInclude: false,
      EnterText: AppLocalizations.of(context)!.translate('Enter Your Password'),
    );

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: 430,
            height: 720,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: keypadWidget,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Cancel'),
                              onTap: () {
                                _dialogService.passwordDialogComplete("");
                                Navigator.of(context).pop("");
                              },
                            ),
                          ),
                          SizedBox(),
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Enter'),
                              onTap: () {
                                _dialogService.passwordDialogComplete(keypadState.currentState!.text);
                                Navigator.of(context).pop(keypadState.currentState!.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Future<String?> _showTelephoneDialog() async {
    GlobalKey<KeypadState> keypadState = new GlobalKey<KeypadState>();
    Keypad keypadWidget = Keypad(
      isTelephoneStyle: true,
      key: keypadState,
      isPassword: false,
      isButtonOfHalfInclude: false,
      EnterText: AppLocalizations.of(context)!.translate('Enter Telephone'),
    );

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: 430,
            height: 720,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: keypadWidget,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Cancel'),
                              onTap: () {
                                _dialogService.telephoneDialogComplete("");
                                Navigator.of(context).pop("");
                              },
                            ),
                          ),
                          SizedBox(),
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Enter'),
                              onTap: () {
                                _dialogService.telephoneDialogComplete(keypadState.currentState!.text);
                                Navigator.of(context).pop(keypadState.currentState!.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Future<String?> _showRecallTelephoneDialog(DialogRequest request) async {
    Property<bool> isTelephoneHit = new Property<bool>();

    GlobalKey<KeypadState> keypadState = new GlobalKey<KeypadState>();
    Keypad keypadWidget = Keypad(
      isTelephoneStyle: true,
      key: keypadState,
      isPassword: false,
      isButtonOfHalfInclude: false,
      EnterText: AppLocalizations.of(context)!.translate('Enter Telephone'),
      onChange: (value) {
        if (value == "" && isTelephoneHit.value != false) {
          isTelephoneHit.sinkValue(false);
        } else if (isTelephoneHit.value != true) {
          isTelephoneHit.sinkValue(true);
        }
      },
    );

    List<Widget> actions = new List<Widget>.empty(growable: true);
    if (request.actions != null) {
      for (var item in request.actions!) {
        actions.add(Expanded(
          child: StreamBuilder(
              stream: isTelephoneHit.stream,
              builder: (context, snapshot) {
                return PrimaryButton(
                  text: item.content!,
                  isEnabled: (isTelephoneHit.value != null) ? !isTelephoneHit.value! : true,
                  fontSize: 24,
                  onTap: () {
                    item.onTab!();
                    if (item.closeOnTab!) Navigator.of(context).pop("");
                    isTelephoneHit.dispose();
                  },
                );
              }),
        ));
      }
    }

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: 600,
            height: 720,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: keypadWidget,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Cancel'),
                              onTap: () {
                                isTelephoneHit.dispose();
                                _dialogService.recallTelephoneDialogComplete("");
                                Navigator.of(context).pop("");
                              },
                            ),
                          ),
                          SizedBox(),
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Enter'),
                              onTap: () {
                                isTelephoneHit.dispose();
                                _dialogService.recallTelephoneDialogComplete(keypadState.currentState!.text);
                                Navigator.of(context).pop(keypadState.currentState!.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: actions,
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Future<String?> _showNumberDialog(NumberDialogRequest request) async {
    GlobalKey<KeypadState> keypadState = new GlobalKey<KeypadState>();
    Keypad keypadWidget = Keypad(
      key: keypadState,
      maxLength: request.maxLength ?? 3,
      isPassword: false,
      isButtonOfDotInclude: request.hasDotButton ?? false,
      isButtonOfHalfInclude: request.hasHalfButton ?? false,
      EnterText: request.title!,
    );

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: 430,
            height: 720,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: keypadWidget,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Cancel'),
                              onTap: () {
                                _dialogService.numberDialogComplete("");
                                Navigator.of(context).pop("");
                              },
                            ),
                          ),
                          SizedBox(),
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Enter'),
                              onTap: () {
                                _dialogService.numberDialogComplete(keypadState.currentState!.text);
                                Navigator.of(context).pop(keypadState.currentState!.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  void _showShotNoteDialog() async {
    TextEditingController noteCtr = TextEditingController();
    TextEditingController priceCtr = TextEditingController();
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.translate("Add Short Note")),
            content: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(AppLocalizations.of(context)!.translate("Note :")),
                        Expanded(
                          child: TextField(
                            controller: noteCtr,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(AppLocalizations.of(context)!.translate("Price :")),
                        Expanded(
                          child: TextField(
                            controller: priceCtr,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: Text(AppLocalizations.of(context)!.translate("OK")),
                onPressed: () {
                  _dialogService.shortNoteDialogComplete(noteCtr.text, priceCtr.text);
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: Text(AppLocalizations.of(context)!.translate("Cancel")),
                onPressed: () {
                  _dialogService.shortNoteDialogComplete("", "");
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _noteDialog(String title) async {
    TextEditingController noteCtr = TextEditingController();
    TextEditingController priceCtr = TextEditingController();
    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(title),
            content: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: noteCtr,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.translate("OK")),
                onPressed: () {
                  _dialogService.noteDialogComplete(noteCtr.text);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.translate("Cancel")),
                onPressed: () {
                  _dialogService.noteDialogComplete("");
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  int contactId = 1;
  List items = List<DropdownMenuItem<int>>.empty(growable: true)
    ..add(DropdownMenuItem<int>(
      value: 1,
      child: Text(
        "Phone",
        style: TextStyle(fontSize: 30),
      ),
    ))
    ..add(DropdownMenuItem<int>(
      value: 2,
      child: new Text(
        "Mobile",
        style: TextStyle(fontSize: 30),
      ),
    ))
    ..add(DropdownMenuItem<int>(
      value: 3,
      child: Text(
        "Fax",
        style: TextStyle(fontSize: 30),
      ),
    ))
    ..add(DropdownMenuItem<int>(
      value: 4,
      child: Text(
        "Email",
        style: TextStyle(fontSize: 30),
      ),
    ));
  void _customerContactDialog(CustomerContact contact) async {
    TextEditingController contactController = TextEditingController(text: contact.contact);
    Property<int> type = Property<int>();
    type.setValue(contact.type);
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: 430,
            height: 280,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              AppLocalizations.of(context)!.translate("Type"),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder(
                              stream: type.stream,
                              initialData: type.value,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                return DropdownButton(
                                  hint: Text(AppLocalizations.of(context)!.translate("Select")),
                                  value: type.value == null ? 1 : type.value,
                                  onChanged: (int? value) {
                                    type.sinkValue(value ?? 1);
                                    contact.type = value!;
                                  },
                                  items: items.toList() as List<DropdownMenuItem<int>>,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              AppLocalizations.of(context)!.translate("Contact"),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: contactController,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Cancel'),
                              onTap: () {
                                _dialogService.customerContactDialogComplete(null);

                                //dismiss keyboard
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(),
                          Expanded(
                            child: KeypadButton(
                              text: AppLocalizations.of(context)!.translate('Enter'),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                contact.contact = contactController.text;
                                _dialogService.customerContactDialogComplete(contact);
                                //dismiss keyboard

                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
    type.dispose();
  }

  void _customerAddressDialog(CustomerAddress address) async {
    List<InputList> addressType = List<InputList>.empty(growable: true);
    final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
    Preference? preference = await locator.get<ConnectionRepository>().preference;
    TextEditingController line2 = TextEditingController(text: address.address_line2);
    if (preference != null) {
      if (preference.address_format == null || preference.address_format == "") {
        String text = "";
        if (address.address_line1 != null && address.address_line1.contains(";")) {
          text = address.address_line1.split(";").firstWhere((f) => f.startsWith("Road"), orElse: () => "");
          if (text != "") {
            text = text.split(':')[1];
          }
        }

        TextEditingController temp = TextEditingController(text: text);
        addressType.add(InputList(
            "Road",
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Text(
                      AppLocalizations.of(context)!.translate("Road"),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        address.setVal('Road', value);
                      },
                      controller: temp,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            temp));
      } else {
        TextEditingController temp;
        var list;
        List<String> addressListTemp = preference.address_format.split(";");
        for (var i = 0; i < addressListTemp.length; i++) {
          list = addressListTemp[i].split(',');
          temp = TextEditingController(text: '');
          addressType.add(InputList(
              list[0],
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        list[0],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: address.initalVal(list[0]) != null ? address.initalVal(list[0]) : "",
                        validator: (String? value) {
                          if (list[1] == '1') {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          address.setVal(addressListTemp[i].split(',')[0], value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              temp));
        }
      }
      TextEditingController temp = new TextEditingController(text: "");
    } else {
      TextEditingController temp = new TextEditingController(text: "");
      addressType.add(InputList(
          "Address line 1",
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: const Text(
                    "Address line 1",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: address.address_line1,
                    onChanged: (value) {
                      address.address_line1 = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              ],
            ),
          ),
          temp));
    }
    address.setInitalVal();
    TextEditingController temp = TextEditingController(text: "");

    addressType.add(InputList(
        "",
        Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Container(
                width: 300,
                child: Text(
                  AppLocalizations.of(context)!.translate("Additional Information"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: address.additional_information,
                  onChanged: (value) {
                    address.additional_information = value;
                  },
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
        ),
        temp));

    addressType.add(InputList(
        "",
        Container(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: KeypadButton(
                  text: AppLocalizations.of(context)!.translate('Cancel'),
                  onTap: () {
                    // _dialogService.customerAddressDialogComplete(null);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(),
              Expanded(
                child: KeypadButton(
                  text: AppLocalizations.of(context)!.translate('Enter'),
                  onTap: () {
                    _formStateKey.currentState!.save();
                    if (_formStateKey.currentState!.validate()) {
                      address.save();
                      _dialogService.customerAddressDialogComplete(address);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        temp));

    await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Scaffold(
          body: Container(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formStateKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate("Address Form"),
                      style: TextStyle(fontSize: 35),
                    ),
                    Container(
                      height: 3,
                      color: Colors.black54,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: addressType.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: addressType[index].widget,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _popUpPendingTicket(OrderHeader order) {
    Navigator.of(context).pop();

    PendingPageBloc pendingPageBloc = locator.get<PendingPageBloc>();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            body: Container(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: OrderCart(
                        isOrderCartInDialog: true,
                        order: order,
                      ),
                    ),
                    Container(
                      height: 55,
                      //color: Color(0xFF3F454E),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: SecondaryButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  pendingPageBloc.eventSink.add(AcceptPendingOrder());
                                },
                                text: AppLocalizations.of(context)!.translate('Accept')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: SecondaryButton(
                              onTap: () {
                                pendingPageBloc.eventSink.add(PrintPendingOrder());
                              },
                              text: AppLocalizations.of(context)!.translate('Print Ticket'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: SecondaryButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  pendingPageBloc.eventSink.add(RejectPendingOrder());
                                },
                                text: AppLocalizations.of(context)!.translate('Reject')),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: SecondaryButton(
                              text: AppLocalizations.of(context)!.translate('Show Map'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _popUpTicket(OrderHeader order) {
    Navigator.of(context).pop();

    RecallPageBloc recallPageBloc = locator.get<RecallPageBloc>();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            body: Container(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: OrderCart(
                        isOrderCartInDialog: true,
                        order: order,
                      ),
                    ),
                    Container(
                      height: 55,
                      //color: Color(0xFF3F454E),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          (order.isEditBtnVisible)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 1),
                                  child: SecondaryButton(
                                    onTap: () {
                                      Navigator.of(context).pop();

                                      recallPageBloc.eventSink.add(EditOrder());
                                    },
                                    text: AppLocalizations.of(context)!.translate('Edit Order'),
                                  ),
                                )
                              : SizedBox(),
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: SecondaryButton(
                              onTap: () {
                                recallPageBloc.eventSink.add(PrintOrder());
                              },
                              text: AppLocalizations.of(context)!.translate('Print Ticket'),
                            ),
                          ),
                          (order.isPayBtnVisible)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 1),
                                  child: SecondaryButton(
                                    onTap: () {
                                      if (Orientation.portrait == MediaQuery.of(context).orientation) {
                                        recallPageBloc.eventSink.add(PayOrder(orientation: MediaQuery.of(context).orientation));
                                      } else {
                                        recallPageBloc.eventSink.add(PayOrder());
                                      }
                                    },
                                    text: AppLocalizations.of(context)!.translate("Pay"),
                                  ),
                                )
                              : SizedBox(),

                          // Padding(
                          //   padding: EdgeInsets.only(right: 1),
                          //   child: SecondaryButton(
                          //     text:
                          //         AppLocalizations.of(context)!.translate('Pay'),
                          //   ),
                          // ),
                          (recallPageBloc.order!.isVoidBtnVisible)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 1),
                                  child: SecondaryButton(
                                    onTap: () {
                                      recallPageBloc.eventSink.add(VoidOrder(orientation: Orientation.portrait));
                                    },
                                    text: AppLocalizations.of(context)!.translate('Void Ticket'),
                                  ),
                                )
                              : SizedBox(),
                          (recallPageBloc.order!.isEditBtnVisible)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 1),
                                  child: SecondaryButton(
                                    onTap: () {
                                      Navigator.of(context).pop();

                                      recallPageBloc.eventSink.add(FollowUpOrder());
                                    },
                                    text: AppLocalizations.of(context)!.translate('Follow Up'),
                                  ),
                                )
                              : SizedBox(),
                          (recallPageBloc.order!.isSurchargeBtnVisible)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 1),
                                  child: SecondaryButton(
                                    onTap: () {
                                      recallPageBloc.eventSink.add(SurchargeOrder());
                                    },
                                    text: AppLocalizations.of(context)!.translate('Subcharge'),
                                  ),
                                )
                              : SizedBox(),
                          (recallPageBloc.order!.isDiscountBtnVisible)
                              ? Padding(
                                  padding: EdgeInsets.only(right: 1),
                                  child: SecondaryButton(
                                    onTap: () {
                                      recallPageBloc.eventSink.add(DiscountOrder());
                                    },
                                    text: AppLocalizations.of(context)!.translate('Discount'),
                                  ),
                                )
                              : SizedBox(),
                          // Padding(
                          //   padding: EdgeInsets.only(right: 1),
                          //   child: SecondaryButton(
                          //     text: AppLocalizations.of(context)
                          //         !.translate('Send Email'),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(right: 1),
                          //   child: SecondaryButton(
                          //     text: AppLocalizations.of(context)
                          //         !.translate('Show Map'),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class InputList {
  String name;
  Widget widget;
  TextEditingController controller;
  InputList(this.name, this.widget, this.controller);
}
