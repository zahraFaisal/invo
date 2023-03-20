import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:json_annotation/json_annotation.dart';

import '../menu_item.dart';

part 'menu_modifier_reference.g.dart';

@JsonSerializable()
class MenuModifierReference {
  int id;
  String name;
  String? display_name;
  String? secondary_display_name;

  get display {
    if ((display_name == null || display_name == "")) {
      return name;
    } else {
      return display_name;
    }
  }

  MenuModifierReference({this.id = 0, this.name = "", this.display_name = "", this.secondary_display_name = ""});

  factory MenuModifierReference.fromMenuModifier(MenuModifier item) {
    return MenuModifierReference(id: item.id, name: item.name, display_name: item.display_name, secondary_display_name: item.secondary_display_name);
  }

  Map<String, dynamic> toJson() => _$MenuModifierReferenceToJson(this);

  factory MenuModifierReference.fromJson(Map<String, dynamic> json) => _$MenuModifierReferenceFromJson(json);
}
