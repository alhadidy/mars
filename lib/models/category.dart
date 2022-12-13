import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String fid;
  final String name;
  final String imgUrl;
  final int order;

  Category(this.fid, this.name, this.imgUrl, this.order);

  factory Category.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Category(
        doc.id, data['name'] ?? '', data['imgUrl'] ?? '', data['order'] ?? 0);
  }
}
