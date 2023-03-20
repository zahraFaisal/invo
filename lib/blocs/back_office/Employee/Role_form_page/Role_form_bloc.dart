import 'dart:async';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';
import 'Role_form_event.dart';
import 'Role_form_state.dart';

class RoleFormPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<RoleFormEvent>.broadcast();
  Sink<RoleFormEvent>? get eventSink => _eventController.sink;
  Property<RoleLoadState>? roles = new Property<RoleLoadState>();
  NavigatorBloc? _navigationBloc;
  RoleFormPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  Future loadRole(int roleId) async {
    roles!.sinkValue(RoleIsLoading());
    if (roleId == null || roleId == 0) {
      roles!.sinkValue(RoleIsLoaded(new Role()));
    } else
      roles!.sinkValue(RoleIsLoaded(await connectionRepository!.roleService!.get(roleId)!));
  }

  void _mapEventToState(RoleFormEvent event) {
    if (event is SaveRole) {
      event.role.setSecurityList();
      event.role.in_active = false;
      connectionRepository!.roleService!.save(event.role);
    }
  }

  @override
  void dispose() {
    _eventController.close();
    roles!.dispose();
    // TODO: implement dispose
  }

  String nameValidation = "";
  Future<bool> asyncValidate(Role role) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.roleService!.checkIfNameExists(role)!;
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }
}
