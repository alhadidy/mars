import 'package:flutter/material.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/screens/home/widgets/promo_tile.dart';

class PromotionList extends StatelessWidget {
  final List<Promo> promos;

  const PromotionList({super.key, required this.promos});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: PromotionTile(promo: promos[index], index: index),
          ),
        );
      }, childCount: promos.length),
    );
  }
}
