import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final List<dynamic> tags;
  final int points;
  final int cash;
  UserData(this.tags, this.points, this.cash);

  factory UserData.fromDoc(DocumentSnapshot doc) {
    Map map = doc.data() as Map;

    return UserData(
      map['tags'] ?? [],
      map['points'] ?? 0,
      map['cash'] ?? 0,
    );
  }
}
