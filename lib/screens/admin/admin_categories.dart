import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/category.dart';
import 'package:mars/screens/home/widgets/shop_topic_button.dart';
import 'package:mars/services/firestore/categories.dart';
import 'package:mars/services/locator.dart';

class AdminCategories extends StatefulWidget {
  const AdminCategories({Key? key}) : super(key: key);

  @override
  State<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categoryEditor',
                    arguments: {'category': null});
              },
              icon: FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Categories>().getCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container();
          }

          List<Category> categories = snapshot.data;

          return GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: ((context, index) {
                return ShopTopicButton(
                    icon: FontAwesomeIcons.mugHot,
                    title: categories[index].name,
                    route: '/categoryEditor',
                    arg: {'category': categories[index]},
                    img: categories[index].imgUrl);
              }));
        },
      ),
    );
  }
}
