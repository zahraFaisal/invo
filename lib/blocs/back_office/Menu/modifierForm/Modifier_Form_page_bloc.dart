import 'dart:async';

import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/menu_modifier.dart';
import 'package:invo_mobile/models/modifier_price.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:collection/collection.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';
import 'Modifier_Form_state.dart';
import 'Modifier_form_event.dart';
import 'dart:convert';

class ModifierFormPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<ModifierFormEvent>.broadcast();
  Sink<ModifierFormEvent> get eventSink => _eventController.sink;
  Property<ModifierLoadState> modifiers = new Property<ModifierLoadState>();
  NavigatorBloc? _navigationBloc;
  MenuModifier? menuModifier;

  ModifierFormPageBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }
  Future loadModifier(int modifierId, {isCopy = false}) async {
    modifiers.sinkValue(ModifierIsLoading());
    if (modifierId == null || modifierId == 0) {
      menuModifier = new MenuModifier();
      List<PriceLabel> prices = await connectionRepository!.priceService!.getActiveList()!;

      menuModifier!.prices = List<ModifierPrice>.empty(growable: true);
      for (var price in prices) {
        menuModifier!.prices!.add(new ModifierPrice(id: 0, label_id: price.id!, label: price));
      }
      modifiers.sinkValue(ModifierIsLoaded(menuModifier!));
    } else {
      menuModifier = await connectionRepository!.menuModifierService!.get(modifierId);
      List<PriceLabel> prices = await connectionRepository!.priceService!.getActiveList()!;

      for (var price in prices) {
        if (menuModifier!.prices!.where((f) => f.label_id == price.id).length == 0) {
          menuModifier!.prices!.add(new ModifierPrice(id: 0, label_id: price.id!, label: price));
        } else {
          menuModifier!.prices!.firstWhereOrNull((f) => f.label_id == price.id)!.label = price;
        }
      }
      if (isCopy) {
        menuModifier!.id = 0;
        menuModifier!.name = "";
      }
      modifiers.sinkValue(ModifierIsLoaded(menuModifier!));
    }
  }

  void _mapEventToState(ModifierFormEvent event) {
    // if (event is SaveMenuModifier) {
    //   connectionRepository.menuModifierService.save(event.modifier);
    // }
  }

  deletePrice(ModifierPrice price) {
    price.priceTxt = null;
    modifiers.sinkValue(ModifierIsLoaded(menuModifier!));
  }

  @override
  void dispose() {
    _eventController.close();
    // TODO: implement dispose
  }

  String nameValidation = "";
  Future<bool> asyncValidate(MenuModifier modifier) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.menuModifierService!.checkIfNameExists(modifier);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }

  Future<MenuModifier> saveMenuModifier(MenuModifier modifier) async {
    modifier.id = (await connectionRepository!.menuModifierService!.save(modifier))!;
    return modifier;
  }
}
