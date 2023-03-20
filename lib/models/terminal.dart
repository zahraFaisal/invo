import 'dart:convert';

import 'package:invo_mobile/helpers/misc.dart';

class Terminal {
  int id;
  String? computer_name;
  String? alias;
  String? langauge;
  String? printing_type;
  String? kitchen_printing_type;
  int? locked_menu_type_id;
  String? settings;
  String? kitchen_printers;
  String? selected_temp;

  String? getLangauge() {
    if (langauge == null) return 'en';
    return langauge;
  }

  Terminal({required this.id, this.computer_name, this.langauge, this.alias, this.locked_menu_type_id, this.kitchen_printers, this.settings}) {
    try {
      if (kitchen_printers != null) {
        List<dynamic> _kitchenPrinters = jsonDecode(kitchen_printers!);
        kitchenPrinter = _kitchenPrinters[0]['printer'];
      }
    } catch (e) {
      kitchenPrinter = "";
    }
  }

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'],
      computer_name: json['computer_name'],
      langauge: json['language'], // the invo pos pro name is different
      alias: json['alias'],
      locked_menu_type_id: json['locked_menu_type_id'],
      settings: json['settings'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'computer_name': computer_name,
        'alias': alias,
        'language': langauge, // the invo pos pro name is different
        'locked_menu_type_id': locked_menu_type_id,
        'settings': settings
      };

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> _kitchenPrinters = [
      {
        'printer': kitchenPrinter,
      }
    ];

    var map = <String, dynamic>{
      'computer_name': computer_name,
      'alias': alias,
      'language': langauge,
      'locked_menu_type_id': locked_menu_type_id,
      'settings': settings,
      'kitchen_printers': jsonEncode(_kitchenPrinters),
    };
    return map;
  }

  factory Terminal.fromMap(Map<String, dynamic> map) {
    return Terminal(
        id: map['id'],
        computer_name: map['computer_name'],
        alias: map["alias"],
        langauge: map["language"],
        locked_menu_type_id: map['locked_menu_type_id'],
        settings: map["settings"],
        kitchen_printers: map['kitchen_printers']);
  }

  String getSettings(int index) {
    if (settings == null) return "0";
    List<String> feature = settings!.split(';');
    try {
      return feature[index];
    } catch (Exception) {
      return "0";
    }
  }

  // String settingFormat = "{0};{1};{2};{3};{4};{5};{6};{7};{8};{9};{10};{11};{12};{13};{14};{15};{16};{17};{18};{19};{20};{21};{22};{23};{24};{25};{26};{27};{28};{29};{30};{31};{32};{33};{34};{35};{36};{37};{38};{39}";

  void setSettings(int index, String value) {
    if (settings == null || settings == "") settings = ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    List<String> feature = settings!.split(';');
    String _setting = value.toString().replaceAll(";", "");
    List<String> arr = [];
    for (int i = 0; i < feature.length - 1; i++) {
      // arr[i] = feature[i];
      arr.add(feature[i]);
    }
    feature = arr;
    feature[index] = _setting;
    try {
      String temp = "";
      for (var item in feature) {
        if (item != null)
          temp += item.toString() + ";";
        else
          temp += ";";
      }

      settings = temp;
    } catch (Exception) {
      print("error");
    }
  }

  bool? get stayAtOrderScreen {
    return Misc.convertToBoolean(getSettings(2));
  }

  void setStayAtOrderScreen(bool newValue) {
    String value = "0";
    if (newValue) value = "1";
    setSettings(2, value.toString());
  }

  void setCashDrawerCode(String newValue) {
    setSettings(12, newValue.toString());
  }

  void setBluetoothPrinter(String newValue) {
    setSettings(25, newValue.toString());
  }

  void setUsbPrinter(String newValue) {
    setSettings(35, newValue.toString());
  }

  void setPrinterSize(String newValue) {
    setSettings(26, newValue.toString());
  }

  void setPrinterType(String newValue) {
    setSettings(42, newValue.toString());
  }

  void setKitchenPrintingType(String newValue) {
    setSettings(27, newValue.toString());
  }

  void setTemplate(String? newValue) {
    setSettings(19, newValue.toString());
  }

  void setPrintingType(String newValue) {
    setSettings(28, newValue.toString());
  }

  String get cashDrawarCode {
    String x = getSettings(12);
    return x;
  }

  String get bluetoothPrinter {
    String x = getSettings(25);
    return x;
  }

  String get printerSize {
    String x = getSettings(26);
    return x;
  }

  String get printerType {
    String x = getSettings(42);
    return x;
  }

  String get printingType {
    String x = getSettings(28);
    return x;
  }

  String get selectedTemp {
    String x = getSettings(19);
    return x;
  }

  String get kitchenPrintingType {
    String x = getSettings(27);
    return x;
  }

  String get usbPrinter {
    String x = getSettings(35);
    return x;
  }

  bool get noSecurity {
    return Misc.convertToBoolean(getSettings(0));
  }

  void setNoSecurity(bool newValue) {
    String value = "0";
    if (newValue) value = "1";
    setSettings(0, value.toString());
  }

  bool get skipTableSelection {
    return Misc.convertToBoolean(getSettings(3));
  }

  void setSkipTableSelection(bool newValue) {
    String value = "0";
    if (newValue) value = "1";
    setSettings(3, value.toString());
  }

  String get receiptPrinter {
    return getSettings(8);
  }

  void setReceiptPrinter(String newValue) {
    setSettings(8, newValue.toString());
  }

  String? kitchenPrinter;

  Terminal clone() {
    Terminal temp = Terminal(
      id: id,
      computer_name: computer_name,
      langauge: langauge,
      alias: alias,
      locked_menu_type_id: locked_menu_type_id,
      settings: settings,
      kitchen_printers: kitchen_printers,
    );
    temp.kitchenPrinter = kitchenPrinter;
    return temp;
  }
}
