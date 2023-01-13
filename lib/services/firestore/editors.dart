import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/editor.dart';

class Editors {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream getEditors() {
    Stream<QuerySnapshot> snapshot =
        firestore.collection('editors').snapshots();

    return snapshot
        .map((event) => event.docs.map((e) => Editor.fromDoc(e)).toList());
  }

  Future addEditor(String name, String email) {
    return firestore.collection('editors').add({
      'name': name,
      'email': email,
    });
  }

  Future dropEditor(String id) {
    return firestore.collection('editors').doc(id).delete();
  }
}
