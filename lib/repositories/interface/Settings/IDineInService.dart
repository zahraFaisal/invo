import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/dineIn_table.dart';

abstract class IDineInService {
  Future<DineInGroup> saveSection(DineInGroup group);

  Future<List<DineInGroup>> loadSections();

  Future<List<DineInGroup>> getHiddenSections();

  getSection(int groupId) {}

  checkIfNameExists(DineInGroup group) {}

  loadTables() {}
  pickTables(List<DineInTable> tables) {}

  pickSections(List<DineInGroup> groups) {}
  checkIfTableNameExists(DineInTable table) {}

  void saveTable(DineInTable table) {}

  getTable(int tableId) {}
  Future<bool>? saveIfNotExists(List<DineInGroup> groups) {}
  saveTablePosition(DineInTable item) {}

  hideTable(int tableId) {}

  getAll() {}

  loadGroupTables(int groupId) {}

  getGroupHiddenTables(int groupId) {}
  delete(DineInGroup dineInGroup) {}
  fetchTablesStatus() {}
}
