import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
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
            ListTile(
              title: const Text('Notifications'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.solidPaperPlane,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Points'),
              trailing: SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.coins,
                    color: Theme.of(context).colorScheme.secondary,
                  ))),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
