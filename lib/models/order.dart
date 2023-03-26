import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mars/models/order_item.dart';
import 'package:mars/services/methods.dart';

class Order {
  Order({
    required this.fid,
    required this.confirmed,
    required this.delivered,
    required this.canceled,
    required this.delivering,
    required this.items,
    required this.location,
    required this.address,
    required this.phone,
    required this.time,
    required this.date,
    required this.deliveryPrice,
    required this.totalPrice,
    required this.deliverBy,
    required this.orderNum,
    required this.userId,
    required this.userName,
    required this.storeId,
    required this.storeLocation,
    required this.storeName,
    required this.city,
    required this.status,
    required this.cashed,
    required this.walletPay,
  });

  String fid;
  bool confirmed;
  bool delivered;
  bool canceled;
  bool delivering;
  GeoPoint location;
  String address;
  String phone;
  Timestamp time;
  String date;
  String userId;
  String userName;
  String storeId;
  GeoPoint storeLocation;
  String storeName;
  String deliverBy;
  List<OrderItem> items;
  int deliveryPrice;
  int totalPrice;
  String orderNum;
  String city;
  OrderStatus status;
  bool cashed;
  bool walletPay;

  factory Order.fromDoc(DocumentSnapshot doc) {
    Map docData = doc.data() as Map;

    List<dynamic> items = docData['items'];
    bool confirmed = docData['confirmed'] ?? false;
    bool delivered = docData['delivered'] ?? false;
    bool canceled = docData['canceled'] ?? false;
    bool delivering = docData['delivering'] ?? false;
    return Order(
      fid: doc.id,
      city: docData['city'] ?? '',
      status:
          Methods.getOrderStatus(confirmed, delivering, delivered, canceled),
      confirmed: confirmed,
      delivering: delivering,
      delivered: delivered,
      canceled: canceled,
      location: docData['location'],
      address: docData['address'] ?? '',
      phone: docData['phone'] ?? '',
      time: docData['timestamp'],
      date: docData['date'] ?? '',
      deliveryPrice: docData['deliveryPrice'] ?? 0,
      totalPrice: docData['totalPrice'] ?? 0,
      deliverBy: docData['deliverBy'] ?? '',
      userId: docData['userId'] ?? '',
      userName: docData['userName'] ?? '',
      storeId: docData['storeId'],
      storeLocation: docData['storeLocation'],
      storeName: docData['storeName'] ?? '',
      orderNum: docData['orderNum'] ?? '',
      cashed: docData['cashed'] ?? false,
      walletPay: docData['walletPay'],
      items: items.map((e) {
        return OrderItem(
          fid: e['fid'] ?? '',
          name: e['name'] ?? '',
          imgUrl: e['imgUrl'] ?? '',
          price: e['price'] ?? 0.0,
          quantity: e['quantity'] ?? 1,
          discount: e['discount'],
        );
      }).toList(),
    );
  }
}

enum OrderStatus { pendding, confirmed, delivering, delivered, canceled, other }
