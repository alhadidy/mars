import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/addon.dart';

class Addons {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future addSize(
      {required String name,
      required double amount,
      required String unit,
      required int price,
      int discount = 0}) {
    return firestore.collection('sizes').add({
      'name': name,
      'amount': amount,
      'unit': unit,
      'price': price,
      'discount': discount,
      'icon': '',
    });
  }

  Stream<List<Addon>> watchSizes() {
    Stream<QuerySnapshot> snapshot = firestore.collection('sizes').snapshots();

    return snapshot.map(
        (event) => event.docs.map((doc) => Addon.fromDoc(doc)).toList());
  }

  Future<List<Addon>> getSizes() async {
    QuerySnapshot snapshot = await firestore.collection('sizes').get();

    return snapshot.docs.map((doc) => Addon.fromDoc(doc)).toList();
  }

  deleteSize(String fid) {
    return firestore.collection('sizes').doc(fid).delete();
  }
}
