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
          elevation: 4,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
