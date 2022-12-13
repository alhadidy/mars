import 'package:cloud_firestore/cloud_firestore.dart';

class Promo {
  Promo(
      {required this.name,
      required this.imgUrl,
      required this.active,
      required this.timestamp,
      required this.fid,
      required this.body,
      required this.subbody,
      required this.subtitle,
      required this.title,
      required this.actionType,
      required this.itemId});

  String fid;
  String name;
  String title;
  String subtitle;
  String body;
  String subbody;
  String imgUrl;
  bool active;
  Timestamp timestamp;
  ActionType actionType;
  String itemId;

  static ActionType actionFromString(String action) {
    switch (action) {
      case 'itemPage':
        return ActionType.itemPage;
      default:
        return ActionType.none;
    }
  }

  factory Promo.fromDoc(QueryDocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Promo(
        name: data['name'] ?? '',
        imgUrl: data['imgUrl'] ?? '',
        active: data['active'] ?? false,
        timestamp: data['timestamp'],
        fid: doc.id,
        body: data['body'] ?? '',
        subbody: data['subBody'] ?? '',
        subtitle: data['subTitle'] ?? '',
        title: data['title'] ?? '',
        actionType: actionFromString(data['actionType'] ?? 'none'),
        itemId: data['itemId'] ?? '');
  }
}

enum ActionType { none, itemPage }
