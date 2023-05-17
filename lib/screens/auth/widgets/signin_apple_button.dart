import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/link.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/auth_service.dart';
import 'package:mars/services/providers.dart';

typedef OnErrorCallback = void Function(String? error);
typedef OnLoadingChangeCallback = void Function(String? loading);

class SignInAppleButton extends ConsumerStatefulWidget {
  final String? loading;
  final OnErrorCallback onError;
  final OnLoadingChangeCallback onLoadingChange;
  const SignInAppleButton(this.loading, this.onError, this.onLoadingChange,
      {super.key});

  @override
  SignInAppleButtonState createState() => SignInAppleButtonState();
}

class SignInAppleButtonState extends ConsumerState<SignInAppleButton> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    Link link = ref.watch(linkProvider);
    bool isIos = Platform.isIOS;
    if (isIos) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: widget.loading == null
              ? () async {
                  widget.onLoadingChange('apple');
                  String? inviteId;
                  if (link.page == "/invite" && link.arg != null) {
                    inviteId = link.arg;
                  }
                  dynamic result =
                      await _auth.signInWithApple(user, null, inviteId);
                  // debugPrint("amc " + result.toString());
                  if (result == null) {
                    widget.onError(
                        'حدثت مشكلة أثناء تسجيل الدخول \n الرجاء المحاولة مرة أخرى');
                    widget.onLoadingChange(null);

                    debugPrint('error signing in');
                  } else if (result is OAuthCredential) {
                    widget.onLoadingChange(null);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'تسجيل الدخول',
                                textAlign: TextAlign.center,
                              ),
                              Divider()
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () async {
                                String? inviteId;
                                if (link.page == "/invite" &&
                                    link.arg != null) {
                                  inviteId = link.arg;
                                }
                                dynamic r = await _auth.signInWithApple(
                                    user, result, inviteId);
                                if (r == null) {
                                  widget.onError(
                                      'حدثت مشكلة أثناء تسجيل الدخول \n الرجاء المحاولة مرة أخرى');
                                  widget.onLoadingChange(null);

                                  debugPrint('error signing in');
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('تسجيل الدخول'),
                            )
                          ],
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'لقد قمت مسبقاً بإنشاء حساب مستخدماً هذا البريد الألكتروني، يمكنك تسجيل الدخول أو العودة وإنشاء حساب جديد عن طريق بريد آخر.',
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.tajawal(
                                    fontSize: 16, height: 1.5),
                              ),
                              const Divider(),
                              Text(
                                'عند تسجيل الدخول سوف تفقد جميع البيانات الخاصة بالطلبات الحالية، قم بإنشاء حساب جديد إن كنت ترغب بالحفاظ على هذه البيانات.',
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.rtl,
                                style: GoogleFonts.tajawal(
                                    fontSize: 12, height: 1.3),
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    widget.onError(null);
                    widget.onLoadingChange(null);
                    debugPrint('signed in');
                    debugPrint(result.toString());
                  }
                }
              : null,
          child: widget.loading == 'apple'
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FaIcon(FontAwesomeIcons.apple, color: Colors.white),
                    ],
                  ),
                ),
        ),
      );
    } else {
      return Container();
    }
  }
}
