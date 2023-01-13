import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:mars/services/methods.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationsApi {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();
  static final onNotificationsClick = BehaviorSubject<String>();

  static clear(int id) {
    _notification.cancel(id);
  }

  static clearAll() {
    _notification.cancelAll();
  }

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/logo');
    const ios = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    final details = await _notification.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotificationsClick.add(details.payload ?? '');
    }
    await _notification.initialize(settings,
        onSelectNotification: (payload) async {
      onNotificationsClick.add(payload ?? '');
    });
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('raje3_channel', 'raje3',
          importance: Importance.max),
      iOS: IOSNotificationDetails(),
    );
  }

  static showNotification(
      {int? id, String? title, String? body, String? payload}) async {
    int randomId;
    if (id == null) {
      randomId = int.tryParse(Methods.getRandomNumber(length: 5)) ?? 0;
    } else {
      randomId = id;
    }
    NotificationDetails notificationDetails = await _notificationDetails();
    return _notification.show(randomId, title, body, notificationDetails,
        payload: payload);
  }

  static showScheduledNotification(
      {int? id,
      String? title,
      String? body,
      String? payload,
      required DateTime time}) async {
    int randomId;
    if (id == null) {
      randomId = int.tryParse(Methods.getRandomNumber(length: 5)) ?? 0;
    } else {
      randomId = id;
    }
    NotificationDetails notificationDetails = await _notificationDetails();
    return _notification.zonedSchedule(randomId, title, body,
        tz.TZDateTime.from(time, tz.local), notificationDetails,
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
