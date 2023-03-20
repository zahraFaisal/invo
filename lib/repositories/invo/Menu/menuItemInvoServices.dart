import 'package:invo_mobile/models/Menu_popup_mod.dart';
import 'package:invo_mobile/models/Selection.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/models/menu_combo.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/menu_selection.dart';
import 'package:invo_mobile/models/quick_modifier.dart';
import 'package:invo_mobile/repositories/interface/Menu/IMenuItemService.dart';
import 'package:invo_mobile/models/price_label.dart';

class MenuItemInvoService implements IMenuItemService {
  @override
  checkIfBarcodeExists(MenuItem item) {
    // TODO: implement checkIfBarcodeExists
    throw UnimplementedError();
  }

  @override
  checkIfNameExists(MenuItem item) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  void delete(int id) {
    // TODO: implement delete
  }

  @override
  Future<bool> deleteItemGroup(MenuItemGroup selectedItemGroup) {
    // TODO: implement deleteItemGroup
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(
      List<MenuItem> menuItems, List<PriceLabel> priceLabels, List<MenuCategory> menuCategories, List<MenuModifier> menuModifiers) {
    // TODO: implement deleteItemGroup
    throw UnimplementedError();
  }

  @override
  Future<bool> saveItemGroupIfNotExists(List<MenuItemGroup> menuItemGroups, List<MenuItem> menuItems, List<MenuGroup> menuGroups) {
    throw UnimplementedError();
  }

  @override
  Future<MenuItem> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItemList>>? getActiveList({List<int>? except}) {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<MenuItem>? getIcon(int id) {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItemList>> getActiveListBarcodes() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItem>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItemList>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItemGroup>> getMenuItemGroupAll() {
    // TODO: implement getMenuItemGroupAll
    throw UnimplementedError();
  }

  @override
  getMenuItemGroupList(int id) {
    // TODO: implement getMenuItemGroupList
    throw UnimplementedError();
  }

  @override
  Future<List<QuickModifier>> getQuickModifiers(int id) {
    // TODO: implement getQuickModifiers
    throw UnimplementedError();
  }

  Future<List<MenuCombo>> getCompoItems(int id) {
    // TODO: implement getCompoItems
    throw UnimplementedError();
  }

  Future<List<MenuSelection>> getMenuSelection(int id) {
    // TODO: implement getCompoItems
    throw UnimplementedError();
  }

  @override
  Future<int> save(MenuItem item) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  updateBarcode(MenuItem item) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<int>? saveMenuItemGroup(MenuItemGroup item) {
    // TODO: implement saveMenuItemGroup
  }

  @override
  saveMenuItemGroups(List<MenuItemGroup> value) {
    // TODO: implement saveMenuItemGroups
    throw UnimplementedError();
  }

  // @override
  // void saveIfNotExists(List<MenuItem> items) {
  //   throw UnimplementedError();
  // }

  @override
  Future<List<MenuPrice>> getPrices(int id) {
    // TODO: implement getPrices
    throw UnimplementedError();
  }

  @override
  Future<List<MenuPrice>> getAllPrices() {
    // TODO: implement getAllPrices
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItemList>> getUnCategorizedItems() {
    // TODO: implement getUnCategorizedItems
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItem>> getAllActive() {
    // TODO: implement getAllActive
    throw UnimplementedError();
  }

  @override
  Future<List<MenuItem>> getUpdatedMenuItems(DateTime? lastUpdateTime) {
    // TODO: implement getUpdatedMenuItems
    throw UnimplementedError();
  }

  @override
  UpdateMenuItemNullUpdateTime() {
    // TODO: implement UpdateMenuItemNullUpdateTime
    throw UnimplementedError();
  }

  @override
  getUpdatedMenuItemGroups(DateTime? lastUpdateTime) {
    // TODO: implement getUpdatedMenuItemGroups
    throw UnimplementedError();
  }

  @override
  UpdateMenuItemGroupNullUpdateTime() {
    // TODO: implement UpdateMenuItemGroupNullUpdateTime
    throw UnimplementedError();
  }

  @override
  getImages(List ids) {
    // TODO: implement getImages
    throw UnimplementedError();
  }
}
