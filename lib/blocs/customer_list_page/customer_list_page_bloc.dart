import 'dart:async';

import 'package:invo_mobile/blocs/customer_list_page/customer_list_page_event.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/models/custom/customer_list.dart';
import 'package:invo_mobile/models/preference.dart';
import 'package:invo_mobile/models/terminal.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/service_locator.dart';
import 'package:invo_mobile/services/Print/PrintService.dart';
import 'package:invo_mobile/models/Service.dart' as services;
import '../blockBase.dart';
import '../property.dart';

class CustomerListPageBloc extends BlocBase {
  final NavigatorBloc? _navigationBloc;
  final _eventController = StreamController<CustomerListPageEvent>.broadcast();
  Sink<CustomerListPageEvent> get eventSink => _eventController.sink;
  Preference? preference;

  CustomerListPageBloc(this._navigationBloc) {
    _eventController.stream.listen(_mapEventToState);
    _eventController.sink.add(LoadCustomerList(''));
    preference = locator.get<ConnectionRepository>().preference;
  }

  Property<List<CustomerList>> model = new Property<List<CustomerList>>();
  @override
  void dispose() {
    _eventController.close();
    // TODO: implement dispose
  }

  void _mapEventToState(CustomerListPageEvent event) async {
    if (event is LoadCustomerList) {
      List<CustomerList>? temp = await locator.get<ConnectionRepository>().customerService!.getAllCustomers(event.filter);
      model.sinkValue(temp!);
    } else if (event is ChangeCustomer) {
      _loadCustomer(event.phone);
    }
  }

  void _loadCustomer(String phone) {
    /* 
    _navigationBloc.navigatorSink
        .add(NavigateToCustomerPage(this.selectedService.value, phone: phone)); */
  }
}
