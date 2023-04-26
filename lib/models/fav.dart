import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/cup_size.dart';

class Fav {
  final String fid;
  final String name;
  final String category;
  final String imgUrl;

  Fav(this.fid, this.name, this.category, this.imgUrl);

  factory Fav.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Fav(
      doc.id,
      data['name'] ?? '',
      data['category'] ?? '',
      data['imgUrl'] ?? '',
    );
  }
}
