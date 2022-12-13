import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/screens/home/widgets/round_tag.dart';

class PromotionTile extends StatefulWidget {
  final Promo promo;
  final int index;

  const PromotionTile({super.key, required this.promo, required this.index});

  @override
  PromotionTileState createState() => PromotionTileState();
}

class PromotionTileState extends State<PromotionTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/promotionPage',
            arguments: {'promo': widget.promo});
      },
      child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.promo.imgUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ));
                  },
                ),
                Positioned(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: const [
                                0,
                                0.3,
                                1
                              ],
                                  colors: [
                                Colors.black.withAlpha(150),
                                Colors.black.withAlpha(100),
                                Colors.black.withAlpha(0),
                              ])),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ],
                    )),
                Positioned(
                    top: 16,
                    right: 16,
                    child: RoundTag(
                      text: widget.promo.name,
                      secondaryText: '${widget.index + 1} :',
                      icon: FontAwesomeIcons.slack,
                    )),
              ],
            ),
          )),
    );
  }
}
