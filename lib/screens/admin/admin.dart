import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/firestore/orders.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/providers.dart';

class Admin extends ConsumerStatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  ConsumerState<Admin> createState() => _AdminState();
}

class _AdminState extends ConsumerState<Admin> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dash'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dash'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Stores'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.store,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminStores');
              },
            ),
            ListTile(
              title: const Text('Categories'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.champagneGlasses,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminCategories');
              },
            ),
            ListTile(
              title: const Text('Items'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.mugHot,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminItems');
              },
            ),
            ListTile(
              title: const Text('Addons'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.puzzlePiece,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminAddons');
              },
            ),
            ListTile(
              title: const Text('Sizes'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.weightScale,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminSizes');
              },
            ),
            user.role == Roles.admin
                ? ListTile(
                    title: const Text('Editors'),
                    trailing: SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                            child: FaIcon(
                          FontAwesomeIcons.users,
                          color: Theme.of(context).colorScheme.secondary,
                        ))),
                    onTap: () {
                      Navigator.pushNamed(context, '/adminEditors');
                    },
                  )
                : Container(),
            ListTile(
              title: const Text('Promotions'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.fireFlameCurved,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminPromotion');
              },
            ),
            ListTile(
              title: const Text('Orders'),
              trailing: FutureBuilder<AggregateQuerySnapshot>(
                  future: locator.get<Orders>().countPendingOrders(),
                  builder: (context, snapshot) {
                    return Badge(
                      isLabelVisible: snapshot.hasData,
                      label: Text(snapshot.data?.count.toString() ?? ''),
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                              child: FaIcon(
                            FontAwesomeIcons.bagShopping,
                            color: Theme.of(context).colorScheme.secondary,
                          ))),
                    );
                  }),
              onTap: () {
                Navigator.pushNamed(context, '/adminOrders');
              },
            ),
            // ListTile(
            //   title: const Text('Support'),
            //   trailing: SizedBox(
            //       height: 30,
            //       width: 30,
            //       child: Center(
            //           child: FaIcon(
            //         FontAwesomeIcons.headset,
            //         color: Theme.of(context).colorScheme.secondary,
            //       ))),
            //   onTap: () {
            //     Navigator.pushNamed(context, '/adminSupport');
            //   },
            // ),
            // ListTile(
            //   title: const Text('Notifications'),
            //   trailing: SizedBox(
            //       height: 30,
            //       width: 30,
            //       child: Center(
            //           child: FaIcon(
            //         FontAwesomeIcons.solidPaperPlane,
            //         color: Theme.of(context).colorScheme.secondary,
            //       ))),
            //   onTap: () {},
            // ),
            ListTile(
              title: const Text('Loyalty Program'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.coins,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminPoints');
              },
            ),
            ListTile(
              title: const Text('Payments'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.moneyBillTransfer,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminPayments');
              },
            ),
            user.role == Roles.admin
                ? ListTile(
                    title: const Text('Settings'),
                    trailing: SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                            child: FaIcon(
                          FontAwesomeIcons.gear,
                          color: Theme.of(context).colorScheme.secondary,
                        ))),
                    onTap: () {
                      Navigator.pushNamed(context, '/adminSettings');
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
