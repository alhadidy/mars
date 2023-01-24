import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String type;
  final int amount;
  final int before;
  final int after;
  final Timestamp timestamp;

  Transaction(this.type, this.amount, this.before, this.after, this.timestamp);

  factory Transaction.fromDoc(DocumentSnapshot doc) {
    Map map = doc.data() as Map;

    return Transaction(
      map['type'],
      map['amount'],
      map['before'],
      map['after'],
      map['timestamp'],
    );
  }
}
