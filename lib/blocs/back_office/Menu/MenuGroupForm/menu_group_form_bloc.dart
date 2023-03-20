import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/MenuGroupForm/Menu_group_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/menu_group.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';
import 'menu_group_form_event.dart';

class MenuGroupFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<MenuGroupFormEvent>.broadcast();
  Sink<MenuGroupFormEvent> get eventSink => _eventController.sink;
  Property<MenuGroupLoadState> group = new Property<MenuGroupLoadState>();
  NavigatorBloc? _navigationBloc;
  MenuGroupFormBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  Future loadMenuGroup(int groupId, int menuId) async {
    group.sinkValue(MenuGroupIsLoading());
    if (groupId == null || groupId == 0) {
      group.sinkValue(
        MenuGroupIsLoaded(
          new MenuGroup(menu_type_id: menuId),
        ),
      );
    } else
      // ignore: curly_braces_in_flow_control_structures
      group.sinkValue(MenuGroupIsLoaded(await connectionRepository!.menuGroupService!.get(groupId)));
  }

  void _mapEventToState(MenuGroupFormEvent event) {
    if (event is SaveMenuGroup) {
      connectionRepository!.menuGroupService?.save(event.menuGroup);
    }
  }

  String nameValidation = "";
  Future<bool> asyncValidate(MenuGroup group) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.menuGroupService!.checkIfNameExists(group);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }

  @override
  void dispose() {
    _eventController.close();
    group.dispose();
    // TODO: implement dispose
  }
}
