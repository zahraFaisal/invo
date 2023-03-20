import 'package:invo_mobile/models/custom/role_list.dart';
import 'package:invo_mobile/models/role.dart';

class IRoleService {
  Future<List<RoleList>>? getActiveList() {}
  Future<List<RoleList>>? getList() {}
  Future<Role>? get(int id) {}
  void save(Role role) {}
  void update(Role role) {}
  Future<bool>? checkIfNameExists(Role role) {}
  Future<List<Role>>? getAllRoles() {}
  Future<bool>? saveIfNotExists(List<Role> roles) {}
}
