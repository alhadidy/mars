import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/item.dart';
import 'package:mars/screens/home/widgets/home_title.dart';
import 'package:mars/screens/home/widgets/item_tile_horizontal.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/locator.dart';

class DrinksSliver extends StatelessWidget {
  const DrinksSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: StreamBuilder(
        stream: locator.get<Items>().getBestSellerItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          List<Item> items = snapshot.data;
          return SizedBox(
            height: 302,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const HomeTabTitle(
                  title: 'المرطبات الأكثر شعبية',
                  titleColor: Colors.black,
                  icon: FontAwesomeIcons.martiniGlassCitrus,
                ),
                SizedBox(
                  height: 225,
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'قريباً',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemTileHorizontal(item: items[index]);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
