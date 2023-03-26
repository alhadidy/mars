import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/link.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/basket_button.dart';
import 'package:mars/screens/home/widgets/calendar_sliver.dart';
import 'package:mars/screens/home/widgets/categories_sliver.dart';
import 'package:mars/screens/home/widgets/items_sliver.dart';
import 'package:mars/screens/home/widgets/promo_sliver.dart';
import 'package:mars/screens/home/widgets/shops_orders_sliver.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/notifications.dart';
import 'package:mars/services/providers.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  inspect(message);

  NotificationsApi.showNotification(
      title: message.data['title'],
      body: message.data['body'],
      payload: jsonEncode(message.data));
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  //TODO pages notifications
  void _handleNotificationClicked(String payload) async {
    final notificationData = jsonDecode(payload);
    switch (notificationData['page']) {
      case 'item':
        break;
    }
  }

  @override
  void initState() {
    Methods.initFCM(context);
    NotificationsApi.init(initScheduled: true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationsApi.onNotificationsClick.stream.listen((payload) {
      _handleNotificationClicked(payload);
    });

    super.initState();
  }

  handleLinks() {
    Link link = ref.watch(linkProvider);

    if (link.page != null) {
      if (link.page == '/invite') {
        ref.read(linkProvider.notifier).resetLink();
      } else {
        Navigator.pushNamed(context, link.page ?? '', arguments: link.arg);
        ref.read(linkProvider.notifier).resetLink();
      }
    } else {
      Methods.showSnackHome(title: link.title, tip: link.tip, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ref.watch(userProvider);
    final Role role = ref.watch(rolesProvider);

    if (user == null) {
      return Container();
    }

    DateTime time = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time.hour > 11 ? 'Good Evening' : 'Good Morning',
              style: const TextStyle(fontSize: 14),
            ),
            FittedBox(
              child: Text(
                user.name.isEmpty ? 'Guest' : user.name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        leading: GestureDetector(
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
              errorWidget: ((context, url, error) {
                return ClipOval(
                    child: Container(
                  color: Colors.amberAccent,
                ));
              }),
            )),
          ),
        ),
        actions: [
          const BasketButton(),
          role.role != Roles.user
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin');
                  },
                  icon: const FaIcon(FontAwesomeIcons.gear))
              : Container()
        ],
      ),
      body: const CustomScrollView(
        slivers: [
          PromotionSliver(),
          CategoriesSliver(),
          CalendarSliver(),
          ShopsOrdersSliver(),
          ItemsSliver(),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          )
        ],
      ),
    );
  }
}
