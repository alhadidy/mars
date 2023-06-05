import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mars/firebase_options.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/models/user_data.dart';
import 'package:mars/screens/auth/collect_info.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

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

    UserModel? user = ref.watch(userProvider);

    UserData userData = ref.watch(userDataProvider);

    SSetting settings = ref.watch(shopSettingsProvider);
    ref.listen<int>(rolesProvider.select((value) => value.refreshTime),
        (int? oldTime, int newTime) async {
      Box localSettings = Hive.box('settings');
      dynamic savedTime = localSettings.get('refreshTime');
      savedTime == null ? savedTime = 0 : savedTime = savedTime;

      if (newTime > savedTime) {
        localSettings.put('refreshTime', newTime);
        AuthService().refreshToken(ref, user, true);
      } else {
        AuthService().refreshToken(ref, user, false);
      }
    });
    return MaterialApp(
      title: 'Mars Coffee House',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: theme,
      onGenerateRoute: RoutesHelper.goToRoute,
      home: Builder(builder: (context) {
        if (user == null) {
          return const Authenticate();
        }
        if (settings.dev == true) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                      child: Image.asset(
                    'assets/imgs/logo_dark.png',
                    height: 100,
                    width: 100,
                  )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'التطبيق متوقف حالياً للصيانة',
                      style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Text(
                    'الرجاء المحاولة لاحقاً',
                    style: GoogleFonts.tajawal(),
                  ),
                  user.role == Roles.admin
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Text('Welcome ' + user.name),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/adminSettings');
                                },
                                child: const Text('Settings')),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          );
        }

        if (user.phone == '' && !user.isAnon) {
          return const RequestPhone();
        }

        if (userData.info == null) {
          return const CollectInfo();
        }

        return const Home();
      }),
    );
  }
}
