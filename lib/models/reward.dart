import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  final String fid;
  final String userId;
  final String editorId;
  final String userEmail;
  final int amount;
  final String status;
  final String? error;
  final Timestamp timestamp;

  Reward(
      {required this.fid,
      required this.userId,
      required this.editorId,
      required this.userEmail,
      required this.amount,
      required this.status,
      this.error,
      required this.timestamp});

  factory Reward.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Reward(
      fid: doc.id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      editorId: data['editorId'] ?? '',
      amount: data['amount'],
      error: data['error'],
      status: data['status'] ?? 'pendding',
      timestamp: data['timestamp'],
    );
  }
}
