import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String fid;
  final String userId;
  final int amount;
  final String status;
  final String? error;
  final Timestamp timestamp;

  Payment(
      {required this.fid,
      required this.userId,
      required this.amount,
      required this.status,
      this.error,
      required this.timestamp});

  factory Payment.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Payment(
      fid: doc.id,
      userId: data['userId'],
      amount: data['amount'],
      error: data['error'],
      status: data['status'] ?? 'pendding',
      timestamp: data['timestamp'],
    );
  }
}
