import 'dart:async';

import 'package:invo_mobile/blocs/back_office/Menu/SurchargeForm/surcharge_event.dart';
import 'package:invo_mobile/blocs/back_office/Menu/SurchargeForm/surcharge_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/surcharge.dart';
import 'package:invo_mobile/models/preference.dart';

import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class SurchargeFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<SurchargeFormEvent>.broadcast();
  Sink<SurchargeFormEvent> get eventSink => _eventController.sink;

  Property<SurchargeLoadState> surcharge = Property<SurchargeLoadState>();
  Property<Preference?>? preference = Property<Preference>();

  NavigatorBloc? _navigationBloc;
  SurchargeFormBloc(NavigatorBloc navigationBloc) {
    _navigationBloc = navigationBloc;
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    // preference!.sinkValue(null);
    loadPref();
  }

  Future<void> loadPref() async {
    preference!.sinkValue(await connectionRepository!.preferenceService!.get()!);
  }

  Future loadSurcharge(int surchargeId, {isCopy: false}) async {
    surcharge.sinkValue(SurchargeIsLoading());
    Surcharge temp;
    if (surchargeId == null || surchargeId == 0) {
      temp = Surcharge(is_percentage: true, in_active: false);
    } else
      temp = (await connectionRepository!.surchargeService!.get(surchargeId))!;

    if (isCopy) {
      temp.id = 0;
      temp.name = "";
    }

    surcharge.sinkValue(SurchargeIsLoaded(temp));
  }

  void _mapEventToState(SurchargeFormEvent event) {
    if (event is SaveSurcharge) {
      event.surcharge.in_active = false;
      connectionRepository!.surchargeService!.save(event.surcharge);
    }
  }

  @override
  void dispose() {
    _eventController.close();
    surcharge.dispose();
    // TODO: implement dispose
  }

  String nameValidation = "";
  Future<bool> asyncValidate(Surcharge surcharge) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.surchargeService!.checkIfNameExists(surcharge);
    locator.get<DialogService>().closeDialog();

    if (exist) {
      nameValidation = "Name must be unique";
      return false;
    }

    nameValidation = "";
    return true;
  }
}
