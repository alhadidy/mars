import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/item.dart';
import 'package:mars/screens/home/widgets/item_tile.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/locator.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.bagShopping))
        ],
      ),
      body: FutureBuilder(
        future: locator.get<Items>().getItemsByCategory(widget.category),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container();
          }

          List<Item> items = snapshot.data;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 300),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemTile(item: items[index]);
            },
          );
        },
      ),
    );
  }
}
