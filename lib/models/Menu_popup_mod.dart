import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_modifier.dart';

class MenuPopupMod {
  int id;
  int menu_item_id;
  int level = 1;
  bool is_forced = false;
  bool online = true;

  String description;
  String secondary_description;
  bool local = false;

  int repeat = 1;
  List<LevelModifier> modifiers;

  bool Is_Deleted = false;
  MenuPopupMod(
      {this.id = 0,
      this.menu_item_id = 0,
      this.level = 1,
      this.is_forced = false,
      this.online = true,
      this.description = "",
      this.Is_Deleted = false,
      this.repeat = 1,
      this.secondary_description = "",
      required this.modifiers,
      this.local = false}) {
    // TODO: implement
    // throw UnimplementedError();
  }

  factory MenuPopupMod.fromJson(Map<String, dynamic> json) {
    List<LevelModifier> modifiers = List<LevelModifier>.empty(growable: true);
    for (var item in json['modifiers']) {
      modifiers.add(LevelModifier.fromJson(item));
    }

    int repeat;
    if (json['repeat'] == null) {
      repeat = 1;
    } else {
      repeat = (json['repeat'] is num) ? json['repeat'] * 1 : int.parse(json['repeat']);
    }

    // int repeat =
    //     json['repeat'] == null ? 1 : int.parse(json['repeat'].toString());
    int id = (json['id'] == null) ? 0 : json['id'];

    bool isForced = (json['is_forced'] == null) ? false : json['is_forced'];
    bool _online = (json['online'] == null) ? false : json['online'];

    return MenuPopupMod(
      id: json['id'] ?? 0,
      menu_item_id: json['menu_item_id'] ?? 0,
      level: json['level'] ?? 1,
      secondary_description: json['secondary_description'] ?? "",
      description: json['description'] ?? "",
      Is_Deleted: json['Is_Deleted'] == null ? false : json['Is_Deleted'],
      is_forced: isForced,
      online: _online,
      repeat: repeat,
      modifiers: modifiers,
      local: json['local'] == null ? false : json['local'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id == 0 ? null : id,
      "menu_item_id": menu_item_id,
      "level": level,
      "description": description,
      "is_forced": is_forced,
      "online": online,
      "repeat": repeat,
      "Is_Deleted": Is_Deleted == null ? false : Is_Deleted,
      "local": local,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    List<Map<String, dynamic>>? _modifiers = this.modifiers != null ? this.modifiers.map((i) => i.toMapRequest()).toList() : null;
    var map = <String, dynamic>{
      "id": id == 0 ? null : id,
      "menu_item_id": menu_item_id,
      "level": level,
      "description": description,
      "is_forced": is_forced,
      "online": online,
      "repeat": repeat,
      "Is_Deleted": Is_Deleted == null ? false : Is_Deleted,
      "local": local,
      'modifiers': _modifiers
    };
    return map;
  }

  factory MenuPopupMod.fromMap(Map<String, dynamic> map) {
    List<LevelModifier> _modifiers = List<LevelModifier>.empty(growable: true);
    for (var item in map['modifiers']) {
      _modifiers.add(LevelModifier.fromJson(item));
    }
    MenuPopupMod menuPopupMod = MenuPopupMod(modifiers: _modifiers);
    menuPopupMod.id = map['id'];
    menuPopupMod.menu_item_id = map['menu_item_id'];
    menuPopupMod.level = map['level'];
    menuPopupMod.description = map['description'];
    menuPopupMod.is_forced = map['is_forced'];
    menuPopupMod.online = map['online'];
    menuPopupMod.Is_Deleted = map['Is_Deleted'] ?? false;
    menuPopupMod.repeat = map['repeat'];
    menuPopupMod.local = map['local'];

    return menuPopupMod;
  }
}

class LevelModifier {
  int id;
  int modifier_id;
  MenuModifier? modifier;
  int menu_popup_mod_id;
  bool selected;

  bool Is_Deleted = false;

  LevelModifier({this.id = 0, this.modifier_id = 0, this.menu_popup_mod_id = 0, this.modifier, this.Is_Deleted = false, this.selected = false});

  factory LevelModifier.fromJson(Map<String, dynamic> json) {
    return LevelModifier(
      id: json['id'] ?? 0,
      modifier_id: json['modifier_id'],
      Is_Deleted: json['Is_Deleted'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "id": id,
      "modifier_id": modifier_id,
      "Is_Deleted": Is_Deleted == null ? false : Is_Deleted,
      "menu_popup_mod_id": menu_popup_mod_id,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    Map<String, dynamic>? _modifier = this.modifier != null ? this.modifier!.toMap() : null;
    var map = <String, dynamic>{
      "id": id,
      "modifier_id": modifier_id,
      "Is_Deleted": Is_Deleted == null ? false : Is_Deleted,
      "menu_popup_mod_id": menu_popup_mod_id,
      'modifier': _modifier
    };
    return map;
  }

  factory LevelModifier.fromMap(Map<String, dynamic> map) {
    MenuModifier _modifier = new MenuModifier();
    if (map.containsKey('modifier') && map['modifier'] != null) {
      _modifier = MenuModifier.fromJson(map['modifier']);
    }
    LevelModifier levelModifier = LevelModifier();

    levelModifier.id = map['id'];
    levelModifier.Is_Deleted = map['Is_Deleted'] == null ? false : map['Is_Deleted'];
    levelModifier.modifier_id = map['modifier_id'];
    levelModifier.menu_popup_mod_id = map['menu_popup_mod_id'];
    levelModifier.modifier = _modifier;

    return levelModifier;
  }
}
