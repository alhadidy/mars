import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/screens/home/favs_page.dart';
import 'package:mars/screens/home/my_orders.dart';
import 'package:mars/screens/home/widgets/categories_list.dart';
import 'package:mars/screens/home/widgets/drinks_sliver.dart';
import 'package:mars/screens/home/widgets/food_sliver.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
          initialIndex: 1,
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              centerTitle: false,
              title: Text(
                'الطلبات',
                textAlign: TextAlign.start,
                style: GoogleFonts.tajawal(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
              backgroundColor: Colors.white,
              bottom: TabBar(
                isScrollable: true,
                labelStyle: GoogleFonts.tajawal(
                  color: Colors.black,
                ),
                tabs: const [
                  Tab(
                    text: 'الأقسام',
                  ),
                  Tab(
                    text: 'الأكثر شعبية',
                  ),
                  Tab(
                    text: 'قائمة الطلبات',
                  ),
                  Tab(text: 'المفضلة'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                CategoriesList(),
                CustomScrollView(
                  slivers: [
                    // SliverToBoxAdapter(child: Divider()),
                    DrinksSliver(),
                    SliverToBoxAdapter(child: Divider()),
                    FoodSliver(),
                  ],
                ),
                MyOrders(),
                FavsPage(),
              ],
            ),
          )),
    );
  }
}
