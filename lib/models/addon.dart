import 'package:cloud_firestore/cloud_firestore.dart';

class Addon {
  final String fid;
  final String name;
  final int price;
  final String type;
  final String value;

  Addon(this.fid, this.name, this.price, this.type, this.value);

  factory Addon.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Addon(
      doc.id,
      data['name'],
      data['price'] ?? 0,
      data['type'] ?? '',
      data['value'] ?? '',
    );
  }
}

enum AddonTypes { options, amount }
