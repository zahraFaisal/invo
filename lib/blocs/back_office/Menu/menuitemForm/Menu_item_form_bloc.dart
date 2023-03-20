import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/menuitemForm/Menu_item_Form_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/menuitemForm/Menu_item_state.dart';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/Menu_popup_mod.dart';
import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/menu_price.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/models/quick_modifier.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:collection/collection.dart';

import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';
import 'dart:convert';

class MenuItemBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<MenuItemFormEvent>.broadcast();

  Sink<MenuItemFormEvent>? get eventSink => _eventController.sink;
  Property<MenuItemLoadState> item = Property<MenuItemLoadState>();
  Property<List<MenuCategoryList>> categories = Property<List<MenuCategoryList>>();
  Property<List<MenuItemList>> items = Property<List<MenuItemList>>();
  Preference? preference;

  Property<MenuPopupMod> currentPopUpLevel = Property<MenuPopupMod>();

  MenuItem? menuItem;
  NavigatorBloc? _navigationBloc;

  int? get menuCategoryId {
    if (categories.value == null) return null;
    MenuCategoryList? temp = categories.value!.firstWhereOrNull((f) => f.id == menuItem!.menu_category_id);
    if (temp == null) return null;

    return temp.id;
  }

  @override
  void dispose() {
    items.dispose();
    currentPopUpLevel.dispose();
    categories.dispose();
    item.dispose();
    _eventController.close();
  }

  //constructer
  MenuItemBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);

    loadMenuCategory();
    loaditems();
  }

  loaditems() async {
    preference = (await connectionRepository!.preferenceService!.get())!;
    var x = await connectionRepository!.menuItemService!.getActiveList();
    print(x);
    items.sinkValue(x!);
  }

  loadMenuCategory() async {
    categories.sinkValue(await connectionRepository!.menuCategoryService!.getActiveList()!);
  }

  Future loadMenuItem(int itemId, {isCopy = false}) async {
    item.sinkValue(MenuItemIsLoading());
    if (itemId == null || itemId == 0) {
      menuItem = new MenuItem(
        apply_tax1: true,
        apply_tax2: true,
        apply_tax3: true,
        in_stock: true,
        discountable: true,
        in_active: false,
      );
    } else {
      menuItem = await connectionRepository?.menuItemService!.get(itemId);
    }
    if (isCopy) {
      menuItem!.id = 0;
      menuItem!.name = "";
    }

    addNewLevel();
    currentPopUpLevel.value = menuItem!.popup_mod!.last;

    await getMenuPrices();
    item.sinkValue(MenuItemIsLoaded(menuItem!));
  }

  Future<bool> getMenuPrices() async {
    List<PriceLabel> prices = await connectionRepository!.priceService!.getActiveList()!;

    for (var price in prices) {
      if (menuItem!.prices!.where((f) => f.label_id == price.id).length == 0)
        menuItem!.prices!.add(new MenuPrice(id: 0, label_id: price.id!, label: price));
      else
        menuItem!.prices!.firstWhereOrNull((f) => f.label_id == price.id)!.label = price;
    }
    return true;
  }

  //================================================
  // Quick Modifiers
  //================================================
  void addQuickModifiers(List<ModifierList> temp) {
    for (var modifier in temp) {
      if (menuItem!.quick_mod!.every((element) => element.modifier!.id != modifier.id)) {
        menuItem!.quick_mod!.add(new QuickModifier(id: 0, modifier: modifier, modifier_id: modifier.id));
      }
    }
    item.sinkValue(MenuItemIsLoaded(menuItem!));
  }

  void addNewQuickModifiers(MenuModifier temp) {
    menuItem!.quick_mod!
        .add(new QuickModifier(id: 0, modifier: ModifierList(id: temp.id, name: temp.name, price: temp.additional_price), modifier_id: temp.id));
    item.sinkValue(MenuItemIsLoaded(menuItem!));
  }

  void deleteQuickModifier(QuickModifier quick_mod) {
    menuItem!.quick_mod!.remove(quick_mod);
    item.sinkValue(MenuItemIsLoaded(menuItem!));
  }

  Future<void> copyQuickModifiers(int id) async {
    List<QuickModifier> list = await connectionRepository!.menuItemService!.getQuickModifiers(id)!;

    for (var modifier in list) {
      menuItem!.quick_mod!.add(modifier);
    }
    item.sinkValue(MenuItemIsLoaded(menuItem!));
  }
  //================================================

  //================================================
  // PopUp Modifiers
  //================================================
  void addNewLevel() {
    menuItem!.popup_mod!
        .add(new MenuPopupMod(id: 0, level: menuItem!.popup_mod!.length + 1, is_forced: false, modifiers: List<LevelModifier>.empty(growable: true)));
  }

  void changeLevel(MenuPopupMod popupMod) {
    currentPopUpLevel.value = popupMod;
    item.sinkValue(MenuItemIsLoaded(menuItem!));
  }

  void addPopUpModifiers(List<ModifierList> temp) {
    for (var modifier in temp) {
      if (currentPopUpLevel.value!.modifiers.every((element) => element.modifier!.id != modifier.id))
        currentPopUpLevel.value!.modifiers
            .add(LevelModifier(id: 0, modifier_id: modifier.id, modifier: MenuModifier(id: modifier.id, name: modifier.name)));
    }

    if (currentPopUpLevel.value == menuItem!.popup_mod!.last) {
      addNewLevel();
      item.sinkValue(MenuItemIsLoaded(menuItem!));
    } else {
      currentPopUpLevel.sinkValue(currentPopUpLevel.value ?? MenuPopupMod(modifiers: []));
    }
  }

  void addNewPopUpModifiers(MenuModifier modifier) {
    currentPopUpLevel.value!.modifiers.add(LevelModifier(id: 0, modifier_id: modifier.id, modifier: modifier));

    if (currentPopUpLevel.value == menuItem!.popup_mod!.last) {
      addNewLevel();
      item.sinkValue(MenuItemIsLoaded(menuItem!));
    } else {
      currentPopUpLevel.sinkValue(currentPopUpLevel.value ?? MenuPopupMod(modifiers: []));
    }
  }

  void deletePopUpModifier(LevelModifier modifier) {
    if (modifier.id == 0) {
      currentPopUpLevel.value!.modifiers.remove(modifier);
    } else {
      modifier.Is_Deleted = true;
    }

    if (currentPopUpLevel.value!.modifiers.where((f) => f.Is_Deleted == false).length == 0) {
      if (currentPopUpLevel.value!.id == 0) {
        menuItem!.popup_mod!.remove(currentPopUpLevel.value);
      } else {
        currentPopUpLevel.value!.Is_Deleted = true;
      }

      int i = 1;
      for (var item in menuItem!.popup_mod!.where((f) => f.Is_Deleted == false)) {
        item.level = i++;
      }

      currentPopUpLevel.value = menuItem!.popup_mod!.where((f) => f.Is_Deleted == false).last;

      item.sinkValue(MenuItemIsLoaded(menuItem!));
    } else {
      currentPopUpLevel.sinkValue(currentPopUpLevel.value ?? MenuPopupMod(modifiers: []));
    }
  }
  //================================================

  deletePrice(MenuPrice price) {
    price.priceTxt = "";
    item.sinkValue(MenuItemIsLoaded(menuItem!));
  }

  void _mapEventToState(MenuItemFormEvent event) {}

  String? nameValidation = "";
  String? barcodeValidation = "";
  Future<bool> asyncValidate(MenuItem item) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.menuItemService?.checkIfNameExists(item);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    if (item.barcode != null && item.barcode!.isNotEmpty) {
      locator.get<DialogService>().showLoadingProgressDialog();
      exist = await connectionRepository!.menuItemService!.checkIfBarcodeExists(item);
      locator.get<DialogService>().closeDialog();
      if (exist) {
        barcodeValidation = "Barcode must be unique";
        return false;
      }
    }

    barcodeValidation = "";
    nameValidation = "";
    return true;
  }

  Future<MenuItem> saveMenuItem(MenuItem item) async {
    item.additional_cost = 0;

    //remove empty popup
    for (var popup in item.popup_mod!.toList()) {
      if (popup.id == 0 && popup.modifiers.length == 0) {
        item.popup_mod!.remove(popup);
      }
    }

    int? id = await connectionRepository!.menuItemService!.save(item);
    item.id = id!;
    return item;
  }
}
