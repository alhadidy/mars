import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/category.dart';
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
              icon: const FaIcon(FontAwesomeIcons.plus))
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
                  crossAxisCount: 3, mainAxisExtent: 160),
              itemBuilder: ((context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/categoryEditor',
                        arguments: {'category': categories[index]});
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                            child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                          imageUrl: categories[index].imgUrl,
                          errorWidget: (context, url, error) {
                            return Container(
                              color: Theme.of(context).colorScheme.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/imgs/logo_dark.png',
                                ),
                              ),
                            );
                          },
                        )),
                      ),
                      Text(
                        categories[index].name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(),
                      )
                    ],
                  ),
                );
              }));
        },
      ),
    );
  }
}
