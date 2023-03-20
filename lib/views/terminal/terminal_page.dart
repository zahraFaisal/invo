// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/terminal_page/terminal_page_bloc.dart';
import 'package:invo_mobile/blocs/terminal_page/terminal_page_event.dart';
import 'package:invo_mobile/views/blocProvider.dart';
import 'package:invo_mobile/widgets/buttons/primary_button.dart';
import 'package:invo_mobile/widgets/translation/app_localizations.dart';
import 'package:collection/collection.dart';

class TerminalPage extends StatefulWidget {
  TerminalPage({Key? key}) : super(key: key);

  @override
  _TerminalPageState createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  // List<BluetoothDevice> _devices = [];
  // BluetoothDevice _device;

  // void loadDevices() async {
  //   try {
  //     _devices = await bluetooth.getBondedDevices();
  //   } on Exception {
  //     print("error");
  //     // TODO - Error
  //   }
  // }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (terminalPageBloc.devices.value == null || terminalPageBloc.devices.value!.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
        value: null,
      ));
    } else {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
        value: null,
      ));
      terminalPageBloc.devices.value!.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name!),
          value: device,
        ));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> _getX990Printers() {
    List<DropdownMenuItem<String>> items = [];
    if (terminalPageBloc.x990Printers.value == null) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
        value: "",
      ));
    } else {
      // items.add(DropdownMenuItem(
      //   child: Text('NONE'),
      //   value: "",
      // ));

      terminalPageBloc.x990Printers.value!.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device),
          value: device,
        ));
      });
    }
    debugPrint(items.length.toString());
    return items;
  }

  _getBlutoothDevice(BluetoothDevice? selectedDevice) {
    DropdownMenuItem<BluetoothDevice>? temp = _getDeviceItems().firstWhereOrNull((f) => f.value == selectedDevice);
    if (temp == null) return null;
    return temp.value;
  }

  // _getUsb(Map<String, dynamic>? selectedUsb) {
  //   DropdownMenuItem<Map<String, dynamic>>? temp;
  //   if (selectedUsb != null)
  //     // ignore: curly_braces_in_flow_control_structures
  //     for (var i = 0; i < _getUSBPrinters().length; i++) {
  //       if (_getUSBPrinters()[i].value != null) {
  //         if (_getUSBPrinters()[i].value!['productId'] == selectedUsb['productId']) {
  //           temp = _getUSBPrinters()[i];
  //         }
  //       }
  //     }
  //   if (temp == null) return null;
  //   return temp.value;
  // }

  List<DropdownMenuItem<String>> _getIPPrinters() {
    List<DropdownMenuItem<String>> items = [];

    if (terminalPageBloc.ipPrinters.value == null) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
        value: "",
      ));
      items.add(DropdownMenuItem(
        child: Text('Custom'),
        value: "Custom",
      ));
    } else {
      debugPrint(terminalPageBloc.ipPrinters.value!.length.toString());
      items.add(DropdownMenuItem(
        child: Text('NONE'),
        value: "",
      ));
      items.add(DropdownMenuItem(
        child: Text('Custom'),
        value: "Custom",
      ));
      terminalPageBloc.ipPrinters.value!.forEach((ip) {
        items.add(DropdownMenuItem(
          child: Text(ip),
          value: ip,
        ));
      });
    }
    return items;
  }

  List<DropdownMenuItem<Map<String, dynamic>>> _getUSBPrinters() {
    List<DropdownMenuItem<Map<String, dynamic>>> items = [];
    // if (terminalPageBloc.usbPrinters.value == null || terminalPageBloc.usbPrinters.value!.isEmpty) {
    //   items.add(DropdownMenuItem(
    //     child: Text('NONE'),
    //     value: null,
    //   ));
    // } else {
    //   items.add(DropdownMenuItem(
    //     child: Text('NONE'),
    //     value: null,
    //   ));
    //   terminalPageBloc.usbPrinters.value!.forEach((usb) {
    //     items.add(DropdownMenuItem(
    //       child: Text(usb['productName']!),
    //       value: usb,
    //     ));
    //   });
    // }
    return items;
  }

  List<DropdownMenuItem<String>> _getPrinterTypes() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(
      child: Text('Blutooth Printer'),
      value: 'Blutooth Printer',
    ));
    items.add(DropdownMenuItem(
      child: Text('IP Printer'),
      value: 'IP Printer',
    ));
    items.add(DropdownMenuItem(
      child: Text('X 990 Printer'),
      value: 'X 990 Printer',
    ));
    return items;
  }

  List<DropdownMenuItem<String>> _getPrinterSize() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(
      child: Text('58mm'),
      value: "58",
    ));

    items.add(DropdownMenuItem(
      child: Text('80mm'),
      value: "80",
    ));
    return items;
  }

  List<DropdownMenuItem<String>> _getPrintingType() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(
      child: Text('Raw'),
      value: "Raw",
    ));

    items.add(DropdownMenuItem(
      child: Text('Drawing'),
      value: "Drawing",
    ));

    items.add(DropdownMenuItem(
      child: Text('Template'),
      value: "Template",
    ));
    return items;
  }

  List<DropdownMenuItem<String>> _getKitchenPrintingType() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(
      child: Text('Raw'),
      value: "Raw",
    ));

    items.add(DropdownMenuItem(
      child: Text('Drawing'),
      value: "Drawing",
    ));
    return items;
  }

  _getPrinter(String? value) {
    DropdownMenuItem<String>? temp = _getIPPrinters().firstWhereOrNull((f) => f.value == value);
    if (temp == null) return "";
    return temp.value;
  }

  _getX990Printer(String? value) {
    DropdownMenuItem<String>? temp = _getX990Printers().firstWhereOrNull((f) => f.value == value);
    if (temp == null) return "";
    return temp.value;
  }

  List<DropdownMenuItem<String>> _getCashDrawers() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(
      child: Text('Default'),
      value: "27,112,0,25,250",
    ));

    items.add(DropdownMenuItem(
      child: Text('Sunmi'),
      value: "16,20,0,0,0",
    ));

    items.add(DropdownMenuItem(
      child: Text('custom'),
      value: null,
    ));
    return items;
  }

  _getCashDrawerItem(String value) {
    DropdownMenuItem<String>? temp = _getCashDrawers().firstWhereOrNull((f) => f.value == value);
    if (temp == null) return null;
    return temp.value;
  }

  final _formKey = GlobalKey<FormState>();
  late TerminalPageBloc terminalPageBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    terminalPageBloc = TerminalPageBloc(BlocProvider.of<NavigatorBloc>(context));

    // loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(width);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: BlocProvider<TerminalPageBloc>(
          bloc: terminalPageBloc,
          child: SafeArea(
            child: Container(
              color: Colors.grey[200],
              child: Form(
                key: _formKey,
                child: OrientationBuilder(
                  builder: (BuildContext context, Orientation orientation) {
                    if (orientation == Orientation.portrait) {
                      return portrait();
                    } else {
                      return landscape();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget portrait() {
    return ListView(
      children: <Widget>[
        Container(
          height: 65,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("General"),
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        Container(
          color: Colors.grey[300],
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 40, margin: EdgeInsets.only(bottom: 20), child: terminalNumber()),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 20),
                child: deviceName(),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 20),
                child: alias(),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 20),
                child: langaugeInput(),
              ),
            ],
          ),
        ),
        Container(
          height: 65,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Options"),
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        disablePassword(),
        skipTableSelection(),
        stayAtOrderScreen(),
        Container(
          height: 65,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Printers"),
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        receiptPrinterSection(),
        terminalPageBloc.isKitchenPrinterAvailable ? SizedBox() : kitchenPrinterSection(),
        Container(
          height: 65,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate("Cash Drawer"),
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 5,
            ),
          ),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              cashDrawerCode(),
              customDrawerCode(),
            ],
          ),
        ),
        Container(
          height: 65,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              "CrediMax ECR",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 5,
            ),
          ),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: <Widget>[
              terminalID(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                width: 150,
                child: PrimaryButton(
                  onTap: () {
                    terminalPageBloc.eventSink.add(TerminalPageGoBack());
                  },
                  text: AppLocalizations.of(context)!.translate('Back'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 50,
                width: 150,
                child: PrimaryButton(
                  onTap: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      terminalPageBloc.eventSink.add(SaveTerminal());
                    }
                  },
                  text: AppLocalizations.of(context)!.translate('Submit'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget landscape() {
    return ListView(
      children: <Widget>[
        Container(
          height: 65,
          margin: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            AppLocalizations.of(context)!.translate("General"),
            style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
          ),
        ),
        Container(
          color: Colors.grey[300],
          margin: EdgeInsets.only(left: 20, bottom: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 40, margin: EdgeInsets.only(bottom: 20), child: terminalNumber()),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 20),
                child: deviceName(),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 20),
                child: alias(),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 20),
                child: langaugeInput(),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Container(
                  height: 65,
                  margin: EdgeInsets.only(left: 20, top: 0),
                  child: Text(
                    AppLocalizations.of(context)!.translate("Options"),
                    style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                  ),
                ),
                disablePassword(),
                skipTableSelection(),
                stayAtOrderScreen(),
              ]),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 65,
                    margin: EdgeInsets.only(left: 20, top: 0),
                    child: Text(
                      AppLocalizations.of(context)!.translate("Cash Drawer"),
                      style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 5,
                      ),
                    ),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        cashDrawerCode(),
                        customDrawerCode(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(
            height: 65,
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              AppLocalizations.of(context)!.translate("Printers"),
              style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.translate("Receipt Printer"),
                        style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 5,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[receiptPrinterType(), receiptPrinter(), customReceiptPrinter(), receiptPrinterSize(), printingType(), getReceiptTemplate(), templateBtn()],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              terminalPageBloc.isKitchenPrinterAvailable
                  ? SizedBox()
                  : Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.translate("Kitchen Printer"),
                              style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 5,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[kitchenPrinter(), customKitchenPrinter(), kitchenPrintingType()],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 50,
                width: 200,
                child: PrimaryButton(
                  onTap: () {
                    terminalPageBloc.eventSink.add(TerminalPageGoBack());
                  },
                  text: AppLocalizations.of(context)!.translate('Back'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 50,
                width: 200,
                child: PrimaryButton(
                  onTap: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      terminalPageBloc.eventSink.add(SaveTerminal());
                    }
                  },
                  text: AppLocalizations.of(context)!.translate('Submit'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  receiptPrinterSection() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.translate("Receipt Printer"),
            style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 5,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                receiptPrinterType(),
                receiptPrinter(),
                StreamBuilder(
                  stream: terminalPageBloc.selectedIp.stream,
                  builder: (context, snapshot) {
                    if (terminalPageBloc.selectedIp.value == null || terminalPageBloc.selectedIp.value != "Custom") {
                      return SizedBox();
                    }
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 170,
                            margin: EdgeInsets.only(left: 4),
                            child: Text(
                              "Custom",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              child: TextFormField(
                                onChanged: (value) {
                                  terminalPageBloc.selectedIp.setValue(value);
                                },
                                initialValue: "",
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                customReceiptPrinter(),
                receiptPrinterSize(),
                printingType(),
                getReceiptTemplate(),
                templateBtn(),
              ],
            ),
          )
        ],
      ),
    );
  }

  kitchenPrinterSection() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.translate("Kitchen Printer"),
            style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 5,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[kitchenPrinter(), customKitchenPrinter(), kitchenPrintingType()],
            ),
          )
        ],
      ),
    );
  }

  Widget terminalNumber() {
    return Container(
      width: 200,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.translate("Terminal ") + terminalPageBloc.terminal!.id.toString(),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget deviceName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          margin: EdgeInsets.only(left: 4),
          child: Text(
            AppLocalizations.of(context)!.translate("Device Name"),
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: TextFormField(
              readOnly: true,
              initialValue: (terminalPageBloc.terminal!.computer_name != null) ? terminalPageBloc.terminal!.computer_name : "",
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ),
      ],
    );
  }

  Widget alias() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          margin: EdgeInsets.only(left: 4),
          child: Text(
            AppLocalizations.of(context)!.translate("Alias"),
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: TextFormField(
              onSaved: (value) {
                terminalPageBloc.terminal!.alias = value;
              },
              initialValue: (terminalPageBloc.terminal!.alias != null) ? terminalPageBloc.terminal!.alias : "",
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget langaugeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          margin: EdgeInsets.only(left: 4),
          child: Text(
            AppLocalizations.of(context)!.translate("Langauge"),
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(right: 8),
              child: PopupMenuButton<String>(
                onSelected: (lang) {
                  setState(() {
                    terminalPageBloc.terminal!.langauge = lang;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    border: Border.all(
                      width: 2,
                      color: Colors.black54,
                    ),
                  ),
                  // color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text((terminalPageBloc.terminal!.langauge != null) ? terminalPageBloc.terminal!.langauge! : "", softWrap: true, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, height: 1, fontSize: 21)),
                        ),
                        Icon(Icons.expand_more)
                      ],
                    ),
                  ),
                ),
                itemBuilder: (context) {
                  return List<PopupMenuItem<String>>.empty(growable: true)
                    ..add(PopupMenuItem(
                      value: 'en',
                      child: Text(AppLocalizations.of(context)!.translate("English")),
                    ))
                    ..add(PopupMenuItem(
                      value: 'ar',
                      child: Text(AppLocalizations.of(context)!.translate("Arabic")),
                    ));
                },
              )),
        ),
      ],
    );
  }

  disablePassword() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: FormField(
          onSaved: (bool? value) {
            terminalPageBloc.terminal!.setNoSecurity(value!);
          },
          initialValue: terminalPageBloc.terminal!.noSecurity,
          validator: null,
          builder: (FormFieldState<bool> state) {
            return SwitchListTile(
              activeColor: Colors.green,
              title: Text(
                AppLocalizations.of(context)!.translate('Disable Re Enter Password'),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: state.value!,
              onChanged: (bool value) => state.didChange(value),
            );
          }),
    );
  }

  Widget skipTableSelection() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: FormField(
          onSaved: (bool? value) {
            terminalPageBloc.terminal!.setSkipTableSelection(value!);
          },
          initialValue: terminalPageBloc.terminal!.skipTableSelection,
          validator: null,
          builder: (FormFieldState<bool> state) {
            return SwitchListTile(
              activeColor: Colors.green,
              title: Text(
                AppLocalizations.of(context)!.translate('Skip Table Selection'),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: state.value!,
              onChanged: (bool value) => state.didChange(value),
            );
          }),
    );
  }

  Widget stayAtOrderScreen() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: FormField(
          onSaved: (bool? value) {
            terminalPageBloc.terminal!.setStayAtOrderScreen(value!);
          },
          initialValue: terminalPageBloc.terminal!.stayAtOrderScreen,
          validator: null,
          builder: (FormFieldState<bool> state) {
            return SwitchListTile(
              activeColor: Colors.green,
              title: Text(
                AppLocalizations.of(context)!.translate('Stay At Order Screen'),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: state.value!,
              onChanged: (bool value) => state.didChange(value),
            );
          }),
    );
  }

  Widget receiptPrinterType() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 170,
            child: Text(
              AppLocalizations.of(context)!.translate("Printer Type"),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: terminalPageBloc.printerType.stream,
              initialData: terminalPageBloc.printerType.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return DropdownButton<String>(
                  items: _getPrinterTypes(),
                  value: terminalPageBloc.printerType.value != null ? terminalPageBloc.printerType.value : AppLocalizations.of(context)!.translate("Blutooth Printer"),
                  onChanged: (value) {
                    terminalPageBloc.setPrinterType(value!);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  receiptPrinter() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 170,
            child: Text(
              AppLocalizations.of(context)!.translate("Printer"),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: terminalPageBloc.printerType.stream,
              initialData: terminalPageBloc.printerType.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (terminalPageBloc.printerType.value != null && terminalPageBloc.printerType.value == "Blutooth Printer") {
                  return StreamBuilder(
                    stream: terminalPageBloc.devices.stream,
                    initialData: terminalPageBloc.devices.value ?? [],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return DropdownButton(
                        items: _getDeviceItems(),
                        value: _getBlutoothDevice(terminalPageBloc.selectedDevice),
                        onChanged: (value) {
                          terminalPageBloc.setDevice(value as BluetoothDevice);
                        },
                      );
                    },
                  );
                } else if (terminalPageBloc.printerType.value != null && terminalPageBloc.printerType.value == "IP Printer") {
                  return StreamBuilder(
                    stream: terminalPageBloc.ipPrinters.stream,
                    initialData: terminalPageBloc.selectedIp.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (terminalPageBloc.ipPrinters.value == null) {
                        return Center(child: CircularProgressIndicator());
                      } else
                        // ignore: curly_braces_in_flow_control_structures
                        return DropdownButton(
                          items: _getIPPrinters(),
                          value: _getPrinter(terminalPageBloc.selectedIp.value),
                          onChanged: (value) {
                            if (value != null) {
                              terminalPageBloc.selectedIp.sinkValue(value as String);
                            }
                            terminalPageBloc.ipPrinters.sinkValue(terminalPageBloc.ipPrinters.value ?? List<String>.empty(growable: true));
                          },
                        );
                    },
                  );
                } else if (terminalPageBloc.printerType.value != null && terminalPageBloc.printerType.value == "X 990 Printer") {
                  return StreamBuilder(
                    stream: terminalPageBloc.x990Printers.stream,
                    initialData: terminalPageBloc.selectedX990.value,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (terminalPageBloc.x990Printers.value == null) {
                        return Center(child: CircularProgressIndicator());
                      } else
                        // ignore: curly_braces_in_flow_control_structures
                        return DropdownButton(
                          items: _getX990Printers(),
                          value: _getX990Printer(terminalPageBloc.selectedX990.value),
                          onChanged: (value) {
                            if (value != null) {
                              terminalPageBloc.selectedX990.sinkValue(value as String);
                            }
                            terminalPageBloc.x990Printers.sinkValue(terminalPageBloc.x990Printers.value ?? List<String>.empty(growable: true));
                          },
                        );
                    },
                  );
                }
                // else if (terminalPageBloc.printerType.value != null && terminalPageBloc.printerType.value == "USB Printer") {
                //   return StreamBuilder(
                //     stream: terminalPageBloc.usbPrinters.stream,
                //     initialData: terminalPageBloc.usbPrinters.value ?? [],
                //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                //       if (terminalPageBloc.usbPrinters.value == null) {
                //         return Center(child: CircularProgressIndicator());
                //       } else
                //         // ignore: curly_braces_in_flow_control_structures
                //         return DropdownButton(
                //           items: _getUSBPrinters(),
                //           value: _getUsb(terminalPageBloc.selectedUsb),
                //           onChanged: (value) {
                //             terminalPageBloc.setUsb(value! as Map<String, dynamic>);
                //           },
                //         );
                //     },
                //   );
                // }
                else {
                  return Center();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  customReceiptPrinter() {
    return StreamBuilder(
      stream: terminalPageBloc.selectedIp.stream,
      initialData: terminalPageBloc.selectedIp.value,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (terminalPageBloc.printerType.value != null && terminalPageBloc.printerType.value == "IP Printer" && _getPrinter(terminalPageBloc.selectedIp.value!) == null) {
          return Container(
            height: 40,
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    AppLocalizations.of(context)!.translate("Custom IP"),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                    child: TextFormField(
                  controller: TextEditingController(text: (terminalPageBloc.selectedIp.value == null || terminalPageBloc.selectedIp.value == "custom") ? "" : terminalPageBloc.selectedIp.value),
                  onChanged: (value) {
                    terminalPageBloc.selectedIp.setValue(value);
                  },
                  decoration: InputDecoration(border: OutlineInputBorder(), hintText: "192.168.192.168"),
                )),
              ],
            ),
          );
        }
        return Center();
      },
    );
  }

  terminalID() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 170,
            child: Text(
              "Terminal ID",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              child: StreamBuilder(
                  stream: terminalPageBloc.crediMaxTermianlId.stream,
                  builder: (context, snapshot) {
                    return TextFormField(
                      //key: GlobalKey(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        terminalPageBloc.crediMaxTermianlId.setValue(value);
                      },
                      onSaved: (value) {
                        terminalPageBloc.crediMaxTermianlId.setValue(value ?? "");
                      },
                      initialValue: terminalPageBloc.crediMaxTermianlId.value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  receiptPrinterSize() {
    return StreamBuilder<Object>(
        stream: terminalPageBloc.printerType.stream,
        builder: (context, snapshot) {
          if (terminalPageBloc.printerType.value != "X 990 Printer") {
            return Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 170,
                    child: Text(
                      AppLocalizations.of(context)!.translate("Printer Size"),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: terminalPageBloc.printerSize.stream,
                      initialData: terminalPageBloc.printerSize.value,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return DropdownButton<String>(
                          items: _getPrinterSize(),
                          value: terminalPageBloc.printerSize.value != null ? terminalPageBloc.printerSize.value : "80",
                          onChanged: (value) {
                            terminalPageBloc.printerSize.sinkValue(value ?? "");
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  printingType() {
    return StreamBuilder<Object>(
        stream: terminalPageBloc.printerType.stream,
        builder: (context, snapshot) {
          if (terminalPageBloc.printerType.value != "X 990 Printer") {
            return Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 170,
                    child: Text(
                      AppLocalizations.of(context)!.translate("Type"),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: terminalPageBloc.printingType.stream,
                      initialData: terminalPageBloc.printingType.value,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return DropdownButton<String>(
                          items: _getPrintingType(),
                          value: terminalPageBloc.printingType.value != null ? terminalPageBloc.printingType.value : "Raw",
                          onChanged: (value) {
                            terminalPageBloc.printingType.sinkValue(value ?? "");
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  templateBtn() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 50,
        width: 220,
        child: PrimaryButton(
          onTap: () {
            terminalPageBloc.eventSink.add(GoToDownloadTemplatePage());
          },
          text: "download templates",
        ),
      ),
    );
  }

  getReceiptTemplate() {
    return StreamBuilder<Object>(
        stream: terminalPageBloc.printingType.stream,
        builder: (context, snapshot) {
          return terminalPageBloc.printingType.value == "Template"
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 170,
                        child: Text(
                          "Receipt Template",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: terminalPageBloc.selectedTemp.stream,
                          initialData: terminalPageBloc.selectedTemp.value,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (terminalPageBloc.selectedTemp.value == null) {
                              return SizedBox();
                            }
                            return DropdownButton<String>(
                              isExpanded: true,
                              items: terminalPageBloc.templates.value,
                              value: terminalPageBloc.selectedTemp.value ?? "",
                              onChanged: (value) {
                                terminalPageBloc.selectedTemp.sinkValue(value ?? "");
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }

  kitchenPrintingType() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            child: Text(
              AppLocalizations.of(context)!.translate("Type"),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: terminalPageBloc.kitchenPrintingType.stream,
              initialData: terminalPageBloc.kitchenPrintingType.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return DropdownButton<String>(
                  items: _getKitchenPrintingType(),
                  value: terminalPageBloc.kitchenPrintingType.value != null ? terminalPageBloc.kitchenPrintingType.value : "Raw",
                  onChanged: (value) {
                    terminalPageBloc.kitchenPrintingType.sinkValue(value ?? "");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  kitchenPrinter() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            child: Text(
              AppLocalizations.of(context)!.translate("Printer"),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: terminalPageBloc.ipPrinters.stream,
              initialData: terminalPageBloc.kitchenPrinterIP,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (terminalPageBloc.ipPrinters.value == null || terminalPageBloc.ipPrinters.value!.length == 0) {
                  return Center(child: CircularProgressIndicator());
                } else
                  return DropdownButton(
                    items: _getIPPrinters(),
                    value: _getPrinter(terminalPageBloc.kitchenPrinterIP.value!),
                    onChanged: (value) {
                      terminalPageBloc.kitchenPrinterIP.sinkValue(value as String);
                      terminalPageBloc.ipPrinters.sinkValue(terminalPageBloc.ipPrinters.value ?? List<String>.empty(growable: true));
                    },
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  customKitchenPrinter() {
    return StreamBuilder(
        stream: terminalPageBloc.kitchenPrinterIP.stream,
        initialData: terminalPageBloc.kitchenPrinterIP.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (_getPrinter(terminalPageBloc.kitchenPrinterIP.value) == null) {
            return Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: Text(
                      AppLocalizations.of(context)!.translate("Custom IP"),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                      child: TextFormField(
                    controller: TextEditingController(text: (terminalPageBloc.kitchenPrinterIP.value == null || terminalPageBloc.kitchenPrinterIP.value == "custom") ? "" : terminalPageBloc.kitchenPrinterIP.value),
                    onChanged: (value) {
                      terminalPageBloc.kitchenPrinterIP.setValue(value);
                    },
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "192.168.192.168"),
                  )),
                ],
              ),
            );
          }

          return Center();
        });
  }

  cashDrawerCode() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            child: Text(
              AppLocalizations.of(context)!.translate("Cash Drawer Code"),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: terminalPageBloc.cashDrawer.stream,
              initialData: terminalPageBloc.cashDrawer.value,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return DropdownButton<String>(
                  items: _getCashDrawers(),
                  value: _getCashDrawerItem(terminalPageBloc.cashDrawer.value!),
                  onChanged: (value) {
                    terminalPageBloc.cashDrawer.sinkValue(value ?? "");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  customDrawerCode() {
    return StreamBuilder(
        stream: terminalPageBloc.cashDrawer.stream,
        initialData: terminalPageBloc.cashDrawer.value,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (_getCashDrawerItem(terminalPageBloc.cashDrawer.value!) == null) {
            return Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: Text(
                      AppLocalizations.of(context)!.translate("Custom Drawer Code"),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                      child: TextFormField(
                    controller: TextEditingController(text: (terminalPageBloc.cashDrawer.value == null || terminalPageBloc.cashDrawer.value == null) ? "" : terminalPageBloc.cashDrawer.value),
                    onChanged: (value) {
                      terminalPageBloc.cashDrawer.setValue(value);
                    },
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "27,112,0,25,250"),
                  )),
                ],
              ),
            );
          }

          return Center();
        });
  }
}
