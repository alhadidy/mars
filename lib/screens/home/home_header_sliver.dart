import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/user_data.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/screens/home/widgets/stars_stepper.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

typedef OnTabChanged = void Function(int index);

class HomeHeaderSliver extends ConsumerStatefulWidget {
  final OnTabChanged onTabChanged;
  const HomeHeaderSliver({Key? key, required this.onTabChanged})
      : super(
          key: key,
        );

  @override
  _HomeHeaderSliverState createState() => _HomeHeaderSliverState();
}

class _HomeHeaderSliverState extends ConsumerState<HomeHeaderSliver> {
  @override
  Widget build(BuildContext context) {
    UserData userData = ref.watch(userDataProvider);
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: RoundIconButton(
                      onTap: () {},
                      icon: FontAwesomeIcons.solidStar,
                      iconSize: 18,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                Text(
                  Methods.formatPrice(userData.points),
                  style: const TextStyle(fontSize: 35, color: Colors.black),
                ),
              ],
            ),
          ),
          Text(
            'رصيدك الحالي',
            style: GoogleFonts.tajawal(fontSize: 12, height: 2),
          ),
          Container(
            color: Colors.grey[50],
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StarsStepper(
                        steps: [200, 400, 600, 800, 1000],
                        userPoints: userData.points)),
              ),
            ),
          ),
          Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: 50,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  title: const Text('ادفع عن طريق المحفظة'),
                  subtitle: const Text('اكسب نقاط اضافية لكل عملية دفع'),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const FaIcon(
                        FontAwesomeIcons.moneyBill,
                        color: Colors.white,
                      )),
                  trailing: const FaIcon(FontAwesomeIcons.chevronLeft),
                  onTap: () {
                    widget.onTabChanged(1);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
