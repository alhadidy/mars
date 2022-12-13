import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTabTitle extends StatelessWidget {
  final String title;
  final Color titleColor;
  final IconData? icon;
  final Color? iconColor;
  final bool center;
  final bool rotate;
  const HomeTabTitle(
      {super.key,
      required this.title,
      this.icon,
      this.iconColor,
      this.center = false,
      this.rotate = false,
      required this.titleColor});

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;
    if (center) {
      padding = const EdgeInsets.only(left: 8, right: 16);
    } else {
      padding = const EdgeInsets.only(left: 8, right: 16, top: 20);
    }

    Color _iconColor = iconColor ?? Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: center ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              textAlign: TextAlign.end,
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor),
              )),
          icon != null
              ? Padding(
                  padding: center
                      ? const EdgeInsets.only(bottom: 8, left: 4)
                      : const EdgeInsets.only(bottom: 8, left: 8),
                  child: rotate
                      ? Transform.rotate(
                          angle: pi,
                          child: FaIcon(
                            icon,
                            color: _iconColor,
                            size: 18,
                          ),
                        )
                      : FaIcon(
                          icon,
                          color: _iconColor,
                          size: 18,
                        ),
                )
              : Container(),
        ],
      ),
    );
  }
}
