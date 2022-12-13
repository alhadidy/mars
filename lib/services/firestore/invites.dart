import 'package:cloud_firestore/cloud_firestore.dart';

class Invites {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  setUserInvite(String inviteId, String userId) async {
    DocumentReference ref = firestore.collection('invites').doc(userId);
    ref.set({
      'invitedBy': inviteId,
    }, SetOptions(merge: true));
  }
}
