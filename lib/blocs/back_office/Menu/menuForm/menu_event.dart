import 'package:invo_mobile/models/menu_type.dart';

abstract class MenuFormEvent {}

class SaveMenu extends MenuFormEvent {
  MenuType menu;
  SaveMenu(this.menu);
}
