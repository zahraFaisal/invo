import 'package:invo_mobile/models/dineIn_group.dart';

abstract class TableBuilderPhaseState {}

class SectionsPhase extends TableBuilderPhaseState {}

class TablesPhase extends TableBuilderPhaseState {
  final DineInGroup group;
  TablesPhase(this.group);
}
