import 'package:invo_mobile/models/dineIn_group.dart';

abstract class TableBuilderEvent {}

class GoToSectionPhase extends TableBuilderEvent {
  GoToSectionPhase();
}

class HideTable extends TableBuilderEvent {
  int? tableId;
  int? groupId;
  HideTable({this.tableId, this.groupId});
}

class SectionClicked extends TableBuilderEvent {
  DineInGroup? group;
  SectionClicked({this.group});
}
