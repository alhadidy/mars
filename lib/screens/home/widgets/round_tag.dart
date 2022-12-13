import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundTag extends StatelessWidget {
  final String text;
  final String secondaryText;
  final IconData? icon;
  final bool tapable;
  final double? height;
  final Color? color;
  final Color? textColor;
  final String route;
  final Map? routeMap;
  const RoundTag(
      {Key? key,
      required this.text,
      this.icon,
      this.secondaryText = '',
      this.tapable = false,
      this.color,
      this.route = '/topicsGroup',
      this.routeMap,
      this.textColor,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map? _routeMap;
    routeMap == null
        ? _routeMap = {'tagName': text, 'icon': icon}
        : _routeMap = routeMap;

    Color? _color;
    Color? _textColor;
    color == null ? _color = Theme.of(context).cardColor : _color = color;
    textColor == null
        ? _textColor = Theme.of(context).textTheme.headline1!.color
        : _textColor = textColor;
    return GestureDetector(
      onTap: () async {
        if (tapable) {
          Navigator.of(context).pushNamed(route, arguments: _routeMap);
        }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0, left: 6.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: _textColor),
                ),
              ),
              secondaryText.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Text(
                        secondaryText,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: _textColor),
                      ),
                    )
                  : Container(),
              icon != null
                  ? FaIcon(
                      icon,
                      size: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
