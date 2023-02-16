import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mars/models/item.dart';

class ItemTileHorizontal extends StatelessWidget {
  final Item item;
  const ItemTileHorizontal({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/itemPage', arguments: {'item': item});
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.grey[200],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 16,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover, imageUrl: item.imgUrl),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Text(
                            item.name,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: Text(
                            item.desc,
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
