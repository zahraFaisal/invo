import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/pricesForm/prices_form_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/pricesForm/prices_form_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/price_label.dart';

import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class PriceFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<PricesFormEvent>.broadcast();
  Sink<PricesFormEvent> get eventSink => _eventController.sink;

  Property<PricesLoadState> price = new Property<PricesLoadState>();

  NavigatorBloc? _navigationBloc;
  PriceFormBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  Future loadPrice(int priceId, {isCopy = false}) async {
    price.sinkValue(PriceIsLoading());
    PriceLabel pricing;
    if (priceId == null || priceId == 0) {
      pricing = new PriceLabel(in_active: false);
    } else
      pricing = await connectionRepository!.priceService!.get(priceId)!;

    if (isCopy) {
      pricing.id = null;
      pricing.name = "";
    }

    price.sinkValue(PriceIsLoaded(pricing));
  }

  void _mapEventToState(PricesFormEvent event) {
    if (event is SavePrice) {
      event.price.in_active = false;
      connectionRepository!.priceService!.save(event.price);
    }
  }

  @override
  void dispose() {
    _eventController.close();
    price.dispose();

    // TODO: implement dispose
  }

  String nameValidation = "";
  Future<bool> asyncValidate(PriceLabel price) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.priceService!.checkIfNameExists(price);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }
}
