import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/reward.dart';

class Rewards {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addReward(String userId, String editorId, int amount) {
    return firestore.collection('rewards').add({
      'userId': userId,
      'editorId': editorId,
      'amount': amount,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pendding'
    });
  }

  Stream<List<Reward>> watchRewards() {
    Stream<QuerySnapshot> snapshot = firestore
        .collection('rewards')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return snapshot.map((event) {
      return event.docs.map((doc) => Reward.fromDoc(doc)).toList();
    });
  }
}
