import 'package:invo_mobile/models/menu_category.dart';

abstract class MenuCategoryLoadState {}

class MenuCategoryIsLoading extends MenuCategoryLoadState {}

class MenuCategoryIsLoaded extends MenuCategoryLoadState {
  final MenuCategory menuCategory;
  MenuCategoryIsLoaded(this.menuCategory);
}
