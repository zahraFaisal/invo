import 'dart:convert';

import 'package:invo_mobile/helpers/misc.dart';
import 'package:json_annotation/json_annotation.dart';

class Service {
  String? alternative;
  String features = "";
  int id;
  String name;
  bool? in_active = false;
  int? price_id = 0;
  int? surcharge_id = 0;

  Service({this.alternative, this.features = "", required this.id, required this.name, this.in_active, this.price_id, this.surcharge_id}) {}

  factory Service.fromJson(Map<String, dynamic> json) {
    Service service = Service(id: json["id"] ?? 0, name: json["name"] ?? "");
    service.alternative = json["alternative"] ?? "";
    service.features = json["features"] ?? "";
    service.in_active = json.containsKey('in_active') ? json["in_active"] : false;
    service.price_id = json["price_id"] ?? 0;
    service.surcharge_id = json["surcharge_id"] ?? 0;

    if (service.id == 1) {
      service.showTableSelection = service.get_feature(0);
      service.allowOneTicketPerTable = service.get_feature(1);
      service.showCustomerCount = service.get_feature(2);
      service.showCustomerReservationInfo = service.get_feature(4);
    } else if (service.id == 4) {
      String x = service.getDeliveryfeature(3);
      service.deliveryCharge = double.parse(x);
    }

    return service;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> _feature = {};
    if (id == 1) {
      _feature = {
        'showTableSelection': showTableSelection,
        'allowOneTicketPerTable': allowOneTicketPerTable,
        'showCustomerCount': showCustomerCount,
        'showCustomerReservationInfo': showCustomerReservationInfo,
      };
    } else if (id == 4) {
      _feature = {
        'deliveryCharge': deliveryCharge,
      };
    }

    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'alternative': alternative,
      'features': jsonEncode(_feature),
      'in_active': in_active == true ? 1 : 0,
      'price_id': price_id,
      'surcharge_id': surcharge_id,
    };
    return map;
  }

  Map<String, dynamic> toUpdateMap() {
    Map<String, dynamic> _feature = Map<String, dynamic>();
    if (id == 1) {
      _feature = {
        'showTableSelection': showTableSelection,
        'allowOneTicketPerTable': allowOneTicketPerTable,
        'showCustomerCount': showCustomerCount,
        'showCustomerReservationInfo': showCustomerReservationInfo,
      };
    } else if (id == 4) {
      _feature = {
        'deliveryCharge': deliveryCharge,
      };
    }

    var map = <String, dynamic>{
      'name': name,
      'alternative': alternative,
      'features': jsonEncode(_feature),
      'in_active': in_active == true ? 1 : 0,
      'price_id': price_id,
      'surcharge_id': surcharge_id,
    };
    return map;
  }

  factory Service.fromMap(Map<String, dynamic> json) {
    Service service = Service(id: json["id"], name: json["name"]);
    service.alternative = json["alternative"];
    service.features = json["features"];
    service.in_active = (json['in_active'] == 1) ? true : false;
    service.price_id = json["price_id"];
    service.surcharge_id = json["surcharge_id"];

    try {
      Map<String, dynamic> _features = jsonDecode(json['features']);
      if (service.id == 1) {
        service.showTableSelection = _features['showTableSelection'];
        service.allowOneTicketPerTable = _features['allowOneTicketPerTable'];
        service.showCustomerCount = _features['showCustomerCount'];
        service.showCustomerReservationInfo = _features['showCustomerReservationInfo'];
      } else if (service.id == 4) {
        service.deliveryCharge = _features['deliveryCharge'];
      }
    } catch (e) {
      print(e.toString());
    }

    return service;
  }

  String? get display_name {
    if (alternative != null) {
      return alternative;
    } else
      return name;
  }

  bool get_feature(int pos) {
    bool isAvailable = false;
    List<String> temp;
    if (this.features != null) {
      temp = features.split(",");
      isAvailable = Misc.convertToBoolean(temp[pos]);
    }
    return isAvailable;
  }

  setDineInFeature(int index, String value) {
    if (features == null || features == "") features = ",,,,";
    List<String> s = features.split(',');
    List<String> arr = [];
    for (int i = 0; i <= s.length - 1; i++) {
      arr[i] = s[i];
    }
    s = arr;

    s[index] = value;
    features = "";
    for (var item in s) {
      features += item + ",";
    }
    features = features.substring(0, features.length - 1);
  }

  setDeliveryFeature(int index, String value) {
    if (features == null || features == "") features = ",,,";
    List<String> s = features.split(',');
    List<String> arr = [];
    for (int i = 0; i <= s.length - 1; i++) {
      arr[i] = s[i];
    }
    s = arr;

    s[index] = value;
    features = "";
    for (var item in s) {
      features += item + ",";
    }
    features = features.substring(0, features.length - 1);
  }

  String getDeliveryfeature(int pos) {
    List<String> temp;
    if (this.features != null && this.features != "") {
      temp = features.split(",");
      return temp[pos];
    } else {
      return "0";
    }
  }

  double deliveryCharge = 0;

  bool showTableSelection = true; // 0
  bool allowOneTicketPerTable = false; //1
  bool showCustomerCount = false; //2
  bool showCustomerReservationInfo = false; //4

  // double deliveryCharge() {
  //   String x = getDeliveryfeature(3);
  //   return double.parse(x);
  // }

  // set setDeliveryCharge(double value) {
  //   setDeliveryFeature(3, value.toString());
  // }

  // bool showTableSelection() {
  //   return get_feature(0);
  // }

  // set setShowTableSelection(bool value) {
  //   setDineInFeature(0, value.toString());
  // }

  // bool allowOneTicketPerTable() {
  //   return get_feature(1);
  // }

  // set setAllowOneTicketPerTable(bool value) {
  //   setDineInFeature(1, value.toString());
  // }

  // bool showCustomerCount() {
  //   return get_feature(2);
  // }

  // set setShowCustomerCount(bool value) {
  //   setDineInFeature(2, value.toString());
  // }

  // bool showCustomerReservationInfo() {
  //   return get_feature(4);
  // }
}
