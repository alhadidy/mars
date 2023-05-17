import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/item.dart';

class ItemTileHorizontal extends StatelessWidget {
  final Item item;
  const ItemTileHorizontal({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/itemPage', arguments: {'item': item});
      },
      child: SizedBox(
        width: 166,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: item.fid,
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: ClipOval(
                      child: CachedNetworkImage(
                          fit: BoxFit.cover, imageUrl: item.imgUrl),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 166,
                    child: Text(
                      item.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 166,
                    child: Text(
                      item.category,
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: GoogleFonts.tajawal().fontFamily,
                          height: 2,
                          fontSize: 14,
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
