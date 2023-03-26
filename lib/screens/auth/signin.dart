import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mars/models/link.dart';
import 'package:mars/screens/auth/widgets/signin_apple_button.dart';
import 'package:mars/screens/auth/widgets/signin_google_button.dart';
import 'package:mars/services/auth_service.dart';
import 'package:mars/services/providers.dart';

class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  @override
  SigninState createState() => SigninState();
}

class SigninState extends ConsumerState<Signin> {
  final AuthService _auth = AuthService();
  String? error;
  String? loading;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Link link = ref.watch(linkProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.primary,
            statusBarIconBrightness: Brightness.light),
        centerTitle: true,
        title: const Text('تسجيل الدخول'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      'assets/imgs/login.png',
                    ),
                  ),
                ),
              ),
            ),
            link.page == "/invite"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.solidEnvelopeOpen,
                          color: Theme.of(context).textTheme.headline2!.color,
                        ),
                      ),
                      Text(
                        'عن طريق دعوة',
                        style: GoogleFonts.tajawal(height: 2.5),
                      ),
                    ],
                  )
                : Container(),
            error != null
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.exclamationCircle),
                  )
                : Container(),
            error != null
                ? Text(
                    error ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(height: 1.5),
                  )
                : Container(),
            SignInGoogleButton(loading, (err) {
              if (mounted) {
                setState(() {
                  error = err;
                });
              }
            }, (loadingChanged) {
              if (mounted) {
                setState(() {
                  loading = loadingChanged;
                });
              }
            }),
            SignInAppleButton(loading, (err) {
              if (mounted) {
                setState(() {
                  error = err;
                });
              }
            }, (loadingChanged) {
              if (mounted) {
                setState(() {
                  loading = loadingChanged;
                });
              }
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1!.color!),
                  primary: Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: loading == null
                    ? () async {
                        setState(() {
                          loading = 'skip';
                        });
                        dynamic result = await _auth.siginInAnonymous();

                        if (result == null) {
                          setState(() {
                            error =
                                'حدثت مشكلة أثناء تسجيل الدخول \n الرجاء المحاولة مرة أخرى';
                            loading = null;
                          });
                          debugPrint('error signing in');
                        } else {
                          debugPrint('signed in');
                          debugPrint(result);
                        }
                      }
                    : null,
                child: loading == 'skip'
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'تخطي تسجيل الدخول',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // GestureDetector(
            //   onTap: () async {
            //     String txt = await rootBundle
            //         .loadString('assets/text/terms_and_conditions.txt');
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return Card(
            //             child: SingleChildScrollView(
            //               child: Stack(
            //                 children: [
            //                   IconButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       icon: const FaIcon(FontAwesomeIcons.xmark)),
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(
            //                         horizontal: 8, vertical: 50),
            //                     child: Text(txt),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           );
            //         });
            //   },
            //   child: const Padding(
            //     padding: EdgeInsets.only(bottom: 30),
            //     child: Text(
            //       'سياسة الخصوصية وأحكام الأستخدام',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(color: Colors.blue),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
