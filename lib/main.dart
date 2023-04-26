import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mars/firebase_options.dart';
import 'package:mars/screens/auth/request_phone.dart';
import 'package:mars/screens/home/home.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/auth/auth.dart';
import 'package:mars/services/auth_service.dart';
import 'package:mars/services/firebase_links.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/providers.dart';
import 'package:mars/services/routes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  tz.initializeTimeZones();
  initializeDateFormatting();
  await Hive.initFlutter();
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

        FlutterNativeSplash.remove();

        if (user == null) {
          return const Authenticate();
        }

        if (user.phone == '' && !user.isAnon) {
          return const RequestPhone();
        }

        return const Home();
      }),
    );
  }
}
