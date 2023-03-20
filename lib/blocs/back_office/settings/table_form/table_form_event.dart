import 'package:invo_mobile/models/dineIn_table.dart';

abstract class TableFormEvent {}

class SaveTable implements TableFormEvent {
  DineInTable table;
  SaveTable(this.table);
}
