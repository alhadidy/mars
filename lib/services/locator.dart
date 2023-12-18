import 'package:get_it/get_it.dart';
import 'package:mars/services/firestore/addons.dart';
import 'package:mars/services/firestore/appointments.dart';
import 'package:mars/services/firestore/cards.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/firestore/editors.dart';
import 'package:mars/services/firestore/invites.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/firestore/orders.dart';
import 'package:mars/services/firestore/payments.dart';
import 'package:mars/services/firestore/promos.dart';
import 'package:mars/services/firestore/rewards.dart';
import 'package:mars/services/firestore/settings.dart';
import 'package:mars/services/firestore/sizes.dart';
import 'package:mars/services/firestore/stores.dart';
import 'package:mars/services/firestore/support.dart';
import 'package:mars/services/firestore/users.dart';

final locator = GetIt.I;
void setupLocator() {
  locator.registerLazySingleton(() => Appointments());
  locator.registerLazySingleton(() => Categories());
  locator.registerLazySingleton(() => Cards());
  locator.registerLazySingleton(() => Editors());
  locator.registerLazySingleton(() => Items());
  locator.registerLazySingleton(() => Invites());
  locator.registerLazySingleton(() => SSettings());
  locator.registerLazySingleton(() => Sizes());
  locator.registerLazySingleton(() => Addons());
  locator.registerLazySingleton(() => Promos());
  locator.registerLazySingleton(() => Stores());
  locator.registerLazySingleton(() => Support());
  locator.registerLazySingleton(() => Orders());
  locator.registerLazySingleton(() => Payments());
  locator.registerLazySingleton(() => Rewards());
  locator.registerLazySingleton(() => Users());
}
