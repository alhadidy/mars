

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/services/providers.dart';

class QuantityButtons extends ConsumerWidget {
  final LocalOrder oldOrder;
  const QuantityButtons(this.oldOrder, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
                onPressed: () async {
                  AppDatabase db = ref.read(dbProvider);
                  await db.localOrdersDao.increaseQuantity(oldOrder);
                },
                color: Colors.white,
                icon: const FaIcon(FontAwesomeIcons.plus)),
          ),
          Text(
            oldOrder.quantity.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          CircleAvatar(
            radius: 23,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
                onPressed: () async {
                  AppDatabase db = ref.read(dbProvider);
                  await db.localOrdersDao.decreaseQuantity(oldOrder);
                },
                color: Colors.white,
                icon: const FaIcon(FontAwesomeIcons.minus)),
          ),
        ],
      ),
    );
  }
}
