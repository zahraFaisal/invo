import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Employee/Employee_list_page/employee_list_event.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/employee_list.dart';

import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class EmployeeListPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<EmployeeListEvent>.broadcast();
  Sink<EmployeeListEvent>? get eventSink => _eventController.sink;
  Property<List<EmployeeList>>? list = new Property<List<EmployeeList>>();
  var allEmployees = List<EmployeeList>.empty(growable: true);
  NavigatorBloc? _navigationBloc;
  bool? _isDisposed = false;
  EmployeeListPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    loadList();
  }

  void loadList() async {
    allEmployees = (await connectionRepository!.employeeService!.getActiveList())!;

    if (_isDisposed == false) list!.sinkValue(allEmployees);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list!.sinkValue(allEmployees);
    } else {
      list!.sinkValue(allEmployees.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void deleteEmployee(int id) async {
    connectionRepository!.employeeService!.delete(id);
    loadList();
  }

  void _mapEventToState(EmployeeListEvent event) {
    if (event is LoadEmployee) {
      loadList();
    }

    if (event is DeleteEmployee) {
      deleteEmployee(event.employee.id);
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
