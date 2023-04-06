import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/size.dart';

class Item {
  final String fid;
  final String name;
  final String category;
  final List<Size> sizes;
  final String imgUrl;
  final String desc;
  final bool bestSeller;
  final String bestSellerCategory;

  Item(this.fid, this.name, this.category, this.sizes, this.imgUrl, this.desc,
      this.bestSeller, this.bestSellerCategory);

  factory Item.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    List sizesList = data['sizes'] ?? [];
    return Item(
      doc.id,
      data['name'] ?? '',
      data['category'] ?? '',
      sizesList.map((size) {
        return Size(size['name'], size['price'], size['discount']);
      }).toList(),
      data['imgUrl'] ?? '',
      data['desc'] ?? '',
      data['bestSeller'] ?? false,
      data['bestSellerCategory'] ?? '',
    );
  }
}
