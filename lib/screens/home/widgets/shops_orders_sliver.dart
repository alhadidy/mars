import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopsOrdersSliver extends StatefulWidget {
  const ShopsOrdersSliver({Key? key}) : super(key: key);

  @override
  State<ShopsOrdersSliver> createState() => _ShopsOrdersSliverState();
}

class _ShopsOrdersSliverState extends State<ShopsOrdersSliver> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 2,
            child: GestureDetector(
              onTap: (() {
                Navigator.pushNamed(context, '/stores');
              }),
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0))),
                color: Colors.blue[900],
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
                          backgroundColor: Colors.blue.shade800,
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
                          backgroundColor: Colors.blue.shade700,
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
                          backgroundColor: Colors.blue.shade600,
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
                          backgroundColor: Colors.blue.shade500,
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
                            child: FaIcon(FontAwesomeIcons.store,
                                color: Colors.white, size: 60),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'فروع مارس',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                  color: Colors.white,
                                  fontSize: 30,
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
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 2,
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
                                color: Colors.white, size: 60),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'طلباتي',
                              style: GoogleFonts.tajawal(
                                  color: Colors.white,
                                  fontSize: 30,
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
        ],
      ),
    );
  }
}
