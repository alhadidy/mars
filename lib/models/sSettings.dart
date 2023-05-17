import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/card_presets.dart';

class SSetting {
  int deliveryPrice;
  int rewardAmount;
  bool dev;
  List<CardPresets> cards;
  SSetting(
      {required this.dev,
      required this.cards,
      required this.deliveryPrice,
      required this.rewardAmount});

  factory SSetting.fromDoc(DocumentSnapshot doc, FirebaseFirestore firestore) {
    Map data = doc.data() as Map;
    List cards = data['cards'] ?? [];
    return SSetting(
      cards: cards
          .map((e) => CardPresets(amount: e['amount'], name: e['name']))
          .toList(),
      deliveryPrice: data['deliveryPrice'] ?? 0,
      rewardAmount: data['rewardAmount'] ?? 0,
      dev: data['dev'] ?? false,
    );
  }
}
