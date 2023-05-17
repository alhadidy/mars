import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/user_info.dart';

class UserData {
  final List<dynamic> tags;
  final int points;
  final int cash;
  final UserInfo? info;
  UserData(this.tags, this.points, this.cash, this.info);

  factory UserData.fromDoc(DocumentSnapshot doc) {
    Map map = doc.data() as Map;

    UserInfo? info;

    if (map['info'] != null) {
      info = UserInfo.fromDoc(map['info']);
    }

    return UserData(
      map['tags'] ?? [],
      map['points'] ?? 0,
      map['cash'] ?? 0,
      info,
    );
  }
}
