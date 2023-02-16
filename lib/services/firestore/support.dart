import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/msg.dart';

class Support {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Msg>> watchMsgs() {
    Stream<QuerySnapshot> msgs = firestore.collection('support').snapshots();

    return msgs.map((event) => event.docs.map((e) => Msg.fromDoc(e)).toList());
  }

  addMsg(String userId, String content, String support, String msgId) async {
    if (support == '') {
      await firestore.collection('support').add({
        'userId': userId,
        'content': content,
        'supportId': support,
        'time': FieldValue.serverTimestamp()
      });
    } else {
      final batch = firestore.batch();

      batch.set(firestore.collection('support').doc(), {
        'userId': userId,
        'content': content,
        'supportId': support,
        'replayTo': msgId,
        'time': FieldValue.serverTimestamp()
      });

      batch.update(firestore.collection('support').doc(msgId), {
        'supportId': support,
      });

      batch.commit();
    }
  }
}
