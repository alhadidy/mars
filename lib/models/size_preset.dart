import 'package:cloud_firestore/cloud_firestore.dart';

class SizePreset {
  final String fid;
  final String name;
  final double amount;
  final String unit;
  final int price;
  final int discount;

  SizePreset(
      this.fid, this.name, this.amount, this.unit, this.price, this.discount);

  factory SizePreset.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return SizePreset(
      doc.id,
      data['name'],
      data['amount'],
      data['unit'],
      data['price'] ?? 0,
      data['discount'] ?? 0,
    );
  }
}

enum SizeUnit { ml, oz, gram }
