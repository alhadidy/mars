import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/payment.dart';

class Payments {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addPayment(String userId, int amount) {
    return firestore.collection('payments').add({
      'userId': userId,
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pendding'
    });
  }

  Stream<List<Payment>> watchPayments() {
    Stream<QuerySnapshot> snapshot = firestore
        .collection('payments')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return snapshot.map((event) {
      return event.docs.map((doc) => Payment.fromDoc(doc)).toList();
    });
  }
}
