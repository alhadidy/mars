import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mars/models/category.dart';
import 'package:mars/services/methods.dart';
import 'package:path/path.dart' as p;

class Categories {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Category>> getCategories() {
    Stream<QuerySnapshot> snapshot = firestore
        .collection('categories')
        .orderBy(
          'order',
        )
        .snapshots();

    return snapshot.map((event) {
      return event.docs.map((e) => Category.fromDoc(e)).toList();
    });
  }

  Future<List<Category>> getCategoriesFuturer() async {
    QuerySnapshot snapshot = await firestore.collection('categories').get();

    return snapshot.docs.map((doc) {
      return Category.fromDoc(doc);
    }).toList();
  }

  Future addCategory(
      {required String name, required File? image, int order = 0}) {
    if (image != null) {
      String fileName = Methods.getRandomString(10);
      String ext = p.extension(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      return storage
          .ref('categories/$fileName.$ext')
          .putFile(image)
          .then((p0) async {
        String url =
            await storage.ref('categories/$fileName.$ext').getDownloadURL();
        firestore.collection('categories').add({
          'name': name,
          'order': order,
          'imgUrl': url,
        });
      });
    } else {
      return firestore.collection('categories').add({
        'name': name,
        'order': order,
      });
    }
  }

  Future updateCategory(
      {required String fid,
      required String name,
      required File? image,
      int order = 1,
      bool updateImage = false}) {
    if (updateImage && image != null) {
      String fileName = Methods.getRandomString(10);
      String ext = p.extension(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      return storage
          .ref('categories/$fileName.$ext')
          .putFile(image)
          .then((p0) async {
        String url =
            await storage.ref('categories/$fileName.$ext').getDownloadURL();
        firestore.collection('categories').doc(fid).update({
          'name': name,
          'order': order,
          'imgUrl': url,
        });
      });
    } else {
      return firestore.collection('categories').doc(fid).update({
        'name': name,
        'order': order,
      });
    }
  }

  Future deleteCategory({required String id}) {
    return firestore.collection('categories').doc(id).delete();
  }
}
