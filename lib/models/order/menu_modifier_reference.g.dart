// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_modifier_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuModifierReference _$MenuModifierReferenceFromJson(
    Map<String, dynamic> json) {
  return MenuModifierReference(
      id: json['id'] as int,
      name: json['name'] as String,
      display_name: json['display_name'] as String,
      secondary_display_name: json['secondary_display_name'] as String);
}

Map<String, dynamic> _$MenuModifierReferenceToJson(
        MenuModifierReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.display_name,
      'secondary_display_name': instance.secondary_display_name
    };
