import 'package:invo_mobile/models/menu_category.dart';

abstract class MenuCategoryListEvent {}

class AddMenuCategory extends MenuCategoryListEvent {}

class LoadMenuCategory extends MenuCategoryListEvent {}
class DeleteMenuCategory extends MenuCategoryListEvent {
 
 MenuCategory menuCategory;
  DeleteMenuCategory(this. menuCategory);
}
