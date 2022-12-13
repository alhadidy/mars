import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  final String animation;
  final String body;
  final String title;
  final bool animate;
  const IntroPage(this.animation, this.body, this.title, this.animate,
      {super.key});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).backgroundColor,
                radius: MediaQuery.of(context).size.width / 2,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: widget.animate
                  ? FlareActor(widget.animation,
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "go")
                  : Padding(
                      padding: const EdgeInsets.all(75.0),
                      child: Image.asset(widget.animation),
                    ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 8, left: 8),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                  fontSize: widget.animate ? 20 : 40,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 25, left: 25),
          child: Text(
            widget.body,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                  fontSize: widget.animate ? 16 : 26,
                  fontWeight: FontWeight.w600,
                  height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
