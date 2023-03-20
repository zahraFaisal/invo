import 'package:invo_mobile/models/role.dart';

abstract class RoleLoadState {}

class RoleIsLoading extends RoleLoadState {}

class RoleIsLoaded extends RoleLoadState {
  final Role role;
 RoleIsLoaded(this.role);
}