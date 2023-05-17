
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Image.asset(
                          'assets/imgs/logo.jpg',
                          height: 150,
                        ),
                      ),
                      const Text(
                        'MARS',
                        style: TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ),
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
              Stack(
                children: [
                  Image.asset(
                    'assets/imgs/shape.png',
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 50,
                    left: 50,
                    child: Column(
                      children: [
                        link.page == "/invite"
                            ? Text(
                                'عن طريق دعوة',
                                style: GoogleFonts.tajawal(
                                    height: 2.5, color: Colors.white),
                              )
                            : Container(),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'جميع الحقوق محفوظة لصالح Mars Coffee House',
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                              color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              side: const BorderSide(color: Colors.white),
                            ),
                            onPressed: loading == null
                                ? () async {
                                    setState(() {
                                      loading = 'skip';
                                    });
                                    dynamic result =
                                        await _auth.siginInAnonymous();

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
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
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
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'تخطي تسجيل الدخول',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
