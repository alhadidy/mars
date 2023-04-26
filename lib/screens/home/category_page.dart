import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/item.dart';
import 'package:mars/screens/home/widgets/basket_button.dart';
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
        title: Text(
          widget.category,
          style: GoogleFonts.tajawal(),
        ),
        centerTitle: true,
        actions: const [BasketButton()],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder(
          future: locator.get<Items>().getItemsByCategory(widget.category),
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Item>? items = snapshot.data;
            if (items == null || items.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد نتائج حاليا',
                  style: GoogleFonts.tajawal(),
                ),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 225),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(item: items[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
