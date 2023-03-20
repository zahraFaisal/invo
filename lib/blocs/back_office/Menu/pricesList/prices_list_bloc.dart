import 'dart:async';
import 'package:invo_mobile/blocs/back_office/Menu/PricesList/prices_list_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import '../../../../service_locator.dart';
import '../../../property.dart';

class PriceListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<PricesListEvent>.broadcast();
  Sink<PricesListEvent> get eventSink => _eventController.sink;
  Property<List<PriceLabel>> list = new Property<List<PriceLabel>>();
  NavigatorBloc? _navigationBloc;
  bool _isDisposed = false;
  var allprices = List<PriceLabel>.empty(growable: true);
  PriceListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    loadList();
  }

  void loadList() async {
    allprices = await connectionRepository!.priceService!.getActiveList()!;

    if (_isDisposed == false) list.sinkValue(allprices);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allprices);
    } else {
      list.sinkValue(allprices.where((f) => f.name!.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void deletePrice(int id) async {
    connectionRepository!.priceService!.delete(id);
    loadList();
  }

  void _mapEventToState(PricesListEvent event) {
    if (event is LoadPrice) {
      loadList();
    }

    if (event is DeletePrice) {
      deletePrice(event.price.id!);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    list.dispose();
  }
}
