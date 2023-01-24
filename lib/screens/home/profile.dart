import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_data.dart';
import 'package:mars/screens/auth/widgets/signin_apple_button.dart';
import 'package:mars/screens/auth/widgets/signin_google_button.dart';
import 'package:mars/screens/home/widgets/home_title.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/auth_service.dart';
import 'package:mars/services/firebase_links.dart';
import 'package:mars/services/firestore/users.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  String? error;
  String? loading;

  double setUserAccountRankPercent(int targetPoints, userPoints) {
    double percent = userPoints / targetPoints;
    return percent;
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    UserData userData = ref.watch(userDataProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(),
      );
    }

    double percent = 0;
    Color accountRankColor = Colors.indigo.shade800;
    IconData accountRankIcon = FontAwesomeIcons.solidStar;
    // String accountRankName = 'وردي';

    if (userData.points < 1000) {
      percent = setUserAccountRankPercent(1000, userData.points);
    } else if (userData.points >= 1000 && userData.points < 2000) {
      percent = setUserAccountRankPercent(2000, userData.points);
      accountRankColor = Colors.yellow.shade800;
      accountRankIcon = FontAwesomeIcons.fireFlameCurved;

      // accountRankName = 'ذهبي';
    } else {
      percent = setUserAccountRankPercent(5000, userData.points);
      accountRankColor = Colors.red.shade800;
      accountRankIcon = FontAwesomeIcons.bomb;
      // accountRankName = 'ذهبي';
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('الملف الشخصي'),
        actions: [
          user.isAnon
              ? Container()
              : IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                  ),
                  onPressed: () async {
                    Methods.showLoaderDialog(context);
                    await ref.read(dbProvider).localOrdersDao.clearTheOrder();

                    await AuthService().siginOut(user.uid);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                QrImage(
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    data: user.uid,
                    version: QrVersions.auto,
                    size: 300,
                    gapless: false,
                    foregroundColor: Colors.black,
                    dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle),
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle)),
                CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  radius: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: user.isAnon
                        ? const CircleAvatar(
                            radius: 50,
                            child: FaIcon(
                              FontAwesomeIcons.userSecret,
                              color: Colors.black,
                              size: 45,
                            ))
                        : CachedNetworkImage(
                            placeholder: (context, url) {
                              return const CircleAvatar(
                                radius: 50,
                              );
                            },
                            errorWidget: ((context, url, error) {
                              return const CircleAvatar(
                                radius: 50,
                              );
                            }),
                            imageUrl: user.photoUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            Text(user.isAnon ? "لم تقم بتسجيل الدخول" : user.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  user.isAnon
                      ? "جميع المعلومات الخاصة بك معرضة للفقدان"
                      : user.email,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                      fontWeight: FontWeight.w600, color: Colors.black)),
            ),
            user.isAnon
                ? const Divider(
                    indent: 8,
                    endIndent: 8,
                  )
                : Container(),
            error != null && user.isAnon
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.circleExclamation),
                  )
                : Container(),
            error != null && user.isAnon
                ? Text(
                    error ?? '',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.tajawal(height: 1.5, color: Colors.black),
                  )
                : Container(),
            user.isAnon
                ? SignInGoogleButton(loading, (err) {
                    setState(() {
                      error = err ?? '';
                    });
                  }, (loadingChanged) {
                    setState(() {
                      loading = loadingChanged ?? '';
                    });
                  })
                : Container(),
            user.isAnon
                ? SignInAppleButton(loading, (err) {
                    setState(() {
                      error = err ?? '';
                    });
                  }, (loadingChanged) {
                    setState(() {
                      loading = loadingChanged ?? '';
                    });
                  })
                : Container(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: HomeTabTitle(
                  title: 'اجمع النقاط وطور حسابك', titleColor: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: RoundIconButton(
                            onTap: () {},
                            icon: accountRankIcon,
                            iconSize: 18,
                            size: 30,
                            color: accountRankColor,
                          )),
                      Text(
                        Methods.formatPrice(userData.points),
                        style:
                            const TextStyle(fontSize: 35, color: Colors.black),
                      ),
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 6.0,
                    backgroundWidth: 4,
                    animation: true,
                    animationDuration: 1500,
                    animateFromLastPercent: true,
                    percent: percent,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: accountRankColor,
                  ),
                ],
              ),
            ),

            const Divider(
              height: 16,
              indent: 8,
              endIndent: 8,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: const Text('قم بدعوة صديق'),
                subtitle: const Text(
                  'احصل على نقاط اضافية عن كل شخص يقوم بتسجيل الدخول عن طريق رابط الدعوة الخاص بك',
                  style: TextStyle(color: Colors.black),
                ),
                leading: FaIcon(
                  FontAwesomeIcons.solidEnvelope,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onTap: () async {
                  Methods.showLoaderDialog(context);
                  String url = await LinkService().createDynamicLink(
                      title: 'Mars Coffee House',
                      desc: 'حمل تطبيق مارس واستمتع بالعروض الحصرية',
                      page: 'invite',
                      pageId: user.uid);
                  Navigator.pop(context);

                  Share.share(url);
                },
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 8),
            //   child: HomeTabTitle(
            //       title: 'اجمع النقاط وطور حسابك', titleColor: Colors.black),
            // ),
            // Row(
            //   children: [
            //     SizedBox(
            //         width: MediaQuery.of(context).size.width / 3,
            //         height: MediaQuery.of(context).size.width / 3,
            //         child: Card(
            //           shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(100))),
            //           color: Theme.of(context).colorScheme.secondary,
            //           child: Center(
            //               child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(4.0),
            //                 child: RoundIconButton(
            //                   icon: FontAwesomeIcons.solidGem,
            //                   iconColor: Colors.red.shade800,
            //                   iconSize: 20,
            //                   color: Colors.white,
            //                   onTap: null,
            //                 ),
            //               ),
            //               const Padding(
            //                 padding: EdgeInsets.all(2.0),
            //                 child: Text(
            //                   'ماسي',
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.bold),
            //                 ),
            //               ),
            //               const Padding(
            //                 padding: EdgeInsets.all(4.0),
            //                 child: Text('> 2000'),
            //               ),
            //             ],
            //           )),
            //         )),
            //     SizedBox(
            //         width: MediaQuery.of(context).size.width / 3,
            //         height: MediaQuery.of(context).size.width / 3,
            //         child: Card(
            //           shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(100))),
            //           color: Theme.of(context).colorScheme.secondary,
            //           child: Center(
            //               child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(4.0),
            //                 child: RoundIconButton(
            //                   icon: FontAwesomeIcons.fireFlameCurved,
            //                   iconColor: Colors.yellow.shade800,
            //                   iconSize: 20,
            //                   color: Colors.black,
            //                   onTap: null,
            //                 ),
            //               ),
            //               const Padding(
            //                 padding: EdgeInsets.all(2.0),
            //                 child: Text(
            //                   'ذهبي',
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.bold),
            //                 ),
            //               ),
            //               const Padding(
            //                 padding: EdgeInsets.all(4.0),
            //                 child: Text('< 2000'),
            //               ),
            //             ],
            //           )),
            //         )),
            //     SizedBox(
            //         width: MediaQuery.of(context).size.width / 3,
            //         height: MediaQuery.of(context).size.width / 3,
            //         child: Card(
            //           shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(100))),
            //           color: Theme.of(context).colorScheme.secondary,
            //           child: Center(
            //               child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(4.0),
            //                 child: RoundIconButton(
            //                   icon: FontAwesomeIcons.solidStar,
            //                   iconColor: Colors.indigo.shade800,
            //                   iconSize: 20,
            //                   color: Colors.black,
            //                   onTap: null,
            //                 ),
            //               ),
            //               const Padding(
            //                 padding: EdgeInsets.all(2.0),
            //                 child: Text(
            //                   'اساسي',
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.bold),
            //                 ),
            //               ),
            //               const Padding(
            //                 padding: EdgeInsets.all(4.0),
            //                 child: Text('< 1000'),
            //               ),
            //             ],
            //           )),
            //         )),
            //   ],
            // ),
            const Divider(
              indent: 8,
              endIndent: 8,
            ),
            user.isAnon
                ? Container()
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: const Text('المحفظة'),
                      leading: FaIcon(
                        FontAwesomeIcons.wallet,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      trailing:
                          Text('${Methods.formatPrice(userData.cash)} د.ع'),
                      onTap: () {
                        Navigator.pushNamed(context, '/wallet');
                      },
                    )),
            const Divider(
              indent: 8,
              endIndent: 8,
            ),
            user.isAnon
                ? Container()
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: const Text('تسجيل الخروج'),
                      leading: FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onTap: () async {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Methods.showLoaderDialog(context);

                        await ref
                            .read(dbProvider)
                            .localOrdersDao
                            .clearTheOrder();

                        await AuthService().siginOut(user.uid);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                title: const Text('حذف الحساب'),
                leading: const FaIcon(
                  FontAwesomeIcons.trash,
                  color: Colors.red,
                ),
                onTap: () async {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  Methods.showConfirmDialog(context,
                      'هل انت متأكد من حذف الحساب بالكامل؟ جميع المعلومات الخاصة بك سوف تحذف بشكل نهائي',
                      () async {
                    Methods.showLoaderDialog(context);
                    await ref.read(dbProvider).localOrdersDao.clearTheOrder();

                    await AuthService().deleteAccount(user.uid);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
