import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SyncData {
  dynamic ChangeCheckerTimer;
  late String branch_token;
  late Map JsonSetting;
  late String server;

  String? databaseGUID;

  late bool hasCallcenter;

  String? deviceId;

  late Map<String, String> headers;
  getDeviceInfo() async {
    try {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.androidId;
      }
    } catch (e) {
      deviceId = "WEB";
    }

    headers = new Map<String, String>();

    headers["DeviceID"] = deviceId!; // this.device.uuid
    headers["Device-Type"] = "1";
    headers["Content-Type"] = "application/json";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("DeviceID", deviceId!);
  }

  syncInvo(String branch_token, String server) {
    if (branch_token.isEmpty || server.isEmpty) {
      return;
    }
    // TODO: Complete member initialization
    this.branch_token = branch_token;
    this.server = server;

    // databaseGUID = Invo.Lib.Data.LocalData.getInstance().preference.GUID;

    //intilize JsonSetting
    JsonSetting = new Map();
    //JsonSetting.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
    //JsonSetting.NullValueHandling = NullValueHandling.Ignore;
    //JsonSetting.DefaultValueHandling = DefaultValueHandling.Ignore;
    //JsonSetting.DateFormatHandling = DateFormatHandling.MicrosoftDateFormat;

    //----
    load();
  }

  void load() async {
    if (await hasCallCenter()) {
      sendMenu();
    }
  }

  Future<bool> hasCallCenter() async {
    if (deviceId == null) await getDeviceInfo();

    Map temp = <String, dynamic>{'token': branch_token, 'JsonSetting': JsonSetting};
    String postData = jsonEncode(temp);

    final response = await http
        .post(Uri.parse("$server/api/check_callcenter"), body: postData, headers: this.headers)
        .timeout(Duration(seconds: 800))
        .catchError((error) {
      print(error);
    });
    if (response.statusCode == 200) {
      var msg = jsonDecode(response.body);
      if (msg['hasCallCenter']) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> sendMenu() async {
    if (ChangeCheckerTimer != null) {
      // ChangeCheckerTimer.Stop();
      ChangeCheckerTimer.cancel();
      ChangeCheckerTimer = null;
    }
    ChangeCheckerTimer = new Timer.periodic(const Duration(seconds: 20), check);
    // ChangeCheckerTimer.Start();
  }

  void check(Timer timer) {
    CheckChanges();
    // print("hii");
  }

  Future<bool> sendMenuTypes(List<MenuType> menuTypes) async {
    List<Map<String, dynamic>>? _menuTypes = menuTypes != null ? menuTypes.map((i) => i.toMap()).toList() : null;
    Map temp = <String, dynamic>{'token': branch_token, 'JsonSetting': JsonSetting, 'items': _menuTypes, 'GUID': databaseGUID};
    String postData = jsonEncode(temp);

    final response = await http
        .post(Uri.parse("$server/api/callcenter/saveMenuTypes"), body: postData, headers: this.headers)
        .timeout(Duration(seconds: 800))
        .catchError((error) {
      print(error);
    });
    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendMenuGroups(List<MenuGroup> menuGroups) async {
    List<Map<String, dynamic>>? _menuGroups = menuGroups != null ? menuGroups.map((i) => i.toMap()).toList() : null;
    Map temp = <String, dynamic>{'token': branch_token, 'JsonSetting': JsonSetting, 'items': _menuGroups, 'GUID': databaseGUID};
    String postData = jsonEncode(temp);

    final response = await http
        .post(Uri.parse("$server/api/callcenter/saveMenuGroups"), body: postData, headers: this.headers)
        .timeout(Duration(seconds: 800))
        .catchError((error) {
      print(error);
    });
    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendMenuModifiers(List<MenuModifier> menuModifiers) async {
    List<Map<String, dynamic>>? _menuModifiers = menuModifiers != null ? menuModifiers.map((i) => i.toMap()).toList() : null;
    Map temp = <String, dynamic>{'token': branch_token, 'JsonSetting': JsonSetting, 'items': _menuModifiers, 'GUID': databaseGUID};
    String postData = jsonEncode(temp);
    final response = await http
        .post(Uri.parse("$server/api/callcenter/saveMenuModifiers"), body: postData, headers: this.headers)
        .timeout(Duration(seconds: 800))
        .catchError((error) {
      print(error);
    });
    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendMenuItems(List<MenuItem> menuItems) async {
    Map temp = <String, dynamic>{
      'token': branch_token,
      'JsonSetting': JsonSetting,
      'items': menuItems.map((i) => i.toMapRequest()).toList(),
      'GUID': databaseGUID
    };

    String postData = jsonEncode(temp);
    final response = await http
        .post(Uri.parse("$server/api/callcenter/saveMenuItems"), body: postData, headers: this.headers)
        .timeout(Duration(seconds: 800))
        .catchError((error) {
      print(error);
    });
    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
    } else {
      return false;
    }
    return true;
    // for (int i = 0; i <= menuItems.length / 2; i++) {
    //   Map temp = <String, dynamic>{
    //     'token': branch_token,
    //     'JsonSetting': JsonSetting,
    //     'items': menuItems.skip(i * 2).take(2).map((i) => i.toMap()).toList(),
    //     'GUID': databaseGUID
    //   };
    //   String postData = jsonEncode(temp);
    //   final response = await http
    //       .post("$server/api/callcenter/saveMenuItems",
    //           body: postData, headers: this.headers)
    //       .timeout(Duration(seconds: 800))
    //       .catchError((error) {
    //     print(error);
    //   });
    //   if (response.statusCode == 200) {
    //     var x = jsonDecode(response.body);
    //   } else {
    //     return false;
    //   }
    // }
    // return true;
  }

  Future<bool> sendMenuItemGroups(List<MenuItemGroup> menuItemGroups) async {
    List<Map<String, dynamic>>? _menuItemGroups = menuItemGroups != null ? menuItemGroups.map((i) => i.toMap()).toList() : null;
    Map temp = <String, dynamic>{'token': branch_token, 'JsonSetting': JsonSetting, 'items': _menuItemGroups, 'GUID': databaseGUID};
    String postData = jsonEncode(temp);

    final response = await http
        .post(Uri.parse("$server/api/callcenter/saveMenuItemGroups"), body: postData, headers: this.headers)
        .timeout(Duration(seconds: 800))
        .catchError((error) {
      print(error);
    });

    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      return true;
    } else {
      return false;
    }
  }

  CheckChanges({sender, e}) async {
    print('check changes');
    // ChangeCheckerTimer.Stop();
    bool flag = true;
    bool flag1 = true;

    //LastUpdateTimeForCloud
    Preference? settingData = await locator.get<ConnectionRepository>().preferenceService!.get();
    DateTime? lastUpdateTime = settingData!.update_time;
    var menuData = locator.get<ConnectionRepository>();
    List<MenuType>? menuTypes = await menuData.menuTypeService!.getUpdatedMenuType(lastUpdateTime);
    if (menuTypes!.isNotEmpty) {
      flag1 = await sendMenuTypes(menuTypes);
      flag &= flag1;
      if (flag1) await menuData.menuTypeService!.UpdateMenuTypeNullUpdateTime();
    }

    List<MenuGroup>? menuGroups = await menuData.menuGroupService!.getUpdatedMenuGroup(lastUpdateTime);
    if (menuGroups!.isNotEmpty) {
      flag1 = await sendMenuGroups(menuGroups);
      flag &= flag1;
      if (flag1) await menuData.menuGroupService!.UpdateMenuGroupNullUpdateTime();
    }

    List<MenuModifier>? menuModifiers = await menuData.menuModifierService!.getUpdatedMenuModifiers(lastUpdateTime);
    if (menuModifiers!.isNotEmpty) {
      flag1 = await sendMenuModifiers(menuModifiers);
      flag &= flag1;
      if (flag1) await menuData.menuModifierService!.UpdateMenuModifierNullUpdateTime();
    }

    List<MenuItem>? menuItems = await menuData.menuItemService!.getUpdatedMenuItems(lastUpdateTime);
    List ids = [];
    menuItems!.forEach((element) {
      print(element.name);
      ids.add(element.id);
    });
    if (menuItems.isNotEmpty) {
      // List images = await menuData.menuItemService.getImages(ids);
      // MenuItem temp = null;
      // for (var item in images) {
      //   temp = menuItems.where((f) => f.id == item.menu_item_id).first;
      //   if (temp != null) {
      //     temp.large_icon = item.image;
      //   }
      // }

      flag1 = await sendMenuItems(menuItems);
      flag &= flag1;
      if (flag1) await menuData.menuItemService!.UpdateMenuItemNullUpdateTime();
    }

    List<MenuItemGroup> menuItemGroups = await menuData.menuItemService!.getUpdatedMenuItemGroups(lastUpdateTime);
    if (menuItemGroups.isNotEmpty) {
      flag1 = await sendMenuItemGroups(menuItemGroups);
      flag &= flag1;
      if (flag1) await menuData.menuItemService!.UpdateMenuItemGroupNullUpdateTime();
    }

    if (flag) {
      settingData.update_time = DateTime.now();
      menuData.preferenceService!.saveLastUpdateTimeForCloud();
    }

    // ChangeCheckerTimer.Start();
  }
}

class CallCenterStatus {
  bool success;
  bool hasCallCenter;
  CallCenterStatus({this.success = false, this.hasCallCenter = false});
}
