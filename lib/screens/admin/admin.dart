import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/user.dart';
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
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.bagShopping,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {
                Navigator.pushNamed(context, '/adminOrders');
              },
            ),
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
          ],
        ),
      ),
    );
  }
}
