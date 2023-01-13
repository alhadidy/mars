import 'package:cloud_firestore/cloud_firestore.dart';

class Editor {
  final String fid;
  final String? uid;
  final String name;
  final String error;
  final String email;

  Editor({
    required this.fid,
    required this.uid,
    required this.name,
    required this.error,
    required this.email,
  });

  factory Editor.fromDoc(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Editor(
      fid: doc.id,
      uid: data['uid'],
      name: data['name'] ?? '',
      error: data['error'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
