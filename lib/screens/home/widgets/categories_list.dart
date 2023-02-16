import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/category.dart';
import 'package:mars/screens/home/widgets/shop_topic_button.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/locator.dart';

import 'home_title.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: locator.get<Categories>().getCategories(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (snapshot.data == null) {
          return Container();
        }

        List<Category> categories = snapshot.data;

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: HomeTabTitle(
                  title: 'الأقسام',
                  titleColor: Theme.of(context).textTheme.titleLarge!.color!,
                  icon: FontAwesomeIcons.barsStaggered,
                ),
              ),
              SizedBox(
                height: 140,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, mainAxisExtent: 100),
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return ShopTopicButton(
                      title: categories[index].name,
                      img: categories[index].imgUrl,
                      icon: FontAwesomeIcons.mugHot,
                      route: '/categoryPage',
                      arg: {'category': categories[index].name},
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
