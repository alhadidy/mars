import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mars/firebase_options.dart';
import 'package:mars/screens/home/home.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/auth/auth.dart';
import 'package:mars/services/auth_service.dart';
import 'package:mars/services/firebase_links.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/providers.dart';
import 'package:mars/services/routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  tz.initializeTimeZones();
  await initializeDateFormatting();
  final doc = await getApplicationDocumentsDirectory();
  Directory dbDirectory =
      await Directory('${doc.path}/Modern Clinic/Database/Hive')
          .create(recursive: true);
  Hive.init(dbDirectory.path);
  await Hive.openBox('settings');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    LinkService.initDynamicLinks(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ref.watch(prefProvider.select((value) => value.theme));
    ref.listen<int>(rolesProvider.select((value) => value.refreshTime),
        (int? oldTime, int newTime) async {
      Box settings = Hive.box('settings');
      dynamic savedTime = settings.get('refreshTime');
      savedTime == null ? savedTime = 0 : savedTime = savedTime;

      if (newTime > savedTime) {
        settings.put('refreshTime', newTime);
        UserModel? user = ref.read(userProvider);
        AuthService().refreshToken(ref, user, true);
      } else {
        UserModel? user = ref.read(userProvider);
        AuthService().refreshToken(ref, user, false);
      }
    });
    return MaterialApp(
      title: 'Mars Coffee House',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: theme,
      onGenerateRoute: RoutesHelper.goToRoute,
      home: Consumer(builder: (context, ref, child) {
        UserModel? user = ref.watch(userProvider);

        return user == null ? const Authenticate() : const Home();
      }),
    );
  }
}
