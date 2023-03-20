import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_type.dart';

abstract class MenuBuilderEvent {}

class GoToMenuPhase extends MenuBuilderEvent {
  GoToMenuPhase();
}

class GoToMenuGroupPhase extends MenuBuilderEvent {
  GoToMenuGroupPhase();
}

class MenuClicked extends MenuBuilderEvent {
  MenuType? menu;
  MenuClicked({this.menu});
}

class MenuGroupClicked extends MenuBuilderEvent {
  MenuGroup group;
  MenuGroupClicked(this.group);
}

class MenuItemClicked extends MenuBuilderEvent {
  MenuItem item;
  MenuItemClicked(this.item);
}
