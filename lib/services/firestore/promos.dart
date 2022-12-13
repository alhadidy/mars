import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/services/methods.dart';
import 'package:path/path.dart' as p;

class Promos {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Promo>> getPromos() {
    Stream<QuerySnapshot> snapshot = firestore.collection('promos').snapshots();

    return snapshot.map((event) {
      return event.docs.map((e) => Promo.fromDoc(e)).toList();
    });
  }

  Stream<List<Promo>> getActivePromos() {
    Stream<QuerySnapshot> snapshot = firestore
        .collection('promos')
        .where('active', isEqualTo: true)
        .snapshots();

    return snapshot.map((event) {
      return event.docs.map((e) => Promo.fromDoc(e)).toList();
    });
  }

  Future deletePromo(String id) {
    return firestore.collection('promos').doc(id).delete();
  }

  Future addPromo(
      {required String name,
      required String title,
      required String subTitle,
      required String body,
      required String subBody,
      required File image,
      bool active = false}) {
    String fileName = Methods.getRandomString(10);
    String ext = p.extension(image.path);
    FirebaseStorage storage = FirebaseStorage.instance;

    return storage.ref('promos/$fileName.$ext').putFile(image).then((p0) async {
      String url = await storage.ref('promos/$fileName.$ext').getDownloadURL();
      return firestore.collection('promos').add({
        'name': name,
        'title': title,
        'subTitle': subTitle,
        'body': body,
        'subBody': subBody,
        'timestamp': FieldValue.serverTimestamp(),
        'active': active,
        'imgUrl': url,
      });
    });
  }

  Future updatePromo({
    required String id,
    required String name,
    required String title,
    required String subTitle,
    required String body,
    required String subBody,
    required bool active,
    required File image,
    bool updateImage = false,
  }) {
    if (updateImage) {
      String fileName = Methods.getRandomString(10);
      String ext = p.extension(image.path);
      FirebaseStorage storage = FirebaseStorage.instance;

      return storage
          .ref('promos/$fileName.$ext')
          .putFile(image)
          .then((p0) async {
        String url =
            await storage.ref('promos/$fileName.$ext').getDownloadURL();
        return firestore.collection('promos').doc(id).update({
          'name': name,
          'title': title,
          'subTitle': subTitle,
          'body': body,
          'subBody': subBody,
          'active': active,
          'imgUrl': url,
        });
      });
    } else {
      return firestore.collection('promos').doc(id).update({
        'name': name,
        'title': title,
        'subTitle': subTitle,
        'body': body,
        'subBody': subBody,
        'active': active,
      });
    }
  }
}
