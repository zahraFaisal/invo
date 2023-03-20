import 'package:invo_mobile/helpers/misc.dart';

class PriceManagement {
  int id;
  String title;
  int repeat;
  int price_label_id;
  int discount_id;
  int surcharge_id;
  DateTime? from_date;
  DateTime? to_date;

  DateTime? from_time;
  DateTime? to_time;

  bool saturday;
  bool sunday;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;

  String services;

  PriceManagement(
      {this.id = 0,
      this.title = "",
      this.repeat = 0,
      this.price_label_id = 0,
      this.discount_id = 0,
      this.surcharge_id = 0,
      this.from_date,
      this.to_date,
      this.from_time,
      this.to_time,
      this.services = "1;1;1;1",
      this.saturday = false,
      this.sunday = false,
      this.monday = false,
      this.tuesday = false,
      this.wednesday = false,
      this.thursday = false,
      this.friday = false});

  DateTime getDate(String date) {
    // DateTime temp;
    DateTime temp = DateTime.now();

    if (date != null) {
      if (date.contains("+")) {
        temp = DateTime.fromMillisecondsSinceEpoch(int.parse(date.substring(6, date.length - 7)));
      } else {
        temp = DateTime.fromMillisecondsSinceEpoch(int.parse(date.substring(6, date.length - 2)));
      }
    }

    return temp;
  }

  factory PriceManagement.fromJson(Map<String, dynamic> json) {
    DateTime _fromDate;
    if (json['from_date'].contains("+")) {
      _fromDate = DateTime.fromMillisecondsSinceEpoch(int.parse(json['from_date'].substring(6, json['from_date'].length - 7)));
    } else {
      _fromDate = DateTime.fromMillisecondsSinceEpoch(int.parse(json['from_date'].substring(6, json['from_date'].length - 2)));
    }

    DateTime _toDate;
    if (json['to_date'].contains("+")) {
      _toDate = DateTime.fromMillisecondsSinceEpoch(int.parse(json['to_date'].substring(6, json['to_date'].length - 7)));
    } else {
      _toDate = DateTime.fromMillisecondsSinceEpoch(int.parse(json['to_date'].substring(6, json['to_date'].length - 2)));
    }

    DateTime _fromTime;
    if (json['from_time'].contains("+")) {
      _fromTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['from_time'].substring(6, json['from_time'].length - 7)));
    } else {
      _fromTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['from_time'].substring(6, json['from_time'].length - 2)));
    }

    DateTime _toTime;
    if (json['to_time'].contains("+")) {
      _toTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['to_time'].substring(6, json['to_time'].length - 7)));
    } else {
      _toTime = DateTime.fromMillisecondsSinceEpoch(int.parse(json['to_time'].substring(6, json['to_time'].length - 2)));
    }

    String _services = "0;0;0;0;0;0";
    List<String> feature = _services.split(';');
    List<String> array = [];
    for (var i = 0; i < feature.length; i++) {
      // array[i] = feature[i];
      array.add(feature[i]);
    }
    array[0] = (json['DineIn'] != null && json['DineIn'] == true) ? "1" : "0";
    array[1] = (json['TakeAway'] != null && json['TakeAway'] == true) ? "1" : "0";
    array[2] = (json['CarService'] != null && json['CarService'] == true) ? "1" : "0";
    array[3] = (json['Delivery'] != null && json['Delivery'] == true) ? "1" : "0";
    _services = array.join(";");

    return PriceManagement(
        id: json['id'] ?? 0,
        title: json['title'],
        repeat: int.parse(json['repeat'].toString()),
        price_label_id: json['price_label_id'] == null ? 0 : int.parse(json['price_label_id'].toString()),
        discount_id: json['discount_id'] == null ? 0 : int.parse(json['discount_id'].toString()),
        surcharge_id: json['surcharge_id'] == null ? 0 : int.parse(json['surcharge_id'].toString()),
        from_date: _fromDate,
        to_date: _toDate,
        from_time: _fromTime,
        to_time: _toTime,
        saturday: json['saturday'] ?? false,
        sunday: json['sunday'] ?? false,
        monday: json['monday'] ?? false,
        tuesday: json['tuesday'] ?? false,
        wednesday: json['wednesday'] ?? false,
        thursday: json['thursday'] ?? false,
        friday: json['friday'] ?? false,
        services: _services);
  }

  String get fromDateText {
    return Misc.toShortDate(from_date);
  }

  String get toDateText {
    return Misc.toShortDate(to_date);
  }

  String get fromTimeText {
    return Misc.toShortTime(from_time);
  }

  String get toTimeText {
    return Misc.toShortTime(to_time);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'title': title,
      'repeat': repeat,
      'price_label_id': price_label_id,
      'discount_id': discount_id,
      'surcharge_id': surcharge_id,
      'from_date': (from_date!.toUtc().millisecondsSinceEpoch == null) ? null : from_date!.toUtc().millisecondsSinceEpoch,
      'to_date': (to_date!.toUtc().millisecondsSinceEpoch == null) ? null : to_date!.toUtc().millisecondsSinceEpoch,
      'from_time': (from_time!.toUtc().millisecondsSinceEpoch == null) ? null : from_time!.toUtc().millisecondsSinceEpoch,
      'to_time': (to_time!.toUtc().millisecondsSinceEpoch == null) ? null : to_time!.toUtc().millisecondsSinceEpoch,
      'saturday': saturday,
      'sunday': sunday,
      'monday': monday,
      'Monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'services': services,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'title': title,
      'repeat': repeat,
      'price_label_id': price_label_id,
      'discount_id': discount_id,
      'surcharge_id': surcharge_id,
      'from_date': (from_date == null) ? null : "/Date(" + (from_date!.millisecondsSinceEpoch).toString() + ")/",
      'to_date': (to_date == null) ? null : "/Date(" + (to_date!.millisecondsSinceEpoch).toString() + ")/",
      'from_time': (from_time == null) ? null : "/Date(" + (from_time!.millisecondsSinceEpoch).toString() + ")/",
      'to_time': (to_time == null) ? null : "/Date(" + (to_time!.millisecondsSinceEpoch).toString() + ")/",
      'saturday': saturday,
      'sunday': sunday,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'services': services,
      'DineIn': dineIn,
      'CarService': carService,
      'TakeAway': takeAway,
      'Delivery': delivery
    };
    return map;
  }

  factory PriceManagement.fromMap(Map<String, dynamic> map) {
    PriceManagement priceManagement = PriceManagement();
    priceManagement.id = map['id'] ?? 0;
    priceManagement.title = map['title'];
    priceManagement.repeat = map['repeat'];
    priceManagement.price_label_id = map['price_label_id'];
    priceManagement.discount_id = map['discount_id'];
    priceManagement.surcharge_id = map['surcharge_id'];
    priceManagement.from_date = (map['from_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['from_date'], isUtc: true).toLocal())!;
    priceManagement.to_date = (map['to_date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['to_date'], isUtc: true).toLocal())!;
    priceManagement.from_time = (map['from_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['from_time'], isUtc: true).toLocal())!;
    priceManagement.to_time = (map['to_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['to_time'], isUtc: true).toLocal())!;
    priceManagement.saturday = (map['saturday'] == 1) ? true : false;
    priceManagement.sunday = (map['sunday'] == 1) ? true : false;
    priceManagement.monday = (map['monday'] == 1 || map['Monday'] == 1) ? true : false;
    priceManagement.tuesday = (map['tuesday'] == 1) ? true : false;
    priceManagement.wednesday = (map['wednesday'] == 1) ? true : false;
    priceManagement.thursday = (map['thursday'] == 1) ? true : false;
    priceManagement.friday = (map['friday'] == 1) ? true : false;
    priceManagement.services = map['services'];
    return priceManagement;
  }
  void setStartDate(DateTime date) {
    from_date = date;
  }

  void setEndDate(DateTime date) {
    to_date = date;
  }

  void setStartTime(DateTime time) {
    from_date = time;
  }

  void setEndTime(DateTime time) {
    to_date = time;
  }

  getServices(int index) {
    if (services == null) return "0";
    List<String> feature = services.split(';');
    if (index > feature.length - 1) {
      return "0";
    }
    return feature[index];
  }

  setServices(int index, bool value) {
    if (services == null) services = "0;0;0;0;0;0";
    List<String> feature = services.split(';');
    List<String> array = [];

    for (var i = 0; i < feature.length; i++) {
      array[i] = feature[i];
    }

    array[index] = value ? "1" : "0";
    services = array.join(";");
  }

  set dineIn(bool value) {
    setServices(0, value);
  }

  bool get dineIn {
    return convertToBoolean(getServices(0));
  }

  set takeAway(bool value) {
    setServices(1, value);
  }

  bool get takeAway {
    return convertToBoolean(getServices(1));
  }

  set carService(bool value) {
    setServices(2, value);
  }

  bool get carService {
    return convertToBoolean(getServices(2));
  }

  set delivery(bool value) {
    setServices(3, value);
  }

  bool get delivery {
    return convertToBoolean(getServices(3));
  }

  set retail(bool value) {
    setServices(4, value);
  }

  bool get retail {
    return convertToBoolean(getServices(4));
  }

  set catering(bool value) {
    setServices(5, value);
  }

  bool get catering {
    return convertToBoolean(getServices(5));
  }

  bool convertToBoolean(x) {
    if (x.toString() == "-1" || x.toString() == "True" || x.toString() == "1")
      return true;
    else
      return false;
  }
}
