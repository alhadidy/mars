import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrdersSliver extends StatefulWidget {
  const MyOrdersSliver({Key? key}) : super(key: key);

  @override
  State<MyOrdersSliver> createState() => _MyOrdersSliverState();
}

class _MyOrdersSliverState extends State<MyOrdersSliver> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: GestureDetector(
          onTap: (() {
            Navigator.pushNamed(context, '/myOrders');
          }),
          child: Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            color: Colors.amber[900],
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  left: -400,
                  top: -400,
                  child: Opacity(
                    opacity: 1,
                    child: CircleAvatar(
                      radius: 400,
                      backgroundColor: Colors.amber.shade800,
                    ),
                  ),
                ),
                Positioned(
                  left: -300,
                  top: -300,
                  child: Opacity(
                    opacity: 1,
                    child: CircleAvatar(
                      radius: 300,
                      backgroundColor: Colors.amber.shade700,
                    ),
                  ),
                ),
                Positioned(
                  left: -200,
                  top: -200,
                  child: Opacity(
                    opacity: 1,
                    child: CircleAvatar(
                      radius: 200,
                      backgroundColor: Colors.amber.shade600,
                    ),
                  ),
                ),
                Positioned(
                  left: -100,
                  top: -100,
                  child: Opacity(
                    opacity: 1,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.amber.shade500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FaIcon(FontAwesomeIcons.boxesStacked,
                            color: Colors.white, size: 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'طلباتي',
                          style: GoogleFonts.tajawal(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}