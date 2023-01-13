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
            return SliverAppBar(
                expandedHeight: 400,
                collapsedHeight: 65,
                backgroundColor: Theme.of(context).primaryColorDark,
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  title: HomeTabTitle(
                    title: 'عروض مارس',
                    titleColor: Colors.white,
                    icon: FontAwesomeIcons.fireFlameCurved,
                    center: true,
                  ),
                ));
          }

          promo = snapshot.data;

          if (promo == null) {
            return const SliverToBoxAdapter(
              child: SizedBox(),
            );
          }

          return SliverAppBar(
              backgroundColor: Theme.of(context).primaryColorDark,
              expandedHeight: 400,
              collapsedHeight: 65,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (BuildContext context, value, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          promo != null && promo!.length > 1
                              ? Flexible(
                                  child: DotsIndicator(
                                  reversed: true,
                                  dotsCount: promo!.length,
                                  position: value.toDouble(),
                                  decorator: DotsDecorator(
                                      size: const Size.square(5),
                                      activeSize: const Size.square(7),
                                      activeColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      color: Colors.white),
                                ))
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          const HomeTabTitle(
                            title: 'عروض مارس',
                            titleColor: Colors.white,
                            icon: FontAwesomeIcons.fireFlameCurved,
                            center: true,
                          ),
                        ],
                      );
                    }),
                titlePadding: const EdgeInsets.only(bottom: 8),
                collapseMode: CollapseMode.parallax,
                background: Builder(builder: (context) {
                  return PromotionList(
                    promos: promo!,
                    onChanged: (index, reson) {
                      valueNotifier.value = index;
                    },
                  );
                }),
              ));
        });
  }
}
