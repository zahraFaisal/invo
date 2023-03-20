import 'dart:async';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';
import 'Role_list_event.dart';

class RoleListPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<RoleListEvent>.broadcast();
  Sink<RoleListEvent>? get eventSink => _eventController.sink;
  Property<List<RoleList>>? list = new Property<List<RoleList>>();
  var allRoles = List<RoleList>.empty(growable: true);
  bool? _isDisposed = false;
  NavigatorBloc? _navigationBloc;
  RoleListPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    loadList();
  }
  void loadList() async {
    allRoles = await connectionRepository!.roleService!.getActiveList()!;

    if (_isDisposed == false) list!.sinkValue(allRoles);
  }

  void filterSearchResults(String query) {
    if (query == "" || query == null) {
      list!.sinkValue(allRoles);
    } else {
      list!.sinkValue(allRoles.where((f) => f.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void deleteRole(int id) async {
    Role role = await connectionRepository!.roleService!.get(id)!;
    connectionRepository!.roleService!.update(role);
    loadList();
  }

  void _mapEventToState(RoleListEvent event) {
    if (event is LoadRole) {
      loadList();
    }

    if (event is DeleteRole) {
      deleteRole(event.role.id_number);
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
