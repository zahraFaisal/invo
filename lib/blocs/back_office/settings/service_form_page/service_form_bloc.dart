import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/service_form_page/service_form_state.dart';
import 'package:invo_mobile/models/Service.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';
import 'package:collection/collection.dart';

import '../../../../service_locator.dart';
import '../../../blockBase.dart';
import '../../../property.dart';

class ServiceFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  final _eventController = StreamController<ServicesFormEvent>.broadcast();
  Sink<ServicesFormEvent> get eventSink => _eventController.sink;
  bool _isDisposed = false;
  Property<ServiceLoadState> services = new Property<ServiceLoadState>();

  Property<List<PriceLabel>> labels = new Property<List<PriceLabel>>();
  Property<List<SurchargeList>> surcharges = new Property<List<SurchargeList>>();

  ServiceFormBloc() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ServicesFormEvent event) async {
    if (event is SaveServices) {
      services.sinkValue(ServicesIsSaving());
      List<Service> temp = List<Service>.empty(growable: true);

      temp.add(event.dineIn);
      temp.add(event.delivery);
      temp.add(event.takeAway);
      temp.add(event.carHop);
      await connectionRepository!.typeService!.saveAll(temp);
      services.sinkValue(ServicesSaved(
        dineIn: event.dineIn,
        delivery: event.delivery,
        carHop: event.carHop,
        takeAway: event.takeAway,
      ));
    }
  }

  Future loadServices() async {
    services.sinkValue(ServicesIsLoading());

    List<PriceLabel>? _labelsList = await connectionRepository!.priceService!.getActiveList();
    _labelsList!.insert(0, PriceLabel(id: null, name: "None"));
    if (_isDisposed == false) await labels.sinkValue(_labelsList);

    List<SurchargeList> _surchargeList = await connectionRepository!.surchargeService!.getActiveList()!;
    _surchargeList.insert(0, SurchargeList(id: 0, name: "None"));
    if (_isDisposed == false) await surcharges.sinkValue(_surchargeList);

    List<Service> _services = await connectionRepository!.typeService!.getAll();
    if (_isDisposed == false)
      services.sinkValue(
        ServicesIsLoaded(
          dineIn: _services.firstWhereOrNull((f) => f.id == 1),
          delivery: _services.firstWhereOrNull((f) => f.id == 4),
          carHop: _services.firstWhereOrNull((f) => f.id == 3),
          takeAway: _services.firstWhereOrNull((f) => f.id == 2),
        ),
      );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _eventController.close();
    services.dispose();
    labels.dispose();
    surcharges.dispose();
  }
}
