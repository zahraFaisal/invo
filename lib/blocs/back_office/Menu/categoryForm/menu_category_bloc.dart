import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/categoryForm/menu_category_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/categoryForm/menu_category_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/custom/menu_item_list.dart';
import 'package:invo_mobile/models/menu_category.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class MenuCategoryFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<MenuCategoryFormEvent>.broadcast();
  Sink<MenuCategoryFormEvent>? get eventSink => _eventController.sink;
  Property<MenuCategoryLoadState>? menuCategory = new Property<MenuCategoryLoadState>();

  MenuCategory? category;
  NavigatorBloc? _navigationBloc;

  Property<List<MenuItemList>>? items = new Property<List<MenuItemList>>();

  MenuCategoryFormBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    items!.sinkValue(List<MenuItemList>.empty(growable: true));
  }

  Future loadCategory(int categoryId, {isCopy: false}) async {
    menuCategory!.sinkValue(MenuCategoryIsLoading());
    if (categoryId == null || categoryId == 0) {
      category = new MenuCategory(in_active: false);
    } else {
      category = await connectionRepository!.menuCategoryService!.get(categoryId);
      items!.sinkValue(await connectionRepository!.menuCategoryService!.getCetegoriesItems(categoryId)!);
    }
    if (isCopy) {
      category!.id = 0;
      category!.name = "";
    }
    menuCategory!.sinkValue(MenuCategoryIsLoaded(category!));
  }

  void addMenuItem(List<MenuItemList> temp) {
    for (var item in temp) {
      items!.value!.add(item);
    }
    items!.sinkValue(items!.value ?? List<MenuItemList>.empty(growable: true));
  }

  void deleteMenuItems(MenuItemList item) {
    items!.value!.remove(item);
    items!.sinkValue(items!.value ?? List<MenuItemList>.empty(growable: true));
  }

  void _mapEventToState(MenuCategoryFormEvent event) {
    if (event is SaveMenuCategory) {
      event.category.index = 0;
      connectionRepository!.menuCategoryService!.save(event.category, items!.value!);
    }
  }

  @override
  void dispose() {
    _eventController.close();
    // TODO: implement dispose
  }

  String nameValidation = "";
  Future<bool> asyncValidate(MenuCategory category) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.menuCategoryService!.checkIfNameExists(category);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }
}
