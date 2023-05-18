import 'package:get_it/get_it.dart';
import 'service/admin_service.dart';
import 'service/vehicle_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => VehicleService());
  locator.registerLazySingleton(() => AdminService());
}
