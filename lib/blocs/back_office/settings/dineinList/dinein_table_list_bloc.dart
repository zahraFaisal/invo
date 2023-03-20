import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import '../../../../service_locator.dart';
import '../../../property.dart';

import './dinein_table_list_event.dart';

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

import '../../../../service_locator.dart';
import '../../../blockBase.dart';

class DineinTableListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  int? groupId;
  Property<List<DineInTable>> list = new Property<List<DineInTable>>();
  var allTables = List<DineInTable>.empty(growable: true);

  NavigatorBloc? _navigationBloc;
  bool _isDisposed = false;

  final _eventController = StreamController<DineinTableListEvent>.broadcast();
  Sink<DineinTableListEvent> get eventSink => _eventController.sink;

  DineinTableListBloc(groupId) {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    this.groupId = groupId;
  }

  void _mapEventToState(DineinTableListEvent event) async {
    if (event is Save) {
      saveDineinGroup();
    }
  }

  void saveDineinGroup() {
    List<DineInTable> listTemp = List<DineInTable>.empty(growable: true);
    list.value!.forEach((element) {
      if (element.isSelected) listTemp.add(element);
    });
    if (listTemp.length > 0) connectionRepository!.dineInService!.pickTables(listTemp);
  }

  void loadList(List<int>? except) async {
    allTables = await connectionRepository!.dineInService!.getGroupHiddenTables(this.groupId!);
    list.sinkValue(allTables);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allTables);
    } else {
      list.sinkValue(allTables.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  @override
  void dispose() {
    list.dispose();
  }
}
