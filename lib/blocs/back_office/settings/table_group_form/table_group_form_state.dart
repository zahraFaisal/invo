import 'package:invo_mobile/models/dineIn_group.dart';

abstract class TableGroupLoadState {}

class TableGroupIsLoading extends TableGroupLoadState {}

class TableGroupIsLoaded extends TableGroupLoadState {
  final DineInGroup group;
  TableGroupIsLoaded(this.group);
}
