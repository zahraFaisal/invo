import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/dineIn_group.dart';

import 'package:invo_mobile/repositories/connection_repository.dart';
import '../../../../service_locator.dart';
import '../../../property.dart';
import './dinein_section_list_event.dart';
import 'dart:async';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import '../../../../service_locator.dart';
import '../../../blockBase.dart';

class DineinSectionListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  Property<List<DineInGroup>> list = Property<List<DineInGroup>>();
  var allSection = List<DineInGroup>.empty(growable: true);

  NavigatorBloc? _navigationBloc;
  bool _isDisposed = false;

  final _eventController = StreamController<DineinSectionListEvent>.broadcast();
  Sink<DineinSectionListEvent> get eventSink => _eventController.sink;

  DineinSectionListBloc() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(DineinSectionListEvent event) async {
    if (event is Save) {
      saveDineinSections();
    }
  }

  void saveDineinSections() {
    List<DineInGroup> listTemp = List<DineInGroup>.empty(growable: true);
    list.value!.forEach((element) {
      if (element.isSelected) listTemp.add(element);
    });
    if (listTemp.length > 0) connectionRepository!.dineInService!.pickSections(listTemp);
  }

  void loadList(List<int> except) async {
    allSection = await connectionRepository!.dineInService!.getHiddenSections();
    list.sinkValue(allSection);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allSection);
    } else {
      list.sinkValue(allSection.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  @override
  void dispose() {
    list.dispose();
  }
}
