import 'package:invo_mobile/models/menu_item.dart';


abstract class MenuItemFormEvent {}

class SaveMenuItem extends MenuItemFormEvent{
  MenuItem item;
 SaveMenuItem(this.item);
} 