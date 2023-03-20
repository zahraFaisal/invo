import 'package:invo_mobile/models/role.dart';

abstract class RoleFormEvent {}

class SaveRole extends RoleFormEvent{
  Role role;
  SaveRole(this.role);
} 
