import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAppointmet {
  final String userId;
  final Timestamp startDate;
  final Timestamp endDate;
  final Timestamp time;
  final String name;
  final String notes;
  final Color color;

  UserAppointmet(
      {required this.userId,
      required this.startDate,
      required this.endDate,
      required this.time,
      required this.name,
      required this.notes,
      required this.color});

  factory UserAppointmet.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserAppointmet(
        userId: data['userId'],
        startDate: data['startDate'],
        endDate: data['endDate'],
        name: data['name'],
        notes: data['notes'] ?? '',
        time: data['time'],
        color: Color(data['color']));
  }
}
