import 'dart:async';

import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/models/menu_item.dart';
import 'package:invo_mobile/models/menu_item_group.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:collection/collection.dart';

import '../../../../service_locator.dart';
import '../../../blockBase.dart';
import 'menu_builder_event.dart';
import 'menu_builder_state.dart';

class MenuBuilderPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<MenuBuilderEvent>.broadcast();
  Sink<MenuBuilderEvent> get eventSink => _eventController.sink;
  final NavigatorBloc? _navigationBloc;

  Property<List<MenuType>> menuTypes = Property<List<MenuType>>();
  Property<List<MenuGroup>> menuGroups = Property<List<MenuGroup>>();
  Property<List<MenuItemGroup>> menuItems = Property<List<MenuItemGroup>>();

  Property<MenuBuilderPhaseState> phase = Property<MenuBuilderPhaseState>();

  MenuBuilderPageBloc(this._navigationBloc) {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);

    phase.sinkValue(MenuPhase());
    loadMenuTypes();
  }

  MenuType? selectedMenu;
  MenuGroup? selectedGroup;
  MenuItemGroup? selectedItemGroup;

  void _mapEventToState(MenuBuilderEvent event) async {
    if (event is GoToMenuPhase) {
      phase.sinkValue(MenuPhase());
    } else if (event is MenuClicked) {
      if (event.menu != null) {
        selectedMenu = event.menu;
      }
      phase.sinkValue(MenuGroupPhase(selectedMenu!, true));
      loadMenuGroups();
    } else if (event is GoToMenuGroupPhase) {
      phase.sinkValue(MenuGroupPhase(selectedMenu!, false));
    } else if (event is MenuGroupClicked) {
      selectedGroup = event.group;
      phase.sinkValue(MenuItemPhase(event.group));
      loadMenuItems();
    }
  }

  void loadMenuTypes() async {
    List<MenuType>? menus = await connectionRepository!.menuTypeService!.getActiveList();
    menuTypes.sinkValue(menus!);
  }

  void loadMenuGroups() async {
    List<MenuGroup> groups = await connectionRepository!.menuGroupService!.getList(selectedMenu!.id)!;
    menuGroups.sinkValue(groups);
  }

  void loadMenuItems() async {
    List<MenuItemGroup> items = await connectionRepository!.menuItemService!.getMenuItemGroupList(selectedGroup!.id);
    menuItems.sinkValue(items);
  }

  @override
  void dispose() {
    _eventController.close();
    menuTypes.dispose();
    menuGroups.dispose();
    phase.dispose();
    // TODO: implement dispose
  }

  void removeMenu(MenuType menu) async {
    connectionRepository!.menuTypeService!.delete(menu);
    loadMenuTypes();
  }

  void removeGroup(MenuGroup group) async {
    await connectionRepository!.menuGroupService!.delete(group);
    loadMenuGroups();
  }

  void pickGroups(List<MenuGroup> temp) async {
    if (temp == null || temp.length == 0) return;

    for (var item in temp) {
      item.menu_type_id = selectedMenu!.id;
    }

    await connectionRepository!.menuGroupService!.updateMenuType(temp, selectedMenu!.id);

    loadMenuGroups();
  }

  void saveMenuItemGroup(MenuItemGroup itemGroup) async {
    connectionRepository!.menuItemService!.saveMenuItemGroup(itemGroup);
    loadMenuItems();
  }

  void saveMenuItemGroups() async {
    await connectionRepository!.menuItemService!.saveMenuItemGroups(menuItems.value!);
  }

  bool selectItem(MenuItemGroup item) {
    if (selectedItemGroup != null && selectedItemGroup!.index == item.index) {
      return false;
    } else {
      selectedItemGroup = item;
      return true;
    }
  }

  void doubleHeight() {
    MenuItemGroup? temp = menuItems.value!.firstWhereOrNull((f) => f.id == selectedItemGroup!.id);
    var tempTest = menuItems.value!.where((f) => f.index == (temp!.index + 6));
    if (tempTest.isEmpty && (temp!.index + 6) < 36 && (temp.index < 30)) {
      if (temp.double_width) {
        if (temp.index + 7 < 36) {
          tempTest = menuItems.value!.where((f) => f.index == (temp.index + 7));
          if (tempTest.isEmpty) {
            temp.double_height = !temp.double_height;
            menuItems.sinkValue(menuItems.value ?? List<MenuItemGroup>.empty(growable: true));
            saveMenuItemGroups();
          }
        }
      } else {
        temp.double_height = !temp.double_height;
        menuItems.sinkValue(menuItems.value ?? List<MenuItemGroup>.empty(growable: true));
        saveMenuItemGroups();
      }
    }
  }

  void doubleWidth() {
    MenuItemGroup? temp = menuItems.value!.firstWhereOrNull((f) => f.id == selectedItemGroup!.id);
    var tempTest = menuItems.value!.where((f) => f.index == (temp!.index + 1));
    if (tempTest.isEmpty &&
        (temp!.index + 1) < 36 &&
        (temp.index != 5 && temp.index != 11 && temp.index != 17 && temp.index != 23 && temp.index != 29 && temp.index != 35)) {
      if (temp.double_height) {
        if (temp.index + 7 < 36) {
          tempTest = menuItems.value!.where((f) => f.index == (temp.index + 7));
          if (tempTest.isEmpty) {
            temp.double_width = !temp.double_width;
            menuItems.sinkValue(menuItems.value ?? List<MenuItemGroup>.empty(growable: true));
            saveMenuItemGroups();
          }
        }
      } else {
        temp.double_width = !temp.double_width;
        menuItems.sinkValue(menuItems.value ?? List<MenuItemGroup>.empty(growable: true));
        saveMenuItemGroups();
      }
    }
  }

  void unPinItem() async {
    bool resault = await connectionRepository!.menuItemService!.deleteItemGroup(selectedItemGroup!)!;
    if (resault) {
      menuItems.value!.remove(selectedItemGroup);
      selectedItemGroup = null;
      menuItems.sinkValue(menuItems.value ?? List<MenuItemGroup>.empty(growable: true));
    }
  }

  void navigateNextTutorial() async {
    _navigationBloc!.navigateToTableFormPage(active: true);
  }

  void pickItem(List<MenuItemList> temp) async {
    // if (temp == null || temp.length == 0) return;
    // if (temp[0] != null) {
    //   MenuItem menuItem =
    //       await connectionRepository.menuItemService.get(temp[0].id);

    //   MenuItemGroup itemGroup = new MenuItemGroup(index: 0);
    //   itemGroup.menu_item_id = menuItem.id;
    //   itemGroup.index =
    //       (selectedItemGroup == null) ? 0 : selectedItemGroup.index;
    //   itemGroup.double_width = false;
    //   itemGroup.double_height = false;
    //   itemGroup.menu_group_id = selectedGroup.id;
    //   saveMenuItemGroup(itemGroup);
    //   selectedItemGroup = null;
    MenuItem menuItem = new MenuItem();
    MenuItemGroup itemGroup;

    for (var item in temp) {
      menuItem = (await connectionRepository!.menuItemService!.get(item.id))!;
      itemGroup = new MenuItemGroup(index: 0);
      itemGroup.menu_item_id = menuItem.id;
      itemGroup.index = (selectedItemGroup == null) ? 0 : selectedItemGroup!.index;
      itemGroup.double_width = false;
      itemGroup.double_height = false;
      itemGroup.menu_group_id = selectedGroup!.id;
      saveMenuItemGroup(itemGroup);
      selectedItemGroup = null;
    }

    print("test");
  }

  void updateItemPosition(MenuItemGroup item, int newIndex) {
    // MenuItemGroup temp = widget.bloc.menuItems.value.firstWhere((f) =>
    //     f.menu_group_id == _item.menu_group_id &&
    //     f.menu_item_id == _item.menu_item_id);
    item.index = newIndex;
    menuItems.sinkValue(menuItems.value ?? List<MenuItemGroup>.empty(growable: true));
    saveMenuItemGroups();
  }
}
