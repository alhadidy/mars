import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/card.dart';

class Cards {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addNewGiftCard(
      {required String id,
      required String name,
      required int amount,
      required String editorId}) {
    return firestore.collection('cards').doc(id).set({
      'id': id,
      'name': name,
      'amount': amount,
      'time': FieldValue.serverTimestamp(),
      'addedBy': editorId,
      'redeemed': false
    });
  }

  Stream getActiveCards() {
    Stream<QuerySnapshot> stream = firestore
        .collection('cards')
        .where('redeemed', isEqualTo: false)
        .orderBy('amount')
        .snapshots();

    return stream
        .map((event) => event.docs.map((e) => Card.fromDoc(e)).toList());
  }
}
