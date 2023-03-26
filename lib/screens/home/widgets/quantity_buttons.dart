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
          InkWell(
            onTap: () async {
              AppDatabase db = ref.read(dbProvider);
              await db.localOrdersDao.increaseQuantity(oldOrder);
            },
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
            oldOrder.quantity.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          InkWell(
            onTap: () async {
              AppDatabase db = ref.read(dbProvider);
              await db.localOrdersDao.decreaseQuantity(oldOrder);
            },
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.minus,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
