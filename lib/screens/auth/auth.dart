import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/screens/auth/intro.dart';
import 'package:mars/screens/auth/signin.dart';
import 'package:mars/services/providers.dart';

class Authenticate extends ConsumerStatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  AuthenticateState createState() => AuthenticateState();
}

class AuthenticateState extends ConsumerState<Authenticate> {
  Box settings = Hive.box('settings');

  @override
  Widget build(BuildContext context) {
    AsyncValue<SSetting> stream = ref.watch(shopSettingsStreamProvider);

    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(keys: ['intro']),
        builder: ((context, box, child) {
          bool intro = box.get('intro', defaultValue: false);

          return stream.when(data: (data) {
            if (data.dev) {
              return const Scaffold(
                body: Center(child: Text('التطبيق حاليا تحت الصيانة')),
              );
            }
            if (intro == true) {
              return const Signin();
            } else {
              return Intro(
                onNext: () {
                  setState(() {});
                },
                onSkip: () {
                  setState(() {});
                },
              );
            }
          }, error: (err, trace) {
            return const Signin();
          }, loading: () {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          });
        }));
  }
}
