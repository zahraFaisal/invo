import 'package:invo_mobile/models/menu_category.dart';

abstract class MenuCategoryFormEvent {}

class SaveMenuCategory extends MenuCategoryFormEvent{
  MenuCategory category;
  SaveMenuCategory(this.category);
} 
