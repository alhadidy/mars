import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  const ItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (() {
          Navigator.pushNamed(context, '/itemPage', arguments: {'item': item});
        }),
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.brown[300],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: CachedNetworkImage(
                      width: double.maxFinite,
                      height: 160,
                      fit: BoxFit.cover,
                      imageUrl: item.imgUrl),
                ),
              ),
              SizedBox(
                height: 30,
                width: double.maxFinite,
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Text(
                      item.name,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  height: 60,
                  child: Text(
                    item.desc,
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
