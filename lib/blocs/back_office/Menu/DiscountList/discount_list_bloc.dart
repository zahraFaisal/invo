import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/DiscountList/discount_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/models/custom/discount_list.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';

class DiscountListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<DiscountListEvent>.broadcast();
  Sink<DiscountListEvent> get eventSink => _eventController.sink;
  Property<List<DiscountList>> list = new Property<List<DiscountList>>();
  var allDiscounts = List<DiscountList>.empty(growable: true);
  bool _isDisposed = false;
  NavigatorBloc? _navigationBloc;
  DiscountListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    loadList();
  }
  void loadList() async {
    allDiscounts = (await connectionRepository!.discountService!.getActiveList())!;

    if (_isDisposed == false) list.sinkValue(allDiscounts);
  }

  void deleteDiscount(int id) async {
    connectionRepository!.discountService!.delete(id);
    loadList();
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allDiscounts);
    } else {
      list.sinkValue(allDiscounts.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void _mapEventToState(DiscountListEvent event) {
    if (event is LoadDiscount) {
      loadList();
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
