import 'package:invo_mobile/models/dineIn_group.dart';

abstract class TableGroupFormEvent {}

class SaveTableGroup extends TableGroupFormEvent {
  DineInGroup group;
  SaveTableGroup(this.group);
}
