import 'package:invo_mobile/models/custom/table_status.dart';
import 'package:invo_mobile/models/dineIn_group.dart';
import 'package:invo_mobile/models/dineIn_table.dart';
import 'package:invo_mobile/repositories/interface/Settings/IDineInService.dart';

class DineInInvoService implements IDineInService {
  @override
  checkIfNameExists(DineInGroup group) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  checkIfTableNameExists(DineInTable table) {
    // TODO: implement checkIfTableNameExists
    throw UnimplementedError();
  }

  @override
  fetchTablesStatus() {
    // TODO: implement fetchTablesStatus
    throw UnimplementedError();
  }

  @override
  getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  getSection(int groupId) {
    // TODO: implement getSection
    throw UnimplementedError();
  }

  @override
  getTable(int tableId) {
    // TODO: implement getTable
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<DineInGroup> groups) {
    throw UnimplementedError();
  }

  @override
  loadGroupTables(int groupId) {
    // TODO: implement loadGroupTables
    throw UnimplementedError();
  }

  @override
  getGroupHiddenTables(int groupId) {
    // TODO: implement loadGroupTables
    throw UnimplementedError();
  }

  @override
  Future<List<DineInGroup>> loadSections() {
    // TODO: implement loadSections
    throw UnimplementedError();
  }

  @override
  Future<List<DineInGroup>> getHiddenSections() {
    throw UnimplementedError();
  }

  @override
  loadTables() {
    // TODO: implement loadTables
    throw UnimplementedError();
  }

  @override
  pickTables(List<DineInTable> tables) {
    // TODO: implement loadTables
    throw UnimplementedError();
  }

  @override
  pickSections(List<DineInGroup> groups) {
    throw UnimplementedError();
  }

  @override
  Future<DineInGroup> saveSection(DineInGroup group) {
    // TODO: implement saveSection
    throw UnimplementedError();
  }

  @override
  void saveTable(DineInTable table) {
    // TODO: implement saveTable
  }

  @override
  saveTablePosition(DineInTable item) {
    // TODO: implement saveTablePosition
    throw UnimplementedError();
  }

  @override
  hideTable(int tableId) async {
    // TODO: implement saveTablePosition
    throw UnimplementedError();
  }

  @override
  void delete(DineInGroup dineInGroup) {
    // TODO: implement delete
  }
}
