import 'dart:async';

import 'package:invo_mobile/blocs/back_office/settings/table_builder/table_builder_event.dart';
import 'package:invo_mobile/blocs/back_office/settings/table_builder/table_builder_state.dart';
import 'package:invo_mobile/blocs/navigator/navigator_bloc.dart';
import 'package:invo_mobile/blocs/navigator/navigator_event.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/repositories/connection_repository.dart';

import '../../../../service_locator.dart';
import '../../../blockBase.dart';
import '../../../property.dart';

class TableBuilderPageBloc implements BlocBase {
  ConnectionRepository? connectionRepository;
  Property<List<DineInGroup>> sections = Property<List<DineInGroup>>();
  Property<List<DineInTable>> tables = Property<List<DineInTable>>();
  final _eventController = StreamController<TableBuilderEvent>.broadcast();
  Sink<TableBuilderEvent> get eventSink => _eventController.sink;
  final NavigatorBloc? _navigationBloc;
  Property<TableBuilderPhaseState> phase = Property<TableBuilderPhaseState>();

  DineInGroup? selectedSection;
  TableBuilderPageBloc(this._navigationBloc) {
    connectionRepository = locator.get<ConnectionRepository>();
    _eventController.stream.listen(_mapEventToState);
    sections.sinkValue(List<DineInGroup>.empty(growable: true));
    loadTableGroups();
  }

  void _mapEventToState(TableBuilderEvent event) {
    if (event is SectionClicked) {
      phase.sinkValue(TablesPhase(event.group!));
      selectedSection = event.group;
      loadDineInTables(event.group!.id);
    } else if (event is GoToSectionPhase) {
      phase.sinkValue(SectionsPhase());
    } else if (event is HideTable) {
      hideTable(event.tableId!, event.groupId!);
    }
  }

  Future<void> hideTable(int tableId, int groupId) async {
    await connectionRepository!.dineInService!.hideTable(tableId);
    loadDineInTables(groupId);
  }

  void loadTableGroups() async {
    List<DineInGroup> _sections = await connectionRepository!.dineInService!.loadSections();
    sections.sinkValue(_sections);
  }

  void removeTable(DineInGroup table) async {
    await connectionRepository!.dineInService!.delete(table);
    loadTableGroups();
  }

  void loadDineInTables(int groupId) async {
    List<DineInTable> _tables = await connectionRepository!.dineInService!.loadGroupTables(groupId);
    tables.sinkValue(_tables);
  }

  void saveTablePosition(DineInTable item) async {
    await connectionRepository!.dineInService!.saveTablePosition(item);
  }

  void navigateEndTutorial() async {
    _navigationBloc!.navigatorSink.add(NavigateToConnectionPage());
  }

  @override
  void dispose() {
    _eventController.close();
    sections.dispose();
    phase.dispose();
    tables.dispose();
    // TODO: implement dispose
  }
}
