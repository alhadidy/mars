import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String phone;
  final bool isAnon;
  final Roles role;
  final int accessLevel;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.phone,
      required this.isAnon,
      this.accessLevel = 0,
      this.role = Roles.user});

  UserModel copyWith(
      {String? uid,
      String? name,
      String? sp,
      String? photoUrl,
      String? phone,
      String? email,
      bool? isAnon,
      int? accessLevel,
      Roles? role}) {
    return UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        isAnon: isAnon ?? this.isAnon,
        role: role ?? this.role,
        accessLevel: accessLevel ?? this.accessLevel);
  }
}

class Role {
  String? uid;
  Roles role;
  int accessLevel;
  int refreshTime;

  Role(
      {this.uid,
      required this.role,
      required this.accessLevel,
      required this.refreshTime});

  static Roles getRolesFromString(String value) {
    switch (value) {
      case 'admin':
        return Roles.admin;
      case 'owner':
        return Roles.owner;
      case 'editor':
        return Roles.editor;
      default:
        return Roles.user;
    }
  }

  factory Role.fromDoc(DocumentSnapshot doc) {
    if (doc.data() == null) {
      return Role(role: Roles.user, refreshTime: 0, accessLevel: 0);
    }

    Roles role = getRolesFromString(doc.get('role'));

    return Role(
      uid: doc.id,
      role: role,
      accessLevel: doc.get('accessLevel') ?? 0,
      refreshTime: doc.get('refreshTime') ?? 0,
    );
  }
}

enum Roles { admin, owner, editor, user }
