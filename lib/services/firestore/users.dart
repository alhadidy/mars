import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:mars/models/user.dart';
import 'package:mars/models/user_data.dart';

class Users {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<Role> getRole(UserModel? user) {
    if (user == null || user.uid.isEmpty) {
      return Stream.error('getRole: the user is null');
    }
    DocumentReference ref = firestore
        .collection('users')
        .doc(user.uid)
        .collection('private')
        .doc('access');
    Stream<DocumentSnapshot> snapshot = ref.snapshots();

    return snapshot.map((event) {
      return Role.fromDoc(event);
    });
  }

  Stream<UserData> watchUserData(UserModel? _user) {
    if (_user == null) {
      return Stream.value(UserData([], 0));
    }
    DocumentReference ref = firestore.collection('users').doc(_user.uid);

    Stream<DocumentSnapshot> userData = ref.snapshots();

    return userData.map((event) {
      return UserData.fromDoc(event);
    });
  }

  Future<void> setUserTags(String userId, List<dynamic>? itemTags) async {
    if (itemTags == null || itemTags.isEmpty) {
      return;
    }
    DocumentReference ref = firestore.collection('users').doc(userId);

    await ref.set({
      'tags': itemTags,
    }, SetOptions(merge: true));
  }

  updateUserLastSignInAndToken(UserModel user) async {
    DocumentReference ref = firestore.collection('users').doc(user.uid);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    ref.update(
      {
        'lastSignIn': FieldValue.serverTimestamp(),
        'FCM_Token': token,
      },
    );
  }

  updateUserCity(String userId, String city) async {
    DocumentReference ref = firestore.collection('users').doc(userId);

    ref.update(
      {'city': city},
    );
  }

  Future<bool> deleteUserFCMToken(String userId) async {
    DocumentReference ref = firestore.collection('users').doc(userId);

    await ref.update(
      {'FCM_Token': ''},
    );
    return true;
  }

  // Future<List<Address>> getUserPlaces(String userId) async {
  //   CollectionReference ref =
  //       firestore.collection('users').doc(userId).collection('places');

  //   QuerySnapshot places = await ref.get();

  //   return places.docs.map((e) => Address.fromDoc(e)).toList();
  // }

  // Future<void> updateUserPlace(
  //     AddressType type,
  //     String name,
  //     String phone,
  //     String address,
  //     LatLng latLng,
  //     String userId,
  //     String addressId,
  //     String city) async {
  //   DocumentReference ref = firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('places')
  //       .doc(addressId);
  //   String _type;
  //   switch (type) {
  //     case AddressType.home:
  //       _type = 'home';
  //       break;
  //     case AddressType.work:
  //       _type = 'work';
  //       break;
  //     case AddressType.friend:
  //       _type = 'friend';
  //       break;
  //     case AddressType.lover:
  //       _type = 'lover';
  //       break;
  //     default:
  //       _type = 'home';
  //   }
  //   final geo = Geoflutterfire();
  //   GeoFirePoint location =
  //       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

  //   await ref.set({
  //     'type': _type,
  //     'name': name,
  //     'address': address,
  //     'phone': phone,
  //     'location': location.data,
  //     'city': city,
  //   }, SetOptions(merge: true));
  // }

  // Future<void> setUserPlace(AddressType type, String name, String phone,
  //     String address, LatLng latLng, String userId, String city) async {
  //   DocumentReference ref =
  //       firestore.collection('users').doc(userId).collection('places').doc();
  //   String _type;
  //   switch (type) {
  //     case AddressType.home:
  //       _type = 'home';
  //       break;
  //     case AddressType.work:
  //       _type = 'work';
  //       break;
  //     case AddressType.friend:
  //       _type = 'friend';
  //       break;
  //     case AddressType.lover:
  //       _type = 'lover';
  //       break;
  //     default:
  //       _type = 'home';
  //   }
  //   final geo = Geoflutterfire();
  //   GeoFirePoint location =
  //       geo.point(latitude: latLng.latitude, longitude: latLng.longitude);

  //   await ref.set({
  //     'type': _type,
  //     'name': name,
  //     'address': address,
  //     'phone': phone,
  //     'location': location.data,
  //     'city': city
  //   }, SetOptions(merge: true));
  // }

  // Future addPet(BuildContext context, String userId, String name, String type,
  //     File image) async {
  //   DocumentReference ref =
  //       firestore.collection('users').doc(userId).collection('pets').doc();

  //   return ref.set({
  //     'name': name,
  //     'type': type,
  //     'imgUrl': '',
  //     'date': FieldValue.serverTimestamp()
  //   }).then((value) {
  //     if (image != null) {
  //       StorageService().uploadPetImage(image, userId, ref.id, context);
  //     }
  //   });
  // }

  // Stream<List<Pet>> getPets(String userId) {
  //   Query ref = firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('pets')
  //       .orderBy('date', descending: true);
  //   Stream<QuerySnapshot> snapshot = ref.snapshots();
  //   return snapshot.map((event) {
  //     return event.docs.map((e) => Pet.fromDoc(e)).toList();
  //   });
  // }

  // Stream<Pet> getPet(String petId, String userId) {
  //   DocumentReference ref =
  //       firestore.collection('users').doc(userId).collection('pets').doc(petId);
  //   Stream<DocumentSnapshot> snapshot = ref.snapshots();

  //   return snapshot.map((event) {
  //     return Pet.fromDoc(event);
  //   });
  // }
}
