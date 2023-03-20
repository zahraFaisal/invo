import 'package:invo_mobile/models/menu_item.dart';

abstract class MenuItemListEvent {}

class LoadMenuItem extends MenuItemListEvent {}

class DeleteMenuItem extends MenuItemListEvent {
  MenuItem item;
  DeleteMenuItem(this.item);
}

class ImportMenuItem extends MenuItemListEvent {
  final String isImport;

  ImportMenuItem(this.isImport);
}
