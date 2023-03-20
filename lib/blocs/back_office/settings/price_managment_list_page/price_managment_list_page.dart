import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/price_managment_list_page/price_managment_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/price_managment_list.dart';
import 'package:invo_mobile/models/price_managment.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class PriceManagmentListPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<PriceManagmentListEvent>.broadcast();
  Sink<PriceManagmentListEvent> get eventSink => _eventController.sink;

  Property<List<PriceManagementList>> list = new Property<List<PriceManagementList>>();
  bool _isDisposed = false;
  NavigatorBloc? _navigationBloc;
  var allPriceManagment = List<PriceManagementList>.empty(growable: true);

  PriceManagmentListPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  void loadList() async {
    allPriceManagment = (await connectionRepository!.priceManagmentService!.getList())!;
    if (_isDisposed == false) list.sinkValue(allPriceManagment);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allPriceManagment);
    } else {
      list.sinkValue(allPriceManagment.where((f) => f.name.contains(query)).toList());
    }
  }

  void deletePriceManagment(int id) async {
    PriceManagement priceManagment = await connectionRepository!.priceManagmentService!.get(id)!;
    connectionRepository!.priceManagmentService!.delete(priceManagment.id);
    loadList();
  }

  void _mapEventToState(PriceManagmentListEvent event) {
    if (event is LoadPriceManagment) {
      loadList();
    }

    if (event is DeletePriceManagment) {
      deletePriceManagment(event.priceManagment.id);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    list.dispose();
    // TODO: implement dispose
  }
}
