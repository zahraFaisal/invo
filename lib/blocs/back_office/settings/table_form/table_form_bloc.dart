import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/table_form/table_form_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_form/table_form_state.dart';
import 'package:invo_mobile/blocs/blockBase.dart';
import 'package:invo_mobile/helpers/dialog_service.dart';
import 'package:invo_mobile/models/custom/surcharge_list.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../property.dart';

class TableFormBloc implements BlocBase {
  ConnectionRepository? connectionRepository;

  final _eventController = StreamController<TableFormEvent>.broadcast();
  Sink<TableFormEvent> get eventSink => _eventController.sink;
  Property<TableLoadState> table = new Property<TableLoadState>();

  Property<List<SurchargeList>> surcharges = new Property<List<SurchargeList>>();

  TableFormBloc() {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
  }

  Future loadTable(int tableId, {int? groupId}) async {
    table.sinkValue(TableIsLoading());

    List<SurchargeList> _surcarges = await connectionRepository!.surchargeService!.getActiveList()!;
    _surcarges.insert(0, SurchargeList(id: 0, name: "None"));
    await surcharges.sinkValue(_surcarges);

    if (tableId == null || tableId == 0) {
      table.sinkValue(
        TableIsLoaded(
          new DineInTable(
            table_group_id: groupId!,
            in_active: false,
            min_charge: 0,
          ),
        ),
      );
    } else
      table.sinkValue(TableIsLoaded(await connectionRepository!.dineInService!.getTable(tableId)));
  }

  void _mapEventToState(TableFormEvent event) {
    if (event is SaveTable) {
      connectionRepository!.dineInService!.saveTable(event.table);
    }
  }

  String nameValidation = "";
  Future<bool> asyncValidate(DineInTable table) async {
    locator.get<DialogService>().showLoadingProgressDialog();
    bool exist = await connectionRepository!.dineInService!.checkIfTableNameExists(table);
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
    surcharges.dispose();
    table.dispose();
  }
}
