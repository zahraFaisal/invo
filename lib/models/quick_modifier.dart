import 'package:invo_mobile/models/menu_modifier.dart';

import 'custom/menu_modifier_list.dart';

class QuickModifier {
  int id;
  int modifier_id;
  int menu_item_id;
  ModifierList? modifier;

  QuickModifier({this.id = 0, this.modifier, this.modifier_id = 0, this.menu_item_id = 0});

  factory QuickModifier.fromJson(Map<String, dynamic> json) {
    return QuickModifier(id: json['id'] ?? 0, modifier_id: json['modifier_id'] ?? 0);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id == 0 ? null : id,
      'modifier_id': modifier_id,
      'menu_item_id': menu_item_id,
    };
    return map;
  }

  Map<String, dynamic> toMapRequest() {
    Map<String, dynamic>? _modifier = this.modifier != null ? this.modifier!.toMap() : null;
    var map = <String, dynamic>{'id': id == 0 ? null : id, 'modifier_id': modifier_id, 'menu_item_id': menu_item_id, 'modifier': _modifier};
    return map;
  }

  factory QuickModifier.fromMap(Map<String, dynamic> map) {
    QuickModifier quickModifier = QuickModifier();
    quickModifier.id = map['id'];
    quickModifier.modifier_id = map['modifier_id'];
    quickModifier.menu_item_id = map['menu_item_id'];
    return quickModifier;
  }
}
