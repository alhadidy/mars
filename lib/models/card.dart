import 'package:cloud_firestore/cloud_firestore.dart';

class Card {
  final String id;
  final String name;
  final int amount;
  final bool redeemed;
  final String addedBy;
  final Timestamp time;

  Card(
      {required this.id,
      required this.name,
      required this.amount,
      required this.redeemed,
      required this.addedBy,
      required this.time});

  factory Card.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Card(
        id: data['id'],
        name: data['name'] ?? '',
        amount: data['amount'] ?? '',
        addedBy: data['addedBy'] ?? '',
        redeemed: data['redeemed'] ?? true,
        time: data['time']);
  }
}
