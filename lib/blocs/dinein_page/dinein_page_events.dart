import 'package:invo_mobile/models/dineIn_table.dart';

abstract class DineInPageEvent {}

class TableClick extends DineInPageEvent {
  DineInTable table;
  TableClick(this.table);
}

class GoToRecallPage extends DineInPageEvent {}

class DineInPageGoBack extends DineInPageEvent {}
