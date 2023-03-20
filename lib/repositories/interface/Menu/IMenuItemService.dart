import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/quick_modifier.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_category.dart';

class IMenuItemService {
  Future<List<MenuItemList>>? getActiveList({List<int>? except}) {}
  Future<MenuItem>? getIcon(int id) {}
  Future<List<MenuItemList>>? getActiveListBarcodes() {}
  Future<List<MenuItemList>>? getList() {}
  Future<MenuItem>? get(int id) {}
  Future<int>? save(MenuItem item) {}
  updateBarcode(MenuItem item) {}
  void delete(int id) {}

  Future<List<QuickModifier>>? getQuickModifiers(int id) {}
  Future<List<MenuItem>>? getAllActive() {}
  checkIfNameExists(MenuItem item) {}

  checkIfBarcodeExists(MenuItem item) {}

  getMenuItemGroupList(int id) {}

  Future<int>? saveMenuItemGroup(MenuItemGroup item) {}

  Future<bool>? deleteItemGroup(MenuItemGroup selectedItemGroup) {}

  Future<bool>? saveIfNotExists(
      List<MenuItem> menuItems, List<PriceLabel> priceLabels, List<MenuCategory> menuCategories, List<MenuModifier> menuModifiers) {}

  Future<bool>? saveItemGroupIfNotExists(List<MenuItemGroup> menuItemGroups, List<MenuItem> menuItems, List<MenuGroup> menuGroups) {}

  saveMenuItemGroups(List<MenuItemGroup> value) {}
  // void saveIfNotExists(List<MenuItem> items) {}

  Future<List<MenuItem>>? getAll() {}
  Future<List<MenuItem>>? getUpdatedMenuItems(DateTime? lastUpdateTime) {}
  UpdateMenuItemNullUpdateTime() {}
  getUpdatedMenuItemGroups(DateTime? lastUpdateTime) {}
  UpdateMenuItemGroupNullUpdateTime() {}
  getImages(List ids) {}
  Future<List<MenuItemGroup>>? getMenuItemGroupAll() {}
  Future<List<MenuPrice>>? getPrices(int id) {}
  Future<List<MenuPrice>>? getAllPrices() {}
  Future<List<MenuItemList>>? getUnCategorizedItems() {}
}
