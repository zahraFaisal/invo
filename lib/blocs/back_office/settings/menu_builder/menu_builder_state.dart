import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_type.dart';

abstract class MenuBuilderPhaseState {}

class MenuPhase extends MenuBuilderPhaseState {}

class MenuGroupPhase extends MenuBuilderPhaseState {
  final MenuType menu;
  final bool forward;
  MenuGroupPhase(this.menu, this.forward);
}

class MenuItemPhase extends MenuBuilderPhaseState {
  final MenuGroup group;
  MenuItemPhase(this.group);
}
