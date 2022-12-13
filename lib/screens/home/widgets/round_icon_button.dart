import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef OnTap = Function();

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String tooltip;
  final double iconSize;
  final OnTap? onTap;
  final Color color;
  const RoundIconButton(
      {super.key,
      this.icon = FontAwesomeIcons.question,
      this.iconColor = Colors.white,
      this.iconSize = 14,
      this.tooltip = '',
      required this.onTap,
      this.color = Colors.cyan});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 20,
      child: IconButton(
        disabledColor: color,
        onPressed: onTap,
        tooltip: tooltip,
        icon: FaIcon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
