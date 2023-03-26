import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Appointments {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addNewAppointment({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required String name,
    required String notes,
    required Color color,
  }) {
    return firestore.collection('appointments').add({
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'name': name,
      'notes': notes,
      'time': FieldValue.serverTimestamp(),
      'color': color.value
    });
  }

  Future<List<Appointment>> getAppointments({
    required String userId,
    required DateTime date,
  }) async {
    DateTime startDate = DateTime(date.year, date.month, date.day);
    DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59);
    QuerySnapshot snapshot = await firestore
        .collection('appointments')
        .where('userId', whereIn: [userId, 'mars'])
        .where('startDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return snapshot.docs.map((doc) {
      return Appointment(
        startTime: (doc.get('startDate') as Timestamp).toDate(),
        endTime: (doc.get('endDate') as Timestamp).toDate(),
        notes: doc.get('notes'),
        subject: doc.get('name'),
        color: Color(doc.get('color')),
      );
    }).toList();
  }

  Query getAppointmentsQuery({
    required String userId,
  }) {
    return firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('startDate', descending: true);
  }
}
