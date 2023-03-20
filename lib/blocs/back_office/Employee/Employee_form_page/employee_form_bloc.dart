import 'dart:async';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/employee.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';
import 'employee_form_event.dart';
import 'employee_form_state.dart';

class EmployeeFormPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<EmployeeFormEvent>.broadcast();
  Sink<EmployeeFormEvent>? get eventSink => _eventController.sink;
  Property<EmployeeLoadState>? employee = Property<EmployeeLoadState>();
  List<RoleList>? roles = List<RoleList>.empty(growable: true);
  NavigatorBloc? _navigationBloc;
  EmployeeFormPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  loadRoles() async {
    roles = await connectionRepository!.roleService?.getActiveList();
  }

  Future loadEmployee(int employeeId) async {
    employee!.sinkValue(EmployeeIsLoading());
    await loadRoles();
    Employee? temp;
    if (employeeId == null || employeeId == 0) {
      temp = new Employee();
      employee!.sinkValue(EmployeeIsLoaded(new Employee()));
    } else
      temp = await connectionRepository?.employeeService!.get(employeeId);

    employee!.sinkValue(EmployeeIsLoaded(temp!));
  }

  void _mapEventToState(EmployeeFormEvent event) {
    if (event is SaveEmployee) {
      event.employee.in_active = false;
      connectionRepository!.employeeService!.save(event.employee);
    }
  }

  @override
  void dispose() {
    _eventController.close();
    employee!.dispose();
    // TODO: implement dispose
  }

  String? nameValidation = "";
  Future<bool> asyncValidate(Employee employee) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.employeeService!.checkIfNameExists(employee);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }
}
