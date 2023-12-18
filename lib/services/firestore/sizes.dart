import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/size_preset.dart';

class Sizes {
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

  Stream<List<SizePreset>> watchSizes() {
    Stream<QuerySnapshot> snapshot = firestore.collection('sizes').snapshots();

    return snapshot.map(
        (event) => event.docs.map((doc) => SizePreset.fromDoc(doc)).toList());
  }

  Future<List<SizePreset>> getSizes() async {
    QuerySnapshot snapshot = await firestore.collection('sizes').get();

    return snapshot.docs.map((doc) => SizePreset.fromDoc(doc)).toList();
  }

  deleteSize(String fid) {
    return firestore.collection('sizes').doc(fid).delete();
  }
}
