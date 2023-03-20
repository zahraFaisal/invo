import 'dart:convert';
import 'dart:typed_data';

import 'package:invo_mobile/helpers/misc.dart';

class Preference {
  int id;
  String? restaurantName;
  String? restaurantLogo = "";
  double tax1 = 0;
  double tax2 = 0;
  double tax3 = 0;
  bool tax2_tax1 = false;
  String main_terminal_ip;
  String tax1_name = "";
  String tax2_name = "";
  String tax3_name = "";
  String vat_registration_number = "";

  String currency_setting = "0,0";
  String front_office_setting = "0,0,1,1,1,1,1,0,99,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1";
  String money_count = "";
  String address_format = "";
  String mod_filter_setting = "";
  String resturant_info = "";

  DateTime? day_start;
  String cloud_settings = "";
  DateTime? update_time;

  String primary_lang_code = "en";
  String secondary_lang_code = "ar";

  Uint8List? get logoByte {
    if (restaurantLogo == null) {
      return null;
    }
    return base64.decode(restaurantLogo!);
  }

  Preference(
      {this.id = 0,
      this.day_start,
      this.restaurantName,
      this.restaurantLogo,
      this.tax1 = 0,
      this.tax2 = 0,
      this.tax3 = 0,
      this.tax2_tax1 = false,
      this.tax1_name = "",
      this.tax2_name = "",
      this.tax3_name = "",
      this.vat_registration_number = "",
      this.currency_setting = "",
      this.front_office_setting = "",
      this.main_terminal_ip = "",
      this.mod_filter_setting = "",
      this.address_format = "",
      this.resturant_info = "",
      this.cloud_settings = ""});

  factory Preference.fromJson(Map<String, dynamic> json) {
    DateTime _day_start = DateTime.fromMillisecondsSinceEpoch(int.parse(json['day_start'].substring(6, json['day_start'].length - 7)));

    Preference preference = Preference();
    preference.id = json['id'] ?? 0;
    preference.restaurantName = json['resturant_name'];
    preference.restaurantLogo = json['Restaurant_logo'];
    preference.day_start = _day_start;
    preference.currency_setting = json['currency_setting'];
    preference.front_office_setting = json['front_office_setting'];
    preference.mod_filter_setting = json['mod_filter_setting'];
    preference.resturant_info = json['resturant_info'];
    preference.main_terminal_ip = json['main_terminal_ip'] ?? "";
    preference.address_format = json['address_format'];
    preference.tax1_name = json['tax1_name'] ?? "";
    preference.tax2_name = json['tax2_name'] ?? "";
    preference.tax3_name = json['tax3_name'] ?? "";
    preference.tax1 = json['tax1'] != null ? double.parse(json['tax1'].toString()) : 0;
    preference.tax2 = json['tax2'] != null ? double.parse(json['tax2'].toString()) : 0;
    preference.tax3 = json['tax3'] != null ? double.parse(json['tax3'].toString()) : 0;
    preference.tax2_tax1 = json['tax2_tax1'] ?? false;

    preference.primary_lang_code = json['primary_lang_code'] ?? 'en';
    preference.secondary_lang_code = json['secondary_lang_code'] ?? 'ar';

    try {
      preference.resturant_info = json['resturant_info'];
      preference.address1 = preference.getRestaurantInfo(0);

      preference.address2 = preference.getRestaurantInfo(1);
      preference.phone = preference.getRestaurantInfo(2);
      preference.vat_registration_number = preference.getRestaurantInfo(3);
      preference.url = preference.getRestaurantInfo(5);
      preference.money_count = json["Money_count"];
    } catch (e) {}

    try {
      preference.currency_setting = json['currency_setting'];
      preference.smallestCurrency = double.parse(preference.getCurrencySetting(0).toString());
      int? temp = int.tryParse(preference.getCurrencySetting(1).toString());
      if (temp == null) {
        preference.roundType = 0;
      }
      preference.roundType = temp;
    } catch (e) {
      print(e.toString());
    }

    try {
      preference.front_office_setting = json['front_office_setting'];
      preference.dontAllowSaleWhenCountDownIsZero = Misc.convertToBoolean(preference.getFrontOfficeSetting(0));
      preference.taxTitle = Misc.convertToBoolean(preference.getFrontOfficeSetting(31));
      preference.hideVoidedItem = Misc.convertToBoolean(preference.getFrontOfficeSetting(1));
      preference.voidedItemNeedExplantion = Misc.convertToBoolean(preference.getFrontOfficeSetting(2));
      preference.printTicketWhenSent = Misc.convertToBoolean(preference.getFrontOfficeSetting(3));
      preference.maxRef = int.parse(preference.getFrontOfficeSetting(3));
      preference.disableHalfItem = Misc.convertToBoolean(preference.getFrontOfficeSetting(16));
      preference.onlyOneCashierPerTerminal = Misc.convertToBoolean(preference.getFrontOfficeSetting(19));
      preference.numberOfPrintTicketWhenSent = int.parse(preference.getFrontOfficeSetting(4));

      preference.printTicketWhenSettle = Misc.convertToBoolean(preference.getFrontOfficeSetting(5));
      preference.printRestaurantName = Misc.convertToBoolean(preference.getFrontOfficeSetting(23));
      preference.printModPriceOnTicket = Misc.convertToBoolean(preference.getFrontOfficeSetting(12));
      preference.printRecipetNameAsSeconderyName = Misc.convertToBoolean(preference.getFrontOfficeSetting(20));
    } catch (e) {
      print(e.toString());
    }

    try {
      preference.address_format = json['address_format'];
      String address_format = preference.address_format;

      bool addressFormatEnabled(String address_name) {
        if (address_format != null) {
          return address_format.contains(address_name);
        } else {
          return false;
        }
      }

      bool addressFormatRequired(String address_name) {
        if (address_format != null && address_format != "" && address_format.contains(address_name)) {
          var list = [];
          List<String> addressListTemp = address_format.split(";");
          for (var i = 0; i < addressListTemp.length; i++) {
            list = addressListTemp[i].split(',');
            if (list.length > 0) {
              if (list[0].toLowerCase() == address_name.toLowerCase()) {
                return list[1] == "1" ? true : false;
              }
            } else
              return false;
          }
        } else
          return false;

        return false;
      }

      preference.flat = addressFormatEnabled("Flat");
      preference.building = addressFormatEnabled("Building");
      preference.house = addressFormatEnabled("House");
      preference.road = addressFormatEnabled("Road");
      preference.street = addressFormatEnabled("Street");
      preference.block = addressFormatEnabled("Block");
      preference.zipCode = addressFormatEnabled("ZipCode");
      preference.city = addressFormatEnabled("City");
      preference.state = addressFormatEnabled("State");
      preference.postalCode = addressFormatEnabled("PostalCode");
      preference.line1 = addressFormatEnabled("Line1");
      preference.line2 = addressFormatEnabled("Line2");
      preference.flat_required = addressFormatRequired("Flat");
      preference.building_required = addressFormatRequired("Building");
      preference.house_required = addressFormatRequired("House");
      preference.road_required = addressFormatRequired("Road");
      preference.street_required = addressFormatRequired("Street");
      preference.block_required = addressFormatRequired("Block");
      preference.zipCode_required = addressFormatRequired("ZipCode");
      preference.city_required = addressFormatRequired("City");
      preference.state_required = addressFormatRequired("State");
      preference.postalCode_required = addressFormatRequired("PostalCode");
      preference.line1_required = addressFormatRequired("Line1");
      preference.line2_required = addressFormatRequired("Line2");
    } catch (e) {
      print(e.toString());
    }
    return preference;
  }

  saveAddressFormat() {
    List<String> list = [];
    var required_ = "";
    if (flat == true) {
      required_ = flat_required == true ? "1" : "0";
      list.add("Flat,$required_");
    }

    if (building == true) {
      required_ = road_required == true ? "1" : "0";
      list.add("Building,$required_");
    }

    if (house == true) {
      required_ = house_required == true ? "1" : "0";
      list.add("House,$required_");
    }

    if (road == true) {
      required_ = road_required == true ? "1" : "0";
      list.add("Road,$required_");
    }

    if (street == true) {
      required_ = street_required == true ? "1" : "0";
      list.add("Street,$required_");
    }

    if (block == true) {
      required_ = block_required == true ? "1" : "0";
      list.add("Block,$required_");
    }

    if (zipCode == true) {
      required_ = zipCode_required == true ? "1" : "0";
      list.add("ZipCode,$required_");
    }

    if (city == true) {
      required_ = city_required == true ? "1" : "0";
      list.add("City,$required_");
    }

    if (state == true) {
      required_ = state_required == true ? "1" : "0";
      list.add("State,$required_");
    }

    if (postalCode == true) {
      required_ = postalCode_required == true ? "1" : "0";
      list.add("PostalCode,$required_");
    }

    if (line1 == true) {
      required_ = line1_required == true ? "1" : "0";
      list.add("Line1,$required_");
    }

    if (line2 == true) {
      required_ = line2_required == true ? "1" : "0";
      list.add("Line2,$required_");
    }

    if (list.length > 0)
      address_format = list.join(";");
    else
      address_format = "";
  }

  dynamic getProp(String key) {
    Map<String, dynamic>? map = this.toMap();
    map!.addAll({
      'address1': address1,
      'address2': address2,
      'phone': phone,
      'vat_registration_number': vat_registration_number,
      'url': url,
    });
    return map[key];
  }

  Map<String, dynamic>? toMap() {
    Map<String, dynamic> _resturantInfo = {
      'address1': address1,
      'address2': address2,
      'phone': phone,
      'vat_registration_number': vat_registration_number,
      'url': url,
    };

    Map<String, dynamic> _currencySetting = {
      'smallestCurrency': smallestCurrency,
      'roundType': roundType ?? 1,
    };

    Map<String, dynamic> _frontOfficeSetting = {
      'dontAllowSaleWhenCountDownIsZero': dontAllowSaleWhenCountDownIsZero,
      'taxTitle': taxTitle,
      'hideVoidedItem': hideVoidedItem,
      'voidedItemNeedExplantion': voidedItemNeedExplantion,
      'printTicketWhenSent': printTicketWhenSent,
      'maxRef': maxRef,
      "printModPriceOnTicket": printModPriceOnTicket,
      'disableHalfItem': disableHalfItem,
      'onlyOneCashierPerTerminal': onlyOneCashierPerTerminal,
      'numberOfPrintTicketWhenSent': numberOfPrintTicketWhenSent,
      'printTicketWhenSettle': printTicketWhenSettle,
      'printRestaurantName': printRestaurantName,
      'printRecipetNameAsSeconderyName': printRecipetNameAsSeconderyName
    };
    Map<String, dynamic> _cloud_settings = {'server': server, 'restSlug': restSlug, 'branch_name': branch_name, 'password': password};

    addToAddressFormat(String val, int req) {
      if (address_format == "") {
        address_format += "$val,$req";
      } else {
        address_format += ";$val,$req";
      }
    }

    address_format = "";
    if (flat == true) {
      addToAddressFormat("Flat", flat_required == true ? 1 : 0);
    }
    if (building == true) {
      addToAddressFormat("Building", building_required == true ? 1 : 0);
    }
    if (house == true) {
      addToAddressFormat("House", house_required == true ? 1 : 0);
    }
    if (road == true) {
      addToAddressFormat("Road", road_required == true ? 1 : 0);
    }
    if (street == true) {
      addToAddressFormat("Street", street_required == true ? 1 : 0);
    }
    if (block == true) {
      addToAddressFormat("Block", block_required == true ? 1 : 0);
    }
    if (zipCode == true) {
      addToAddressFormat("ZipCode", zipCode_required == true ? 1 : 0);
    }
    if (city == true) {
      addToAddressFormat("City", city_required == true ? 1 : 0);
    }
    if (state == true) {
      addToAddressFormat("State", state_required == true ? 1 : 0);
    }
    if (postalCode == true) {
      addToAddressFormat("PostalCode", postalCode_required == true ? 1 : 0);
    }
    if (line1 == true) {
      addToAddressFormat("Line1", line1_required == true ? 1 : 0);
    }
    if (line2 == true) {
      addToAddressFormat("Line2", line2_required == true ? 1 : 0);
    }

    var map = <String, dynamic>{
      'id': id,
      'resturant_name': restaurantName,
      'logo': restaurantLogo,
      'day_start': (day_start == null) ? null : day_start!.millisecondsSinceEpoch,
      'tax1': tax1 == null ? 0.0 : tax1,
      'tax2': tax2 == null ? 0.0 : tax2,
      'tax3': tax3 == null ? 0.0 : tax3,
      'tax2_tax1': tax2_tax1 == true ? 1 : 0,
      'tax1_name': tax1_name,
      'tax2_name': tax2_name,
      'tax3_name': tax3_name,
      'vat_registration_number': vat_registration_number,
      'resturant_info': jsonEncode(_resturantInfo),
      'currency_setting': jsonEncode(_currencySetting),
      'front_office_setting ': jsonEncode(_frontOfficeSetting),
      'mod_filter_setting': mod_filter_setting,
      'address_format': address_format,
      'cloud_settings': jsonEncode(_cloud_settings),
      'update_time': (update_time == null) ? null : update_time!.toUtc().millisecondsSinceEpoch,
    };
    return map;
  }

  factory Preference.fromMap(Map<String, dynamic> map) {
    Preference preference = Preference();

    try {
      Map<String, dynamic> _resturantInfo = jsonDecode(map['resturant_info']);
      preference.address1 = _resturantInfo['address1'] ?? "";
      preference.address2 = _resturantInfo['address2'] ?? "";
      preference.phone = _resturantInfo['phone'] ?? "";
      preference.fax = _resturantInfo['fax'] ?? "";
      preference.url = _resturantInfo['url'] ?? "";
    } catch (e) {
      print(e.toString());
    }
    try {
      Map<String, dynamic> _cloud_settings = jsonDecode(map['cloud_settings']);
      preference.server = _cloud_settings['server'];
      preference.restSlug = _cloud_settings['restSlug'];
      preference.branch_name = _cloud_settings['branch_name'];
      preference.password = _cloud_settings['password'];
    } catch (e) {
      print(e.toString());
    }
    try {
      Map<String, dynamic> _currencySetting = jsonDecode(map['currency_setting']);
      preference.smallestCurrency = _currencySetting['smallestCurrency'];
      preference.roundType = _currencySetting['roundType'];
    } catch (e) {
      print(e.toString());
    }

    try {
      Map<String, dynamic> _frontOfficeSetting = jsonDecode(map['front_office_setting']);
      preference.dontAllowSaleWhenCountDownIsZero = _frontOfficeSetting['dontAllowSaleWhenCountDownIsZero'];
      preference.hideVoidedItem = _frontOfficeSetting['hideVoidedItem'];
      preference.voidedItemNeedExplantion = _frontOfficeSetting['voidedItemNeedExplantion'];
      preference.printTicketWhenSent = _frontOfficeSetting['printTicketWhenSent'];
      preference.maxRef = _frontOfficeSetting['maxRef'];
      preference.disableHalfItem = _frontOfficeSetting['disableHalfItem'];
      preference.onlyOneCashierPerTerminal = _frontOfficeSetting['onlyOneCashierPerTerminal'];
      preference.numberOfPrintTicketWhenSent = _frontOfficeSetting['numberOfPrintTicketWhenSent'];
      preference.printRestaurantName = _frontOfficeSetting['printRestaurantName'];
      preference.printTicketWhenSettle = _frontOfficeSetting['printTicketWhenSettle'];
      preference.printModPriceOnTicket = _frontOfficeSetting['printModPriceOnTicket'];
      preference.printRecipetNameAsSeconderyName = _frontOfficeSetting['printRecipetNameAsSeconderyName'];
    } catch (e) {
      print(e.toString());
    }

    preference.day_start = (map['day_start'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['day_start']));

    try {
      preference.address_format = map['address_format'];
      String address_format = preference.address_format;
      bool addressFormatEnabled(String address_name) {
        if (address_format != null) {
          return address_format.contains(address_name);
        } else {
          return false;
        }
      }

      bool addressFormatRequired(String address_name) {
        if (address_format != null && address_format != "" && address_format.contains(address_name)) {
          var list = [];
          List<String> addressListTemp = address_format.split(";");
          for (var i = 0; i < addressListTemp.length; i++) {
            list = addressListTemp[i].split(',');
            if (list.length > 0) {
              if (list[0].toLowerCase() == address_name.toLowerCase()) {
                return list[1] == "1" ? true : false;
              }
            } else
              return false;
          }
        } else
          return false;

        return false;
      }

      preference.address_format = map['address_format'];
      preference.flat = addressFormatEnabled("Flat");
      preference.building = addressFormatEnabled("Building");
      preference.house = addressFormatEnabled("House");
      preference.road = addressFormatEnabled("Road");
      preference.street = addressFormatEnabled("Street");
      preference.block = addressFormatEnabled("Block");
      preference.zipCode = addressFormatEnabled("ZipCode");
      preference.city = addressFormatEnabled("City");
      preference.state = addressFormatEnabled("State");
      preference.postalCode = addressFormatEnabled("PostalCode");
      preference.line1 = addressFormatEnabled("Line1");
      preference.line2 = addressFormatEnabled("Line2");
      preference.flat_required = addressFormatRequired("Flat");
      preference.building_required = addressFormatRequired("Building");
      preference.house_required = addressFormatRequired("House");
      preference.road_required = addressFormatRequired("Road");
      preference.street_required = addressFormatRequired("Street");
      preference.block_required = addressFormatRequired("Block");
      preference.zipCode_required = addressFormatRequired("ZipCode");
      preference.city_required = addressFormatRequired("City");
      preference.state_required = addressFormatRequired("State");
      preference.postalCode_required = addressFormatRequired("PostalCode");
      preference.line1_required = addressFormatRequired("Line1");
      preference.line2_required = addressFormatRequired("Line2");
    } catch (e) {
      print(e.toString());
    }

    preference.id = map['id'];
    preference.restaurantName = map['resturant_name'];
    preference.restaurantLogo = map['logo'];
    preference.tax1 = map['tax1'] ?? 0.0;
    preference.tax2 = map['tax2'] ?? 0.0;
    preference.tax3 = map['tax3'] ?? 0.0;
    preference.tax2_tax1 = (map['tax2_tax1'] == 1) ? true : false;
    preference.tax1_name = map['tax1_name'] ?? "";
    preference.tax2_name = map['tax2_name'] ?? "";
    preference.tax3_name = map['tax3_name'] ?? "";
    preference.currency_setting = map['currency_setting'];
    preference.front_office_setting = map['front_office_setting'];
    // address_format = map['address_format'];
    preference.mod_filter_setting = map['mod_filter_setting'];
    preference.update_time = ((map['update_time'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['update_time']) : null);

    //main_terminal_ip = map['main_terminal_ip'];

    return preference;
  }

  Uint8List? get imageByte {
    if (restaurantLogo == null) {
      return null;
    }
    return base64.decode(restaurantLogo!);
  }

  String? get tax1Alias {
    if (tax1_name.isNotEmpty) {
      return tax1_name;
    } else {
      return "Tax 1";
    }
  }

  String? get tax2Alias {
    if (tax2_name.isNotEmpty) {
      return tax2_name;
    } else {
      return "Tax 2";
    }
  }

  String? get tax3Alias {
    if (tax3_name.isNotEmpty) {
      return tax3_name;
    } else {
      return "Tax Collected";
    }
  }

  String? get dayStartTxt {
    if (day_start != null) {
      return Misc.toShortTime(day_start!);
    } else {
      return "";
    }
  }

  String getRestaurantInfo(int index) {
    if (resturant_info == null) return "";
    List<String> feature = resturant_info.split(',');

    try {
      if (feature.length > index) {
        return feature[index];
      }
      return "";
    } catch (Exception) {
      return "";
    }
  }

  setRestaurantInfo(int index, var value) {
    if (resturant_info == null) return "";
    List<String> feature = resturant_info.split(',');
    String _setting = value.toString().replaceAll(",", "");
    try {
      if (index > feature.length - 1 || feature.length < 8) {
        List<String> arr = [];
        for (int i = 0; i <= feature.length - 1; i++) {
          arr[i] = feature[i];
        }
        feature = arr;
      }
      feature[index] = _setting.toString();

      String temp = "";
      for (var item in feature) {
        if (item != null)
          temp += item.toString() + ",";
        else
          temp += ",";
      }
      resturant_info = temp;
    } catch (Exception) {
      return "";
    }
  }

  String server = "";
  String restSlug = "";
  String branch_name = "";
  String password = "";

  String address1 = "";
  String address2 = "";
  String phone = "";
  String fax = "";
  String url = "";

  String getFrontOfficeSetting(int index) {
    if (front_office_setting == null) return "0";
    List<String> feature = front_office_setting.split(',');
    try {
      if (feature.length > index) {
        return feature[index];
      }
      return "0";
    } catch (Exception) {
      return "0";
    }
  }

  String setFrontOfficeSetting(int index, var value) {
    if (front_office_setting == "") front_office_setting = "0,0,1,1,1,1,1,0,99,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0";

    List<String> feature = front_office_setting.split(',');
    String _setting = value.toString().replaceAll(",", "");
    try {
      if (index > feature.length - 1 || feature.length < 36) {
        List<String> arr = [];
        for (int i = 0; i <= feature.length - 1; i++) {
          arr[i] = feature[i];
        }
        feature = arr;
      }
      feature[index] = _setting.toString();

      String temp = "";
      for (var item in feature) {
        if (item != null)
          temp += item.toString() + ",";
        else
          temp += ",";
      }
      front_office_setting = temp;

      return "1";
    } catch (Exception) {
      return "0";
    }
  }

  // bool get dontAllowSaleWhenCountDownIsZero {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(0));
  // }

  // set dontAllowSaleWhenCountDownIsZero(value) {
  //   setFrontOfficeSetting(0, Misc.convertToBoolean(value));
  // }

  bool dontAllowSaleWhenCountDownIsZero = false;
  bool hideVoidedItem = false;
  bool voidedItemNeedExplantion = false;
  bool printTicketWhenSent = false;
  bool taxTitle = false;
  int maxRef = 99;
  bool disableHalfItem = false;
  bool onlyOneCashierPerTerminal = true;
  int numberOfPrintTicketWhenSent = 1;
  bool printTicketWhenSettle = false;

  // bool get hideVoidedItem {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(1));
  // }

  // set hideVoidedItem(value) {
  //   setFrontOfficeSetting(1, Misc.convertToBoolean(value));
  // }

  // bool get voidedItemNeedExplantion {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(2));
  // }

  // set voidedItemNeedExplantion(value) {
  //   setFrontOfficeSetting(2, Misc.convertToBoolean(value));
  // }

  // bool get printTicketWhenSent {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(3));
  // }

  // set printTicketWhenSent(value) {
  //   setFrontOfficeSetting(3, Misc.convertToBoolean(value));
  // }

  // int get maxRef {
  //   return int.tryParse(getFrontOfficeSetting(3));
  // }

  // set maxRef(value) {
  //   setFrontOfficeSetting(3, value);
  // }

  // bool get disableHalfItem {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(16));
  // }

  // set disableHalfItem(value) {
  //   setFrontOfficeSetting(16, Misc.convertToBoolean(value));
  // }

  // bool get onlyOneCashierPerTerminal {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(19));
  // }

  // set onlyOneCashierPerTerminal(value) {
  //   setFrontOfficeSetting(19, Misc.convertToBoolean(value));
  // }

  // int get numberOfPrintTicketWhenSent {
  //   return int.parse(getFrontOfficeSetting(4));
  // }

  // set numberOfPrintTicketWhenSent(value) {
  //   setFrontOfficeSetting(4, Misc.convertToBoolean(value));
  // }

  bool? taxInvoiceTitle;
  bool? printRestaurantName = false;
  bool? hideOrderNoInPrinting;
  bool? printRecipetNameAsSeconderyName = false;
  bool? groupSimilarItemsInReceipt;
  bool? printModPriceOnTicket = false;

  // bool get taxInvoiceTitle {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(31));
  // }

  // bool get printRestaurantName {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(23));
  // }

  // bool get hideOrderNoInPrinting {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(17));
  // }

  // bool get printRecipetNameAsSeconderyName {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(20));
  // }

  // bool get groupSimilarItemsInReceipt {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(34));
  // }

  // bool get printModPriceOnTicket {
  //   return Misc.convertToBoolean(getFrontOfficeSetting(12));
  // }

  String? getCurrencySetting(int index) {
    if (currency_setting == null) return "0";
    List<String> feature = currency_setting.split(',');
    try {
      return feature[index];
    } catch (Exception) {
      return "0";
    }
  }

  String? setCurrencySetting(int index, var value) {
    currency_setting;
    List<String> feature = currency_setting.split(',');
    String _setting = value.toString().replaceAll(",", "");
    try {
      if (index > feature.length - 1 || feature.length < 2) {
        List<String> arr = [];
        for (int i = 0; i <= feature.length - 1; i++) {
          arr[i] = feature[i];
        }
        feature = arr;
      }
      feature[index] = _setting.toString();

      String temp = "";
      for (var item in feature) {
        if (item != null)
          temp += item.toString() + ",";
        else
          temp += ",";
      }
      currency_setting = temp;
    } catch (Exception) {
      return "";
    }
  }

  double? smallestCurrency = 0.0;
  int? roundType = 1;
  // double get smallestCurrency {
  //   return double.parse(getCurrencySetting(0));
  // }

  // set smallestCurrency(value) {
  //   return setCurrencySetting(0, double.parse(value.toString()));
  // }

  // int get roundType {
  //   int temp = int.tryParse(getCurrencySetting(1));
  //   if (temp == null) {
  //     return 0;
  //   }
  //   return temp;
  // }

  // set roundType(value) {
  //   return setCurrencySetting(1, double.parse(value));
  // }

  bool? flat = false;
  bool? building = false;
  bool? house = false;
  bool? road = false;
  bool? street = false;
  bool? block = false;
  bool? zipCode = false;
  bool? city = false;
  bool? state = false;
  bool? postalCode = false;
  bool? line1 = false;
  bool? line2 = false;
  bool? flat_required = false;
  bool? building_required = false;
  bool? house_required = false;
  bool? road_required = false;
  bool? street_required = false;
  bool? block_required = false;
  bool? zipCode_required = false;
  bool? city_required = false;
  bool? state_required = false;
  bool? postalCode_required = false;
  bool? line1_required = false;
  bool? line2_required = false;

  // String? getAddressFormat(int index) {
  //   if (address_format == null) return "0";
  //   List<String> feature = address_format!.split(',');
  //   try {
  //     if (feature.length > index) {
  //       return feature[index];
  //     }
  //     return "0";
  //   } catch (Exception) {
  //     return "0";
  //   }
  // }

  // String? setAddressFormat(int index, var value) {
  //   if (address_format == null) address_format = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
  //   List<String> feature = address_format!.split(',');
  //   String _setting = value.toString().replaceAll(",", "");
  //   try {
  //     if (index > feature.length - 1 || feature.length < 24) {
  //       List<String> arr = [];
  //       for (int i = 0; i <= feature.length - 1; i++) {
  //         arr[i] = feature[i];
  //       }
  //       feature = arr;
  //     }
  //     feature[index] = _setting.toString();

  //     String temp = "";
  //     for (var item in feature) {
  //       if (item != null)
  //         temp += item.toString() + ",";
  //       else
  //         temp += ",";
  //     }
  //     address_format = temp;
  //   } catch (Exception) {
  //     return "";
  //   }
  // }
}
