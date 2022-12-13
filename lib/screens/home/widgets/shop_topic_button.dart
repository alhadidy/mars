import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShopTopicButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final String img;
  final Map<String, dynamic> arg;
  const ShopTopicButton(
      {super.key,
      required this.icon,
      required this.title,
      required this.route,
      required this.arg,
      required this.img});
  final double storyAvatarRadius = 40.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route, arguments: arg);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 0, left: 4, right: 4),
        child: SizedBox(
          width: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  img == ''
                      ? Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              height: storyAvatarRadius * 2,
                              width: storyAvatarRadius * 2,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(29)),
                                color: Colors.brown[600],
                              ),
                            ),
                            FaIcon(
                              icon,
                              size: 30,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.white,
                            )
                          ],
                        )
                      : ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            color: Colors.white,
                            child: CachedNetworkImage(
                              height: storyAvatarRadius * 2 + 2,
                              width: storyAvatarRadius * 2 + 2,
                              imageUrl: img,
                              fit: BoxFit.cover,
                              errorWidget: (e, s, d) {
                                return Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      height: storyAvatarRadius * 2,
                                      width: storyAvatarRadius * 2,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(29)),
                                        color: Colors.brown[600],
                                      ),
                                    ),
                                    FaIcon(
                                      icon,
                                      size: 30,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.white,
                                    )
                                  ],
                                );
                              },
                              placeholder: (context, s) {
                                return Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      height: storyAvatarRadius * 2,
                                      width: storyAvatarRadius * 2,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(29)),
                                        color: Colors.brown[600],
                                      ),
                                    ),
                                    FaIcon(
                                      icon,
                                      size: 30,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.white,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                ],
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(title,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
