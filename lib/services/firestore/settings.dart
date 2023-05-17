import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mars/models/sSettings.dart';

//TODO
//set delivery price
//set default reward amount
//set card types
//set app dev true

class SSettings {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<SSetting> getShopSettings() {
    DocumentReference ref = firestore.collection('settings').doc('sSettings');

    try {
      Stream<DocumentSnapshot> settings = ref.snapshots();
      return settings.map((event) {
        return SSetting.fromDoc(event, firestore);
      });
    } catch (e) {
      debugPrint(e.toString());
      return Stream.error(e);
    }
  }

  Stream<Map> watchSettings() {
    CollectionReference ref = firestore.collection('settings');

    Stream<QuerySnapshot> settings = ref.snapshots();

    Map map = {};

    return settings.map((event) {
      for (var e in event.docs) {
        map[e.id] = e.get('value');
      }
      return map;
    });
  }

  Future updateSettings(Map<Object, Object?> data) async {
    DocumentReference ref = firestore.collection('settings').doc('sSettings');
    return ref.update(data);
  }
}
