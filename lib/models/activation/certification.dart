import 'package:invo_mobile/models/activation/restaurant.dart';

import './customer.dart';

class Certification {
  String HWID;
  String HardDiskID;
  String? licence; //demo not send
  int country_id;
  DateTime? expire_at;
  int KDSApp;
  int MobileApp;
  int MenuApp;
  int QueueApp;
  Restaurant? restaurant;
  int type;
  Certification(
      {this.HWID = "",
      this.HardDiskID = "",
      this.KDSApp = 0,
      this.MenuApp = 0,
      this.MobileApp = 0,
      this.QueueApp = 0,
      this.country_id = 0,
      this.expire_at,
      this.licence,
      this.type = 0});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'HWID': HWID,
      'HardDiskID': HardDiskID,
      'KDSApp': KDSApp,
      'MenuApp': MenuApp,
      'MobileApp': MobileApp,
      'QueueApp': QueueApp,
      'country_id': country_id,
      'expire_at': expire_at,
      'licence': licence,
      'type': type,
      'restaurant': restaurant?.toMap()
    };
    return map;
  }

  factory Certification.fromMap(Map<String, dynamic> map) {
    Certification certification = Certification();
    certification.HWID = map['HWID'];
    certification.HardDiskID = map['HardDiskID'];
    certification.KDSApp = map['KDSApp'];
    certification.MenuApp = map['MenuApp'];
    certification.MobileApp = map['MobileApp'];
    certification.country_id = map['country_id'];
    certification.expire_at = map['expire_at'] != null ? DateTime.parse(map['expire_at']) : null;
    certification.licence = map['licence'];
    certification.type = map['type'];
    certification.restaurant = Restaurant.fromMap(map['restaurant']);
    return certification;
  }
}
