import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: StorageManager.readData('intro'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        AsyncValue<SSetting> stream = ref.watch(shopSettingsStreamProvider);
        return stream.when(data: (data) {
          if (data.dev) {
            return const Signin();
          }
          var intro = snapshot.data;
          if (intro == true || intro == '') {
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
      },
    );
  }
}
