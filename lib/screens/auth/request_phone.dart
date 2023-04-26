import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/providers.dart';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RequestPhone extends ConsumerStatefulWidget {
  const RequestPhone({Key? key}) : super(key: key);

  @override
  _RequestPhoneState createState() => _RequestPhoneState();
}

class _RequestPhoneState extends ConsumerState<RequestPhone> {
  PhoneNumber? phone;
  bool phoneValidated = false;
  late TextEditingController otpFieldController;
  late TextEditingController phoneController;
  bool waitingTheCode = false;
  final int countDownDuration = 60;
  late int countDown;
  Timer? timer;
  String? _verificationId;

  String? errorMsg;

  @override
  void dispose() {
    phoneController.dispose();
    otpFieldController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    otpFieldController = TextEditingController();
    phoneController = TextEditingController();
    countDown = countDownDuration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ref.watch(userProvider);
    if (user == null) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: -100,
            left: -100,
            child: Opacity(
                opacity: 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  height: 400,
                  width: 400,
                  child: Image.asset(
                    'assets/imgs/logo_trans_croped.png',
                  ),
                )),
          ),
          waitingTheCode
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Image.asset(
                          'assets/imgs/logo.jpg',
                          width: MediaQuery.of(context).size.height / 5,
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              errorMsg ?? '',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                  fontSize: 18, color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'قم بإدخال رمز التحقق',
                              style: GoogleFonts.tajawal(fontSize: 24),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PinCodeTextField(
                              appContext: context,
                              onChanged: (value) {},
                              controller: otpFieldController,
                              autoDisposeControllers: false,
                              length: 6,
                              keyboardType: TextInputType.number,
                              autoFocus: true,
                              onCompleted: (pin) async {
                                if (_verificationId == null) {
                                  return;
                                }
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationId!,
                                        smsCode: pin);
                                try {
                                  await FirebaseAuth.instance.currentUser!
                                      .linkWithCredential(credential);
                                } catch (e) {
                                  if (e is FirebaseAuthException) {
                                    switch (e.code) {
                                      case "credential-already-in-use":
                                        setState(() {
                                          errorMsg =
                                              'هذا الرقم غير متوفر الرجاء اضافة رقم جديد او تسجيل الدخول عن طريق حساب اخر';
                                        });
                                        break;
                                      case "session-expired":
                                        setState(() {
                                          errorMsg =
                                              'انتهت صلاحية رسالة التحقق';
                                        });
                                        break;
                                      default:
                                        setState(() {
                                          errorMsg =
                                              'حدثت مشكلة اثناء اضافة رقم الهاتف\nالرجاء المحاولة لاحقاً';
                                        });
                                    }
                                  }
                                  inspect(e);
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(countDown.toString()),
                                GestureDetector(
                                  onTap: () async {
                                    if (countDown != 0) {
                                      return;
                                    }

                                    otpFieldController.clear();

                                    await verifyPhoneNumber();

                                    setState(() {
                                      errorMsg = null;
                                      countDown = countDownDuration;
                                    });
                                    timer = Timer.periodic(
                                        const Duration(seconds: 1), (timer) {
                                      setState(() {
                                        countDown--;
                                      });
                                      if (countDown == 0) {
                                        timer.cancel();
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      'اعادة الارسال',
                                      style: TextStyle(
                                        color: countDown == 0
                                            ? Colors.blue
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        decoration: countDown == 0
                                            ? TextDecoration.underline
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (countDown != 0) {
                                  return;
                                }
                                timer?.cancel();
                                phoneController.clear();
                                otpFieldController.clear();
                                setState(() {
                                  phone = null;
                                  waitingTheCode = false;
                                  errorMsg = null;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'تغيير رقم الهاتف',
                                  style: TextStyle(
                                    color: countDown == 0
                                        ? Colors.blue
                                        : Theme.of(context).colorScheme.primary,
                                    decoration: countDown == 0
                                        ? TextDecoration.underline
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            Text(phone?.phoneNumber ?? ''),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            errorMsg ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                                fontSize: 18, color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'قم بإدخال رقم الهاتف',
                            style: GoogleFonts.tajawal(fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'سوف نقوم بإرسال رمز التحقق الى هذا الرقم من أجل إتمام عملية إضافة رقم الهاتف',
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.tajawal(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InternationalPhoneNumberInput(
                            keyboardType: TextInputType.number,
                            textFieldController: phoneController,
                            onInputChanged: (value) {
                              setState(() {
                                phone = value;
                              });
                            },
                            onInputValidated: (value) {
                              setState(() {
                                phoneValidated = value;
                              });
                            },
                            countries: const ['IQ'],
                            locale: 'ar',
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            errorMessage: 'رقم الهاتف غير صالح',
                            autoFocus: true,
                            textStyle:
                                const TextStyle(fontSize: 20, letterSpacing: 4),
                            textAlign: TextAlign.center,
                            inputDecoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            ),
                            selectorConfig: const SelectorConfig(
                                useEmoji: true,
                                leadingPadding: 16,
                                setSelectorButtonAsPrefixIcon: true,
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          Positioned(
            top: 50,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Center(
                child: ClipOval(
                    child: CachedNetworkImage(
                  height: 36,
                  width: 36,
                  fit: BoxFit.cover,
                  imageUrl: user.photoUrl,
                  placeholder: (context, url) {
                    return ClipOval(
                        child: Container(
                      color: Colors.amberAccent,
                    ));
                  },
                  errorWidget: ((context, url, error) {
                    return ClipOval(
                        child: Container(
                      color: Colors.amberAccent,
                    ));
                  }),
                )),
              ),
            ),
          ),
          !waitingTheCode
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          color: Colors.white,
                        ),
                        onPressed: !phoneValidated
                            ? null
                            : () async {
                                if (phoneController.text.isEmpty) {
                                  return;
                                }
                                setState(() {
                                  waitingTheCode = true;
                                  countDown = countDownDuration;
                                });

                                timer = Timer.periodic(
                                    const Duration(seconds: 1), (timer) {
                                  setState(() {
                                    countDown--;
                                  });
                                  if (countDown == 0) {
                                    timer.cancel();
                                  }
                                });

                                await verifyPhoneNumber();
                              },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)))),
                        tooltip: 'التحقق من الرقم',
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone!.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        inspect(credential);
        print('linked user');

        try {
          await FirebaseAuth.instance.currentUser!
              .linkWithCredential(credential);
        } catch (e) {
          print(e);
          print('not linked user');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        switch (e.code) {
          case 'too-many-requests':
            setState(() {
              errorMsg =
                  'لقد تم ايقاف هذه الخدمة مؤقتاً نتيجة الاستعمال غير المعتاد\nيرجى المحاولة لاحقاً';
            });
            break;
          default:
            setState(() {
              errorMsg = e.message;
            });
        }

        inspect(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }
}
