import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/preference_page/preferences_page_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/preference_page/preferences_page_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:invo_mobile/blocs/main/main_bloc.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

import 'package:invo_mobile/blocs/property.dart';

import 'package:invo_mobile/service_locator.dart';

import 'dart:convert';

class PreferenceBlocPage implements BlocBase {
  ConnectionRepository? connectionRepository;
  MainBloc mainBloc = locator.get<MainBloc>();

  final _eventController = StreamController<PreferenceFormEvent>.broadcast();
  Sink<PreferenceFormEvent> get eventSink => _eventController.sink;
  Property<PreferenceLoadState> preference = new Property<PreferenceLoadState>();

  PreferenceBlocPage() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    loadPreference();
  }

  loadPreference() async {
    preference.sinkValue(PreferenceIsLoading());
    preference.sinkValue(PreferenceIsLoaded(await connectionRepository!.preferenceService!.get()!));
  }

  void _mapEventToState(PreferenceFormEvent event) async {
    if (event is SavePreference) {
      locator.get<DialogService>().showLoadingProgressDialog();
      await connectionRepository!.preferenceService!.save(event.preference);
      await connectionRepository!.paymentMethodService!.update(connectionRepository!.cash!);
      locator.get<DialogService>().closeDialog();
      preference.setValue(PreferenceSaved(event.preference));
      mainBloc.logo_.setValue(base64.decode(event.preference.restaurantLogo!));
    }
  }

  // Future<bool> save(Preference preference) async {
  //   return await connectionRepository.preferenceService.save(preference);
  // }

  @override
  void dispose() {
    _eventController.close();
    preference.dispose();
    // TODO: implement dispose
  }
}
