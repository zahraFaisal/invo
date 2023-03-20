import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/categoryList/menu_category_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/custom/menu_category_List.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';

class MenuCategoryListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;

  final _eventController = StreamController<MenuCategoryListEvent>.broadcast();
  Sink<MenuCategoryListEvent>? get eventSink => _eventController.sink;
  bool _isDisposed = false;
  Property<List<MenuCategoryList>>? list = Property<List<MenuCategoryList>>();
  var allcategories = List<MenuCategoryList>.empty(growable: true);
  NavigatorBloc? _navigationBloc;
  MenuCategoryListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);

    loadList();
  }

  void loadList() async {
    allcategories = (await connectionRepository!.menuCategoryService!.getActiveList())!;
    if (_isDisposed == false) list!.sinkValue(allcategories);
  }

  void deleteCategory(int id) async {
    connectionRepository!.menuCategoryService!.delete(id);
    loadList();
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list!.sinkValue(allcategories);
    } else {
      list!.sinkValue(allcategories.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void _mapEventToState(MenuCategoryListEvent event) {
    if (event is LoadMenuCategory) {
      loadList();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    list!.dispose();
    // TODO: implement dispose
  }
}
