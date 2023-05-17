import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final DateTime birth;
  final String gender;
  final String address;

  UserInfo({required this.birth, required this.gender, required this.address});

  factory UserInfo.fromDoc(Map info) {
    return UserInfo(
      birth: (info['birth'] as Timestamp).toDate(),
      gender: info['gender'],
      address: info['address'],
    );
  }
}
