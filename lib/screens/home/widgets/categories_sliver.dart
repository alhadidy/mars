import 'package:flutter/material.dart';
import 'package:mars/screens/home/widgets/categories_list.dart';

class CategoriesSliver extends StatefulWidget {
  const CategoriesSliver({Key? key}) : super(key: key);

  @override
  State<CategoriesSliver> createState() => _CategoriesSliverState();
}

class _CategoriesSliverState extends State<CategoriesSliver> {
  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Directionality(
          textDirection: TextDirection.rtl, child: CategoriesList()),
    );
  }
}
