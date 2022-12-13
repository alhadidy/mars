import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String fid;
  final String name;
  final String address;
  final String imgUrl;
  final GeoPoint location;

  Store(
      {required this.fid,
      required this.name,
      required this.address,
      required this.imgUrl,
      required this.location});

  factory Store.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Store(
        fid: doc.id,
        name: data['name'] ?? '',
        address: data['address'] ?? '',
        imgUrl: data['imgUrl'] ?? '',
        location: data['location']);
  }
}
