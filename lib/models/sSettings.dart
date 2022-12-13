import 'package:cloud_firestore/cloud_firestore.dart';

class SSetting {
  SSetting(
      {required this.freeDeliveryLimit,
      required this.dev,
      required this.deliveryPrice});

  int deliveryPrice;
  int freeDeliveryLimit;
  bool dev;

  factory SSetting.fromDoc(DocumentSnapshot doc, FirebaseFirestore firestore) {
    Map data = doc.data() as Map;
    return SSetting(
        deliveryPrice: data['deliveryPrice'] ?? 0,
        dev: data['dev'] ?? true,
        freeDeliveryLimit: data['freeDeliveryLimit'] ?? 0);
  }
}
