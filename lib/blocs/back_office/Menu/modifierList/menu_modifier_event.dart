import 'package:invo_mobile/models/menu_modifier.dart';

abstract class MenuModifierListEvent {}

class LoadModifier extends MenuModifierListEvent {}

class DeleteModifier extends MenuModifierListEvent {
 
  MenuModifier modifier;
  DeleteModifier(this.modifier);
}