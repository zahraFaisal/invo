import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/payment_method_list_page/payment_method_list_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/payment_method_list.dart';

import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class PaymentMethodListBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<PaymentMethodListEvent>.broadcast();
  Sink<PaymentMethodListEvent> get eventSink => _eventController.sink;
  Property<List<PaymentMethodList>> list = Property<List<PaymentMethodList>>();
  bool _isDisposed = false;
  NavigatorBloc? _navigationBloc;
  var allMethods = List<PaymentMethodList>.empty(growable: true);
  PaymentMethodListBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }
  void loadList() async {
    allMethods = await connectionRepository!.paymentMethodService!.getActiveList();

    if (_isDisposed == false) list.sinkValue(allMethods);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list.sinkValue(allMethods);
    } else {
      list.sinkValue(allMethods.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void deletePaymentMethod(int id) async {
    connectionRepository!.paymentMethodService!.delete(id);
    loadList();
  }

  void _mapEventToState(PaymentMethodListEvent event) {
    if (event is LoadPaymentMethod) {
      loadList();
    }

    if (event is DeletePaymentMethod) {
      deletePaymentMethod(event.method.id);
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
