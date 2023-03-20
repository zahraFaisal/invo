import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/cloud_form_page/cloud_form_state.dart';
import 'package:invo_mobile/models/custom/cloud_settings.dart';
import 'package:invo_mobile/models/preference.dart';

import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../blockBase.dart';
import '../../../property.dart';
import 'cloud_form_event.dart';

class CloudFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<CloudFormEvent>.broadcast();
  Sink<CloudFormEvent> get eventSink => _eventController.sink;
  bool _isDisposed = false;

  Property<CloudLoadState> services = Property<CloudLoadState>();
  Property<CloudSetting> cloudSettings = Property<CloudSetting>();
  Property<List<String>> serverList = Property<List<String>>();
  CloudFormBloc() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    serverList.value = List<String>.empty(growable: true);
    serverList.sinkValue(serverList.value ?? List<String>.empty(growable: true));
    serverList.value!.add("");
    serverList.value!.add("https://cloud.invopos.com");

    serverList.sinkValue(serverList.value ?? List<String>.empty(growable: true));
    cloudSettings.sinkValue(CloudSetting());
  }

  void _mapEventToState(CloudFormEvent event) async {
    if (event is SaveCloud) {
      services.sinkValue(CloudIsSaving());
      cloudSettings.sinkValue(cloudSettings.value ?? CloudSetting());
      connectionRepository!.preference!.server = cloudSettings.value!.server;
      connectionRepository!.preference!.branch_name = cloudSettings.value!.branch_name;
      connectionRepository!.preference!.restSlug = cloudSettings.value!.restSlug;
      connectionRepository!.preference!.password = cloudSettings.value!.password;
      await connectionRepository!.preferenceService!.save(connectionRepository!.preference!);
      services.sinkValue(CloudSaved());
    }
  }

  Future loadServices() async {
    if (_isDisposed == false) {
      services.sinkValue(CloudIsLoading());
      Preference? preference = await connectionRepository!.preferenceService!.get();
      cloudSettings.value!.server = preference!.server;
      cloudSettings.value!.password = preference.password;
      cloudSettings.value!.branch_name = preference.branch_name;
      cloudSettings.value!.restSlug = preference.restSlug;
      await cloudSettings.sinkValue(cloudSettings.value ?? CloudSetting());
      services.sinkValue(
        CloudIsLoaded(),
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    services.dispose();
    cloudSettings.dispose();
  }
}
