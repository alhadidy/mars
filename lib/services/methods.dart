import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mars/models/order.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class Methods {
  static void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("يرجى الإنتظار")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static initFCM(context) async {
    await Permission.notification.isDenied.then((value) async {
      if (value) {
        Permission.notification.request();
      }
    });
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    messaging.subscribeToTopic('allUsers');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      inspect(message);

      if (message.notification != null) {
        NotificationsApi.showNotification(
            title: message.notification?.title,
            body: message.notification?.body,
            payload: jsonEncode(message.data));
      }
    });
  }

  static void showConfirmDialog(
      BuildContext context, String header, Function() confirm,
      {required String confirmActionText}) {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: const Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          'يرجى الإنتباه',
          style: TextStyle(color: Colors.red),
        ),
      ),
      content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            header,
            style: const TextStyle(height: 1.5),
          )),
      actions: [
        TextButton(
          child: const Text('إلغاء'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(
            confirmActionText,
            style: const TextStyle(color: Colors.red),
          ),
          onPressed: confirm,
        )
      ],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showSnack(BuildContext context, String contentmessage, bool? connected,
      {Duration duration = const Duration(seconds: 5)}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        // margin: EdgeInsets.only(right: 30, left: 30, bottom: 8),
        backgroundColor: Colors.transparent,
        duration: duration,
        content: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  connected != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: connected
                              ? const FaIcon(
                                  FontAwesomeIcons.wifi,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.wifi,
                                  color: Color(0xff566781),
                                  size: 18,
                                ),
                        )
                      : Container(),
                  Text(
                    contentmessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  static String getRandomString(int length) {
    String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static String getRandomNumber({int length = 10}) {
    String chars = '1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static String formatOrderNum(String num) {
    return '${num.substring(0, 4)}-${num.substring(4, 8)}';
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  //  Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<bool> isLocationAvailable() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('قم بتفعيل خدمات الموقع وحاول مرة اخرى');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('لقد تم رفض الوصول الى احداثيات الموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'لقد تم رفض الوصول الى احداثيات الموقع بشكل تام\n قم بتفعيل الخدمة من اعدادات الجهاز');
    }
    return true;
  }

  static Future<LatLng> determinePosition() async {
    return isLocationAvailable().then((value) async {
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }).onError((error, stackTrace) =>
        Future.error(error ?? 'حدثت مشكلة اثناء تحديد الموقع'));
  }

  static String formatDate(Timestamp? time, String local) {
    DateTime? date;
    if (time == null) {
      return '';
    }
    if (time.millisecondsSinceEpoch != 0) {
      date = DateTime.fromMicrosecondsSinceEpoch(
        time.millisecondsSinceEpoch * 1000,
      );
    }
    String formattedDate;
    date == null
        ? formattedDate = ''
        : formattedDate = intl.DateFormat('yMMMMEEEEd', local).format(date);

    return formattedDate;
  }

  static String formatDateShorter(Timestamp? time) {
    DateTime? date;
    if (time == null) {
      return '';
    }
    if (time.millisecondsSinceEpoch != 0) {
      date = DateTime.fromMicrosecondsSinceEpoch(
        time.millisecondsSinceEpoch * 1000,
      );
    }
    String formattedDate;
    date == null
        ? formattedDate = ''
        : formattedDate = intl.DateFormat('MMMd', 'ar').format(date);

    return formattedDate;
  }

  static String formatTime(Timestamp? time, String local) {
    DateTime? date;
    if (time == null) {
      return '';
    }
    if (time.millisecondsSinceEpoch != 0) {
      date = DateTime.fromMicrosecondsSinceEpoch(
        time.millisecondsSinceEpoch * 1000,
      );
    }
    String formattedDate;
    date == null
        ? formattedDate = ''
        : formattedDate = intl.DateFormat('jm', local).format(date);

    return formattedDate;
  }

  static nameShort(String name) {
    List<String> parts = name.split(" ");
    String short = "";
    for (var element in parts) {
      if (element.isNotEmpty) {
        short = short + element[0];
      }
    }
    if (short.length > 2) {
      return short.substring(0, 2).toUpperCase();
    } else {
      return short.toUpperCase();
    }
  }

  static OrderStatus getOrderStatus(
      bool confirmed, bool delivering, bool delivered, bool canceled) {
    if (!confirmed && !delivering && !delivered && !canceled) {
      return OrderStatus.pendding;
    } else if (confirmed && !delivering && !delivered && !canceled) {
      return OrderStatus.confirmed;
    } else if (confirmed && delivering && !delivered && !canceled) {
      return OrderStatus.delivering;
    } else if (delivered && !canceled) {
      return OrderStatus.delivered;
    } else if (canceled) {
      return OrderStatus.canceled;
    } else {
      return OrderStatus.other;
    }
  }

  static int roundPriceWithDiscountIQD({required int price, int discount = 0}) {
    double priceMinusDiscount = price - (price * (discount / 100));
    int roundedPrice = (priceMinusDiscount / 250).ceil() * 250;

    return roundedPrice;
  }

  static int roundPriceIQD({required double price}) {
    int roundedPrice = (price / 250).ceil() * 250;

    return roundedPrice;
  }

  static String formatPrice(int? roundedPrice) {
    if (roundedPrice == null) return '';
    var f = intl.NumberFormat("###,###", "en_US");

    return f.format(roundedPrice);
  }

  static showSnackHome(
      {String title = '',
      String tip = '',
      required BuildContext context,
      IconData icon = FontAwesomeIcons.solidLightbulb}) {
    if (tip == '' && title == '') {
      return null;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundIconButton(
                onTap: null,
                icon: icon,
                color: Theme.of(context).colorScheme.secondary),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            tip == ''
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                    child: Text(
                      tip,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        )));
  }
}
