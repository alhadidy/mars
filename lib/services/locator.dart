import 'package:get_it/get_it.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/firestore/invites.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/firestore/orders.dart';
import 'package:mars/services/firestore/promos.dart';
import 'package:mars/services/firestore/settings.dart';
import 'package:mars/services/firestore/stores.dart';
import 'package:mars/services/firestore/users.dart';

final locator = GetIt.I;
void setupLocator() {
  locator.registerLazySingleton(() => Categories());
  locator.registerLazySingleton(() => Items());
  locator.registerLazySingleton(() => Invites());
  locator.registerLazySingleton(() => SSettings());
  locator.registerLazySingleton(() => Promos());
  locator.registerLazySingleton(() => Stores());
  locator.registerLazySingleton(() => Orders());
  locator.registerLazySingleton(() => Users());
}
