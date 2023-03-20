import 'package:get_it/get_it.dart';
import 'helpers/dialog_service.dart';
import 'models/global.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  // Register services
  // locator.registerLazySingleton<ConnectionRepository>(
  //     () => ConnectionRepository());
  locator.registerLazySingleton(() => DialogService());
  locator.registerSingleton<Global>(new Global());

  locator.allowReassignment = true;
  // Register models
  
}
