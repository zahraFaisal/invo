import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/role.dart';
import 'package:invo_mobile/repositories/interface/Employee/IRoleServices.dart';
import 'package:sqflite/sqflite.dart';

class RoleInvoService implements IRoleService {
  @override
  Future<bool> checkIfNameExists(Role role) {
    // TODO: implement checkIfNameExists
    throw UnimplementedError();
  }

  @override
  Future<Role> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<RoleList>> getActiveList() {
    // TODO: implement getActiveList
    throw UnimplementedError();
  }

  @override
  Future<List<RoleList>> getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  void save(Role role) {
    // TODO: implement save
  }
  @override
  Future<List<Role>> getAllRoles() {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIfNotExists(List<Role> roles) {
    throw UnimplementedError();
  }

  @override
  void update(Role role) {
    // TODO: implement update
  }
}
