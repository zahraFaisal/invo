import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/table_group_form/table_group_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_group_form/table_group_form_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/price_label.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class TableGroupFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  Property<TableGroupLoadState> group = new Property<TableGroupLoadState>();

  final _eventController = StreamController<TableGroupFormEvent>.broadcast();
  Sink<TableGroupFormEvent> get eventSink => _eventController.sink;
  Property<List<PriceLabel>> labels = new Property<List<PriceLabel>>();

  TableGroupFormBloc() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  Future loadTableGroup(int groupId) async {
    group.sinkValue(TableGroupIsLoading());

    List<PriceLabel>? prices = await connectionRepository!.priceService!.getActiveList();
    prices!.insert(0, PriceLabel(id: null, name: "None"));
    await labels.sinkValue(prices);

    if (groupId == null || groupId == 0) {
      group.sinkValue(
        TableGroupIsLoaded(
          new DineInGroup(),
        ),
      );
    } else
      group.sinkValue(TableGroupIsLoaded(await connectionRepository!.dineInService!.getSection(groupId)));
  }

  void _mapEventToState(TableGroupFormEvent event) {
    if (event is SaveTableGroup) {
      connectionRepository!.dineInService!.saveSection(event.group);
    }
  }

  String nameValidation = "";
  Future<bool> asyncValidate(DineInGroup group) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.dineInService!.checkIfNameExists(group);
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
    labels.dispose();
    // TODO: implement dispose
  }
}
