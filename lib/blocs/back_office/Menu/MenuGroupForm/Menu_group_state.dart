import 'package:invo_mobile/models/menu_group.dart';

abstract class MenuGroupLoadState {}

class MenuGroupIsLoading extends MenuGroupLoadState {}

class MenuGroupIsLoaded extends MenuGroupLoadState {
  final MenuGroup? menuGroup;
  MenuGroupIsLoaded(this.menuGroup);
}
