import 'dart:async';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/property.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/menu_type.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:collection/collection.dart';

import '../../../../service_locator.dart';
import 'menu_event.dart';

class MenuTypeFormBloc implements BlocBase {
  NavigatorBloc? _navigationBloc;
  ConnectionRepository? connectionRepository;

  final _eventController = StreamController<MenuFormEvent>.broadcast();
  Sink<MenuFormEvent> get eventSink => _eventController.sink;

  Property<MenuType> menu = Property<MenuType>();
  Property<List<PriceLabel>> labels = new Property<List<PriceLabel>>();

  int? get labelId {
    if (menu.value == null || labels.value == null) return null;
    PriceLabel? temp = labels.value!.firstWhereOrNull((f) => f.id == menu.value!.price_id);
    if (temp == null) return null;

    return temp.id;
  }

  MenuTypeFormBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  void loadMenu(int id) async {
    await labels.sinkValue(await connectionRepository!.priceService!.getActiveList()!);

    if (id == 0 || id == null) {
      menu.sinkValue(MenuType());
    } else {
      menu.sinkValue(await connectionRepository!.menuTypeService!.get(id)!);
    }
  }

  void _mapEventToState(MenuFormEvent event) {
    if (event is SaveMenu) {
      event.menu.in_active = false;
      connectionRepository!.menuTypeService!.save(event.menu);
    }
  }

  String nameValidation = "";
  Future<bool> asyncValidate(MenuType menu) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.menuTypeService!.checkIfNameExists(menu);
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
    labels.dispose();
    menu.dispose();
    // TODO: implement dispose
  }
}
