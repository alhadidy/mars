import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminAddons extends StatefulWidget {
  const AdminAddons({Key? key}) : super(key: key);

  @override
  _AdminAddonsState createState() => _AdminAddonsState();
}

class _AdminAddonsState extends State<AdminAddons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addons'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/adminAddonsEditor',
                    arguments: {'addon': null});
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
    );
  }
}
