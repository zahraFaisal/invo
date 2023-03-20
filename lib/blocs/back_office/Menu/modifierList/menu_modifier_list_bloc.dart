import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/modifierList/menu_modifier_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/menu_modifier_list.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class MenuModifierListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<MenuModifierListEvent>.broadcast();
  Sink<MenuModifierListEvent> get eventSink => _eventController.sink;
  Property<List<ModifierList>> list = new Property<List<ModifierList>>();
  List<ModifierList> allmodifiers = List<ModifierList>.empty(growable: true);
  NavigatorBloc? _navigationBloc;
  bool _isDisposed = false;
  MenuModifierListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    loadList();
  }
  void loadList() async {
    allmodifiers = (await connectionRepository!.menuModifierService!.getActiveList())!;
    if (_isDisposed == false) list.sinkValue(allmodifiers);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allmodifiers);
    } else {
      list.sinkValue(allmodifiers.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void deleteModifier(int id) async {
    connectionRepository!.menuModifierService!.delete(id);
    loadList();
  }

  void _mapEventToState(MenuModifierListEvent event) {
    if (event is LoadModifier) {
      loadList();
    }

    if (event is DeleteModifier) {
      deleteModifier(event.modifier.id);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    list.dispose();
  }
}
