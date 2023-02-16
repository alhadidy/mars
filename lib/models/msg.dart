import 'package:cloud_firestore/cloud_firestore.dart';

class Msg {
  final String fid;
  final String userId;
  final String supportId;
  final String content;
  final Timestamp time;

  Msg(this.fid, this.userId, this.supportId, this.content, this.time);

  factory Msg.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Msg(doc.id, data['userId'], data['supportId'], data['content'],
        data['time']);
  }
}
