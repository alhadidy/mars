import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/screens/home/widgets/home_title.dart';
import 'package:mars/screens/home/widgets/promo_list.dart';
import 'package:mars/services/firestore/promos.dart';
import 'package:mars/services/locator.dart';

class PromotionSliver extends StatefulWidget {
  const PromotionSliver({Key? key}) : super(key: key);

  @override
  _PromotionSliverState createState() => _PromotionSliverState();
}

class _PromotionSliverState extends State<PromotionSliver> {
  List<Promo>? promo;
  ValueNotifier valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Promo>>(
        stream: locator.get<Promos>().getActivePromos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError ||
              !snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Container(
                height: 275,
              ),
            );
          }

          promo = snapshot.data;

          if (promo == null) {
            return const SliverToBoxAdapter(
              child: SizedBox(),
            );
          }

          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  PromotionList(
                    promos: promo!,
                    onChanged: (index, reson) {
                      valueNotifier.value = index;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder(
                        valueListenable: valueNotifier,
                        builder: (BuildContext context, value, child) {
                          return DotsIndicator(
                            reversed: true,
                            dotsCount: promo!.length,
                            position: value.toDouble(),
                            decorator: DotsDecorator(
                                size: const Size.square(5),
                                activeSize: const Size.square(10),
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.6)),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
