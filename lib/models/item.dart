import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/addon.dart';
import 'package:mars/models/size_preset.dart';

class Item {
  final String fid;
  final String name;
  final String category;
  final List<SizePreset> sizes;
  final List<Addon> addons;
  final String imgUrl;
  final String desc;
  final bool bestSeller;
  final String bestSellerCategory;

  Item(this.fid, this.name, this.category, this.sizes, this.addons, this.imgUrl,
      this.desc, this.bestSeller, this.bestSellerCategory);

  factory Item.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    List sizesList = data['sizes'] ?? [];
    List addonsList = data['addons'] ?? [];

    return Item(
      doc.id,
      data['name'] ?? '',
      data['category'] ?? '',
      sizesList.map((size) {
        return SizePreset(
          size['fid'] ?? '',
          size['name'],
          size['amount'] ?? 0,
          size['unit'] ?? '',
          size['price'],
          size['discount'],
        );
      }).toList(),
      addonsList.map((addon) {
        return Addon(
          addon['fid'] ?? '',
          addon['name'],
          addon['price'],
          addon['type'] ?? '',
          addon['value'] ?? '',
        );
      }).toList(),
      data['imgUrl'] ?? '',
      data['desc'] ?? '',
      data['bestSeller'] ?? false,
      data['bestSellerCategory'] ?? '',
    );
  }
}
