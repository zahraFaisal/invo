import 'package:invo_mobile/models/menu_item.dart';

abstract class MenuItemLoadState {}

class MenuItemIsLoading extends MenuItemLoadState {}

class MenuItemIsLoaded extends MenuItemLoadState {
  final MenuItem item;
  MenuItemIsLoaded(this.item);
}
