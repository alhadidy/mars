import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/size.dart';
import 'package:mars/services/methods.dart';
import 'package:path/path.dart' as p;

class Items {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Item>> getItemsByCategory(String category) async {
    QuerySnapshot snapshot = await firestore
        .collection('items')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((e) => Item.fromDoc(e)).toList();
  }

  Future<Item> getItem(String id) async {
    DocumentSnapshot snapshot =
        await firestore.collection('item').doc(id).get();

    return Item.fromDoc(snapshot);
  }

  Stream<List<Item>> getItems() {
    Stream<QuerySnapshot> snapshot = firestore.collection('items').snapshots();

    return snapshot
        .map((event) => event.docs.map((e) => Item.fromDoc(e)).toList());
  }

  Stream<List<Item>> getBestSellerItems() {
    Stream<QuerySnapshot> snapshot = firestore
        .collection('items')
        .where('bestSeller', isEqualTo: true)
        .snapshots();

    return snapshot
        .map((event) => event.docs.map((e) => Item.fromDoc(e)).toList());
  }

  Future deleteItem(String id) async {
    return await firestore.collection('items').doc(id).delete();
  }

  Future addItem({
    required String name,
    required String desc,
    required String category,
    required List<Size> sizes,
    required File? image,
    bool bestSeller = false,
  }) async {
    if (image != null) {
      String fileName = Methods.getRandomString(10);
      String ext = p.extension(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;

      return storage
          .ref('items/$fileName.$ext')
          .putFile(image)
          .then((p0) async {
        String url = await storage.ref('items/$fileName.$ext').getDownloadURL();
        return firestore.collection('items').add({
          'name': name,
          'desc': desc,
          'category': category,
          'sizes': sizes
              .map((size) => {
                    'name': size.name,
                    'price': size.price,
                    'discount': size.discount
                  })
              .toList(),
          'imgUrl': url,
          'bestSeller': bestSeller
        });
      });
    } else {
      return firestore.collection('items').add({
        'name': name,
        'desc': desc,
        'category': category,
        'sizes': sizes
            .map((size) => {
                  'name': size.name,
                  'price': size.price,
                  'discount': size.discount
                })
            .toList(),
        'bestSeller': bestSeller
      });
    }
  }

  Future updateItem({
    required String id,
    required String name,
    required String desc,
    required String category,
    required File? image,
    bool updateImage = false,
    required List<Size> sizes,
    required bool bestSeller,
  }) async {
    if (updateImage && image != null) {
      String fileName = Methods.getRandomString(10);
      String ext = p.extension(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;

      return storage
          .ref('items/$fileName.$ext')
          .putFile(image)
          .then((p0) async {
        String url = await storage.ref('items/$fileName.$ext').getDownloadURL();
        return firestore.collection('items').doc(id).update({
          'name': name,
          'desc': desc,
          'category': category,
          'sizes': sizes
              .map((size) => {
                    'name': size.name,
                    'price': size.price,
                    'discount': size.discount
                  })
              .toList(),
          'imgUrl': url,
          'bestSeller': bestSeller
        });
      });
    } else {
      return firestore.collection('items').doc(id).update({
        'name': name,
        'desc': desc,
        'category': category,
        'sizes': sizes
            .map((size) => {
                  'name': size.name,
                  'price': size.price,
                  'discount': size.discount
                })
            .toList(),
        'bestSeller': bestSeller
      });
    }
  }
}