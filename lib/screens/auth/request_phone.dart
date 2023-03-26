import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/providers.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RequestPhone extends ConsumerStatefulWidget {
  const RequestPhone({Key? key}) : super(key: key);

  @override
  _RequestPhoneState createState() => _RequestPhoneState();
}

class _RequestPhoneState extends ConsumerState<RequestPhone> {
  PhoneNumber? phone;
  bool phoneValidated = false;
  OtpFieldController otpFieldController = OtpFieldController();
  TextEditingController phoneController = TextEditingController();
  bool waitingTheCode = false;
  final int countDownDuration = 60;
  late int countDown;
  Timer? timer;
  String? _verificationId;

  String? errorMsg;

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  @override
  void initState() {
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
          Container(
            color: Theme.of(context).colorScheme.secondary,
            child: waitingTheCode
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35))),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 30),
                            child: Image.asset(
                              'assets/imgs/logo_trans.png',
                              width: MediaQuery.of(context).size.height / 5,
                              height: MediaQuery.of(context).size.height / 5,
                            ),
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
                            OTPTextField(
                              controller: otpFieldController,
                              length: 6,
                              width: MediaQuery.of(context).size.width,
                              fieldWidth: 50,
                              style: const TextStyle(fontSize: 17),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.box,
                              otpFieldStyle: OtpFieldStyle(
                                  focusBorderColor:
                                      Theme.of(context).colorScheme.secondary),
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
                                  phone = null;
                                  setState(() {
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
                              Text(phone?.phoneNumber ?? ''),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35))),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 30),
                            child: Image.asset(
                              'assets/imgs/logo_trans.png',
                              width: MediaQuery.of(context).size.height / 5,
                              height: MediaQuery.of(context).size.height / 5,
                            ),
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
                                  'قم بإدخال رقم الهاتف',
                                  style: GoogleFonts.tajawal(fontSize: 24),
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
                                  textStyle: const TextStyle(
                                      fontSize: 20, letterSpacing: 4),
                                  textAlign: TextAlign.center,
                                  inputDecoration: InputDecoration(
                                    filled: true,
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
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
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              onPressed: !phoneValidated
                                  ? null
                                  : () async {
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

                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      otpFieldController.setFocus(0);

                                      await verifyPhoneNumber();
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'التحقق من الرقم',
                                  style: GoogleFonts.tajawal(),
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
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
          )
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
