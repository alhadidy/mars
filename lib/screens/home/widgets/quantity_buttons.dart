import 'package:drift/drift.dart';
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () async {
              AppDatabase db = ref.read(dbProvider);
              db.localOrdersDao
                  .insertInTheOrder(oldOrder.copyWith(id: const Value(null)));
            },
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Theme.of(context).colorScheme.primary,
                  size: 12,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () async {
              AppDatabase db = ref.read(dbProvider);
              await db.localOrdersDao.deleteFromTheOrder(oldOrder);
            },
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  color: Colors.red,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
