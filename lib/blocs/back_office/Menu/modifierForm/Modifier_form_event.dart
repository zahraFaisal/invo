
import 'package:invo_mobile/models/menu_modifier.dart';

abstract class ModifierFormEvent {}

class SaveMenuModifier extends ModifierFormEvent{
  MenuModifier modifier;
  SaveMenuModifier(this.modifier);
} 