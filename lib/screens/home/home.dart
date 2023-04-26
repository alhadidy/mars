import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/link.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/gifts.dart';
import 'package:mars/screens/home/home_header_sliver.dart';
import 'package:mars/screens/home/orders_page.dart';
import 'package:mars/screens/home/scan.dart';
import 'package:mars/screens/home/stores_page.dart';
import 'package:mars/screens/home/widgets/basket_button.dart';
import 'package:mars/screens/home/widgets/calendar_sliver.dart';

import 'package:mars/screens/home/widgets/drinks_sliver.dart';
import 'package:mars/screens/home/widgets/food_sliver.dart';
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
  int _navIndex = 0;
  late List<Widget> pages;

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

    pages = [
      CustomScrollView(
        slivers: [
          HomeHeaderSliver(
            onTabChanged: (index) {
              setState(() {
                _navIndex = index;
              });
            },
          ),
          const PromotionSliver(),
        ],
      ),
      const Scan(),
      const OrdersPage(),
      const Gifts(),
      const StoresPage(),
    ];

    super.initState();
  }

  handleLinks() {
    ref.listen<Link>(linkProvider, (Link? oldLink, Link newLink) async {
      if (newLink.page != null) {
        if (newLink.page == '/invite') {
          ref.read(linkProvider.notifier).resetLink();
        } else {
          await Navigator.pushNamed(context, newLink.page ?? '',
              arguments: newLink.arg);
          ref.read(linkProvider.notifier).resetLink();
        }
      } else {
        Methods.showSnackHome(
            title: newLink.title, tip: newLink.tip, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ref.watch(userProvider);
    final Role role = ref.watch(rolesProvider);
    handleLinks();

    if (user == null) {
      return Container();
    }

    DateTime time = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
      body: pages[_navIndex],
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
            unselectedIconTheme: IconThemeData(color: Colors.indigo[400]),
            useLegacyColorScheme: false,
            currentIndex: _navIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            onTap: (index) {
              setState(() {
                _navIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                activeIcon: Container(
                  decoration: BoxDecoration(
                      color: Colors.indigo[100],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: FaIcon(
                      FontAwesomeIcons.house,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                label: 'الرئيسية',
                icon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: FaIcon(
                    FontAwesomeIcons.house,
                    size: 20,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                  activeIcon: Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: FaIcon(
                        FontAwesomeIcons.qrcode,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  label: 'النقاط',
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: FaIcon(
                      FontAwesomeIcons.qrcode,
                      size: 20,
                    ),
                  )),
              BottomNavigationBarItem(
                  activeIcon: Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: FaIcon(
                        FontAwesomeIcons.glassWater,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  label: 'الطلبات',
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: FaIcon(
                      FontAwesomeIcons.glassWater,
                      size: 20,
                    ),
                  )),
              BottomNavigationBarItem(
                  activeIcon: Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: FaIcon(
                        FontAwesomeIcons.gifts,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  label: 'الهدايا',
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: FaIcon(
                      FontAwesomeIcons.gifts,
                      size: 20,
                    ),
                  )),
              BottomNavigationBarItem(
                  activeIcon: Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: FaIcon(
                        FontAwesomeIcons.locationDot,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  label: 'فروعنا',
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 20,
                    ),
                  )),
            ]),
      ),
    );
  }
}
