import 'package:flutter/material.dart';
import 'package:mars/models/promo.dart';
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
            return const SliverToBoxAdapter(
              child: SizedBox(
                  height: 275,
                  child: Center(
                    child: SizedBox(
                      height: 36,
                      width: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )),
            );
          }

          promo = snapshot.data;

          if (promo == null) {
            return const SliverToBoxAdapter(
              child: SizedBox(),
            );
          }

          return PromotionList(
            promos: promo!,
           
          );
        });
  }
}
