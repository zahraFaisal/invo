import 'package:invo_mobile/models/dineIn_table.dart';

abstract class TableLoadState {}

class TableIsLoading extends TableLoadState {}

class TableIsLoaded extends TableLoadState {
  final DineInTable table;
  TableIsLoaded(this.table);
}
