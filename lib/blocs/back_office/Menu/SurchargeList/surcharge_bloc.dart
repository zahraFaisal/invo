import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/SurchargeList/Surcharge_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class SurchargeListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<SurchargeListEvent>.broadcast();
  Sink<SurchargeListEvent> get eventSink => _eventController.sink;
  bool _isDisposed = false;
  Property<List<SurchargeList>> list = new Property<List<SurchargeList>>();
  NavigatorBloc? _navigationBloc;
  var allSurcharges = List<SurchargeList>.empty(growable: true);
  SurchargeListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    loadList();
  }

  void loadList() async {
    allSurcharges = (await connectionRepository!.surchargeService!.getActiveList())!;

    if (_isDisposed == false) list.sinkValue(allSurcharges);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allSurcharges);
    } else {
      list.sinkValue(allSurcharges.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void deleteSurcharge(int id) async {
    Surcharge surcharge = await connectionRepository!.surchargeService!.get(id)!;
    connectionRepository!.surchargeService!.update(surcharge);
    loadList();
  }

  void _mapEventToState(SurchargeListEvent event) {
    if (event is LoadSurcharge) {
      loadList();
    }

    if (event is DeleteSurcharge) {
      deleteSurcharge(event.surcharge.id!);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    list.dispose();
  }
}
