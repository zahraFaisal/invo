import 'package:invo_mobile/models/role.dart';

abstract class RoleListEvent {}

class LoadRole extends RoleListEvent {}

class DeleteRole extends RoleListEvent {
 
  Role role;
  DeleteRole(this.role);
}