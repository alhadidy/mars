import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  final String img;
  final String body;
  final String title;

  const IntroPage(this.img, this.body, this.title, {super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color(0xff1F3469),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      child: Image.asset(
                    widget.img,
                    width: MediaQuery.of(context).size.width,
                  )),
                ),
              ),
              Positioned(
                right: 100,
                top: 120,
                child: Image.asset(
                  'assets/imgs/star.png',
                  width: 24,
                ),
              ),
              Positioned(
                left: 50,
                top: 20,
                child: Image.asset(
                  'assets/imgs/star.png',
                  width: 34,
                ),
              ),
              Positioned(
                left: 50,
                top: 250,
                child: Image.asset(
                  'assets/imgs/star.png',
                  width: 44,
                ),
              ),
            ],
          ),
          const Divider(
            height: 2,
            color: Colors.transparent,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20, right: 8, left: 8, top: 20),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, right: 25, left: 25),
                    child: Text(
                      widget.body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
