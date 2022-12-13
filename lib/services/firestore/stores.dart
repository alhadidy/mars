import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/store.dart';

class Stores {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Store>> getStores() async {
    QuerySnapshot stores = await firestore.collection('stores').get();

    return stores.docs.map((e) => Store.fromDoc(e)).toList();
  }

  Stream<List<Store>> watchStores() {
    Stream<QuerySnapshot> stores = firestore.collection('stores').snapshots();

    return stores.map((event) {
      return event.docs.map((e) => Store.fromDoc(e)).toList();
    });
  }
}
