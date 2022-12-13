import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/services/providers.dart';

class BasketButton extends ConsumerWidget {
  const BasketButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppDatabase db = ref.watch(dbProvider);

    return StreamBuilder(
      stream: db.localOrdersDao.getOrderSize(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        int count;
        if (!snapshot.hasData || snapshot.data == null) {
          count = 0;
        } else {
          count = snapshot.data;
        }
        return Badge(
          ignorePointer: true,
          badgeContent: Text(
            count.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          showBadge: count != 0 ? true : false,
          badgeColor: Theme.of(context).colorScheme.secondary,
          position: BadgePosition.topStart(top: 0, start: 0),
          animationType: BadgeAnimationType.scale,
          animationDuration: const Duration(milliseconds: 250),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/basket');
            },
            icon: const FaIcon(FontAwesomeIcons.bagShopping),
            color: Colors.white,
          ),
        );
      },
    );
  }
}
