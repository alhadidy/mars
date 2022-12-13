import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/screens/home/widgets/promo_tile.dart';

typedef OnChangeCallback = void Function(
    int index, CarouselPageChangedReason reason);

class PromotionList extends StatelessWidget {
  final List<Promo> promos;
  final OnChangeCallback onChanged;

  const PromotionList(
      {super.key, required this.promos, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: promos.length,
      options: CarouselOptions(
          height: 400,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          reverse: true,
          autoPlay: true,
          onPageChanged: onChanged),
      itemBuilder: (context, index, indexs) {
        return PromotionTile(promo: promos[index], index: index);
      },
    );
  }
}
