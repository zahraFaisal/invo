

import 'package:invo_mobile/models/menu_modifier.dart';

abstract class ModifierLoadState {}

class ModifierIsLoading extends ModifierLoadState {}

class  ModifierIsLoaded extends ModifierLoadState {
  final  MenuModifier modifier;
 ModifierIsLoaded(this.modifier);
}
