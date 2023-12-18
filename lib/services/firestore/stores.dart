import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/store.dart';

class Stores {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Store>> getStores() async {
    QuerySnapshot stores = await firestore.collection('stores').get();

    return stores.docs.map((e) => Store.fromDoc(e)).toList();
  }

  Future deleteStore(String id) async {
    return firestore.collection('stores').doc(id).delete();
  }

  Stream<List<Store>> watchStores() {
    Stream<QuerySnapshot> stores = firestore.collection('stores').snapshots();

    return stores.map((event) {
      return event.docs.map((e) => Store.fromDoc(e)).toList();
    });
  }

  Future addStore(
      {required String name,
      required String address,
      required String phone,
      required GeoPoint location,
      required String imgUrl}) {
    return firestore.collection('stores').add({
      'name': name,
      'address': address,
      'phone': phone,
      'location': location,
      'imgUrl': imgUrl
    });
  }

  Future updateStore(
      {required String fid,
      required String name,
      required String address,
      required String phone,
      required GeoPoint location,
      required String imgUrl}) {
    return firestore.collection('stores').doc(fid).set({
      'name': name,
      'address': address,
      'phone': phone,
      'location': location,
      'imgUrl': imgUrl
    });
  }
}
