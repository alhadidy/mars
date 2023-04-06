import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_data.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Scan extends ConsumerStatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends ConsumerState<Scan> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    UserData userData = ref.watch(userDataProvider);
    if (user == null) {
      return Container();
    }
    return Stack(
      children: [
        Center(
          child: Card(
            elevation: 100,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 100,
                  width: 250,
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.solidStar,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 40,
                    ),
                  ),
                ),
                QrImage(
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    data: user.uid,
                    version: QrVersions.auto,
                    size: 200,
                    gapless: false,
                    dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: Colors.black),
                    eyeStyle: QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: user.role == Roles.user
                            ? Colors.black
                            : Theme.of(context).colorScheme.secondary)),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'احصل على نقاط اضافية بعد كل عملية دفع أو بعد شراء بطاقات الهدايا الخاصة بمارس',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(height: 1.5),
                    ),
                  ),
                ),
                user.isAnon
                    ? Container(
                        width: 0,
                      )
                    : SizedBox(
                        width: 250,
                        child: Text(
                          "رصيد المحفظة",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(height: 1.5),
                        ),
                      ),
                user.isAnon
                    ? Container(
                        width: 0,
                      )
                    : SizedBox(
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            Methods.formatPrice(userData.cash) + ' د.ع',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.tajawal(
                                height: 1.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        SizedBox(
            height: 100,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ),
                      child: RoundIconButton(
                        onTap: () {},
                        icon: FontAwesomeIcons.solidStar,
                        iconSize: 18,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Text(
                    Methods.formatPrice(userData.points),
                    style: const TextStyle(fontSize: 35, color: Colors.black),
                  ),
                ],
              ),
            )),
        user.isAnon
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.tajawal(height: 2),
                        ),
                      )),
                ))
            : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      onPressed: () {
                        Navigator.pushNamed(context, '/wallet');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'اضافة رصيد الى المحفظة',
                          style: GoogleFonts.tajawal(height: 2),
                        ),
                      )),
                ))
      ],
    );
  }
}
