import 'package:invo_mobile/models/menu_group.dart';


abstract class MenuGroupFormEvent {}

class SaveMenuGroup extends MenuGroupFormEvent{
  MenuGroup menuGroup;
  SaveMenuGroup(this.menuGroup);
} 
