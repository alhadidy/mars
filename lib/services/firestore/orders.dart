import 'package:cloud_firestore/cloud_firestore.dart' as firestoreDB;
import 'package:mars/models/order.dart';
import 'package:mars/models/order_item.dart';
import 'package:mars/services/methods.dart';

class Orders {
  firestoreDB.FirebaseFirestore firestore =
      firestoreDB.FirebaseFirestore.instance;

  Future<void> addOrder({
    required String userId,
    required String userName,
    required firestoreDB.GeoPoint location,
    required String storeId,
    required firestoreDB.GeoPoint storeLocation,
    required String storeName,
    required String address,
    required String city,
    required String phone,
    required List<OrderItem> items,
    required bool confirmed,
    required bool delivered,
    required bool canceled,
    required bool delivering,
    required String deliverBy,
    required int deliveryPrice,
    required int totalPrice,
    required bool inStore,
  }) async {
    firestoreDB.CollectionReference ref = firestore.collection('orders');
    await ref.add({
      'inStore': inStore,
      'location': location,
      'address': address,
      'city': city,
      'user_id': userId,
      'userName': userName,
      'storeId': storeId,
      'storeName': storeName,
      'storeLocation': storeLocation,
      'phone': phone,
      'timestamp': firestoreDB.FieldValue.serverTimestamp(),
      'items': items
          .map((e) => {
                'fid': e.fid,
                'name': e.name,
                'imgUrl': e.imgUrl,
                'price': e.price,
                'quantity': e.quantity,
                'discount': e.discount,
              })
          .toList(),
      'confirmed': confirmed,
      'delivered': delivered,
      'canceled': canceled,
      'delivering': delivering,
      'deliverBy': deliverBy,
      'deliveryPrice': deliveryPrice,
      'totalPrice': totalPrice,
      'orderNum': Methods.getRandomNumber(length: 8),
      'cashed': false,
    });
  }

  Stream<List<Order>> getOrdersByUser(String uid) {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    Stream<firestoreDB.QuerySnapshot> orders = ref
        .orderBy('timestamp', descending: true)
        .where('user_id', isEqualTo: uid)
        .snapshots();

    return orders.map((event) {
      return event.docs.map((e) {
        return Order.fromDoc(e);
      }).toList();
    });
  }

  Stream<Order> watchOrder(String fid) {
    firestoreDB.DocumentReference ref = firestore.collection('orders').doc(fid);

    Stream<firestoreDB.DocumentSnapshot> order = ref.snapshots();
    return order.map((event) => Order.fromDoc(event));
  }

  Stream<List<Order>> getOrdersForAdmin() {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    Stream<firestoreDB.QuerySnapshot> orders =
        ref.orderBy('timestamp', descending: true).snapshots();

    return orders.map((event) {
      return event.docs.map((e) {
        return Order.fromDoc(e);
      }).toList();
    });
  }

  Stream<List<Order>> getOrdersToDelivery(String city, String uId) {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    Stream<firestoreDB.QuerySnapshot> orders = ref
        .orderBy('timestamp', descending: true)
        .where('city', isEqualTo: city)
        .where('confirmed', isEqualTo: true)
        .where('delivering', isEqualTo: false)
        .where('delivered', isEqualTo: false)
        .where('canceled', isEqualTo: false)
        .where('deliverBy', isEqualTo: '')
        .snapshots();

    return orders.map((event) {
      return event.docs.map((e) {
        return Order.fromDoc(e);
      }).toList();
    });
  }

  Stream<List<Order>> getOrdersToDeliveryByUser(String uId) {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    Stream<firestoreDB.QuerySnapshot> orders = ref
        .orderBy('timestamp', descending: true)
        .where('deliverBy', isEqualTo: uId)
        .snapshots();

    return orders.map((event) {
      return event.docs.map((e) {
        return Order.fromDoc(e);
      }).toList();
    });
  }

  Future<void> removeFromMyDelivery(String docId, String userId) async {
    firestoreDB.DocumentReference ref =
        firestore.collection('orders').doc(docId);
    firestoreDB.CollectionReference driverRef = firestore.collection('drivers');
    firestoreDB.QuerySnapshot snapshot =
        await driverRef.where('uid', isEqualTo: userId).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      firestoreDB.WriteBatch batch = firestore.batch();
      batch.update(ref, {
        'deliverBy': '',
        'delivering': false,
      });
      batch.update(snapshot.docs.first.reference, {'active': true});
      batch.commit();
    }
  }

  Future<void> setOrderDelivered(String docId) async {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    await ref.doc(docId).update({
      'delivered': true,
      'delivering': false,
    });
  }

  Future<void> setOrderDelivering(String docId) async {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    await ref.doc(docId).update({
      'delivering': true,
    });
  }

  Future<void> setAcceptDelivering(String docId, String userId) async {
    firestoreDB.DocumentReference orderRef =
        firestore.collection('orders').doc(docId);
    firestoreDB.CollectionReference driverRef = firestore.collection('drivers');
    firestoreDB.QuerySnapshot snapshot =
        await driverRef.where('uid', isEqualTo: userId).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      firestoreDB.WriteBatch batch = firestore.batch();
      batch.update(orderRef, {'deliverBy': userId});
      batch.update(snapshot.docs.first.reference, {'active': false});
      batch.commit();
    }
  }

  Future<void> canceleOrder(
    String docId,
  ) async {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    await ref.doc(docId).update({
      'canceled': true,
    });
  }

  Future<void> activateOrder(
    String docId,
  ) async {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    await ref.doc(docId).update({
      'canceled': false,
    });
  }

  Future<void> confirmOrder(
    String docId,
  ) async {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    await ref.doc(docId).update({
      'confirmed': true,
    });
  }

  Future<void> unConfirmOrder(
    String docId,
  ) async {
    firestoreDB.CollectionReference ref = firestore.collection('orders');

    await ref.doc(docId).update({
      'confirmed': false,
    });
  }

  Future<void> orderCashed(String docId, String userId) async {
    firestoreDB.DocumentReference ref =
        firestore.collection('orders').doc(docId);
    firestoreDB.CollectionReference driverRef = firestore.collection('drivers');
    firestoreDB.QuerySnapshot snapshot =
        await driverRef.where('uid', isEqualTo: userId).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      firestoreDB.WriteBatch batch = firestore.batch();
      batch.update(snapshot.docs.first.reference, {'active': true});
      batch.update(ref, {
        'cashed': true,
      });
      batch.commit();
    }
  }

  Stream<List<Order>> watchStoreWaitingOrders() {
    Stream<firestoreDB.QuerySnapshot> snapshot = firestore
        .collection('orders')
        .where('confirmed', isEqualTo: false)
        .where('delivering', isEqualTo: false)
        .where('delivered', isEqualTo: false)
        .where('canceled', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
    return snapshot.map((event) {
      return event.docs.map((doc) {
        return Order.fromDoc(doc);
      }).toList();
    });
  }

  Future<List> getStoreWaitingOrders(String storeId) async {
    firestoreDB.QuerySnapshot snapshot = await firestore
        .collection('orders')
        .where('storeId', isEqualTo: storeId)
        .where('confirmed', isEqualTo: false)
        .where('delivering', isEqualTo: false)
        .where('delivered', isEqualTo: false)
        .where('canceled', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return Order.fromDoc(doc);
    }).toList();
  }

  Stream<List<Order>> watchStoreConfirmedOrders() {
    Stream<firestoreDB.QuerySnapshot> snapshot = firestore
        .collection('orders')
        .where('confirmed', isEqualTo: true)
        .where('delivering', isEqualTo: false)
        .where('delivered', isEqualTo: false)
        .where('canceled', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
    return snapshot.map((event) {
      return event.docs.map((doc) {
        return Order.fromDoc(doc);
      }).toList();
    });
  }

  Future<List> getStoreConfirmedOrders(
      String storeId, DateTime? selectedDate) async {
    firestoreDB.QuerySnapshot snapshot;
    if (selectedDate != null) {
      firestoreDB.Timestamp timestamp =
          firestoreDB.Timestamp.fromDate(selectedDate);
      firestoreDB.Timestamp timestampPlusOneDay =
          firestoreDB.Timestamp.fromDate(
              selectedDate.add(const Duration(days: 1)));
      snapshot = await firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId)
          .where('confirmed', isEqualTo: true)
          .where('delivering', isEqualTo: false)
          .where('delivered', isEqualTo: false)
          .where('canceled', isEqualTo: false)
          .where('timestamp', isGreaterThanOrEqualTo: timestamp)
          .where('timestamp', isLessThan: timestampPlusOneDay)
          .orderBy('timestamp', descending: true)
          .get();
    } else {
      snapshot = await firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId)
          .where('confirmed', isEqualTo: true)
          .where('delivering', isEqualTo: false)
          .where('delivered', isEqualTo: false)
          .where('canceled', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();
    }

    return snapshot.docs.map((doc) {
      return Order.fromDoc(doc);
    }).toList();
  }

  Stream<List<Order>> watchStoreDeliveringOrders() {
    Stream<firestoreDB.QuerySnapshot> snapshot = firestore
        .collection('orders')
        .where('confirmed', isEqualTo: true)
        .where('delivering', isEqualTo: true)
        .where('delivered', isEqualTo: false)
        .where('canceled', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
    return snapshot.map((event) {
      return event.docs.map((doc) {
        return Order.fromDoc(doc);
      }).toList();
    });
  }

  Future<List> getStoreDeliveringOrders(String storeId) async {
    firestoreDB.QuerySnapshot snapshot = await firestore
        .collection('orders')
        .where('storeId', isEqualTo: storeId)
        .where('confirmed', isEqualTo: true)
        .where('delivering', isEqualTo: true)
        .where('delivered', isEqualTo: false)
        .where('canceled', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return Order.fromDoc(doc);
    }).toList();
  }

  Stream<List<Order>> watchStoreDeliveredOrders() {
    Stream<firestoreDB.QuerySnapshot> snapshot = firestore
        .collection('orders')
        .where('delivered', isEqualTo: true)
        .where('canceled', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
    return snapshot.map((event) {
      return event.docs.map((doc) {
        return Order.fromDoc(doc);
      }).toList();
    });
  }

  Future<List<Order>> getStoreDeliveredOrders(
      String storeId, DateTime? selectedDate, DateTime selectedDatePlus) async {
    firestoreDB.Query query;
    if (selectedDate != null) {
      firestoreDB.Timestamp timestamp =
          firestoreDB.Timestamp.fromDate(selectedDate);
      firestoreDB.Timestamp timestampPlusOneDay =
          firestoreDB.Timestamp.fromDate(selectedDatePlus);
      query = firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId)
          .where('delivered', isEqualTo: true)
          .where('canceled', isEqualTo: false)
          .where('timestamp', isGreaterThanOrEqualTo: timestamp)
          .where('timestamp', isLessThan: timestampPlusOneDay)
          .orderBy('timestamp', descending: true);
    } else {
      query = firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId)
          .where('delivered', isEqualTo: true)
          .where('canceled', isEqualTo: false)
          .orderBy('timestamp', descending: true);
    }

    firestoreDB.QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) {
      return Order.fromDoc(doc);
    }).toList();
  }

  Stream<List<Order>> watchStoreCanceledOrders() {
    Stream<firestoreDB.QuerySnapshot> snapshot = firestore
        .collection('orders')
        .where('canceled', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
    return snapshot.map((event) {
      return event.docs.map((doc) {
        return Order.fromDoc(doc);
      }).toList();
    });
  }

  Future<List> getStoreCanceledOrders(
      String storeId, DateTime? selectedDate) async {
    firestoreDB.Query query;
    if (selectedDate != null) {
      firestoreDB.Timestamp timestamp =
          firestoreDB.Timestamp.fromDate(selectedDate);
      firestoreDB.Timestamp timestampPlusOneDay =
          firestoreDB.Timestamp.fromDate(
              selectedDate.add(const Duration(days: 1)));
      query = firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId)
          .where('canceled', isEqualTo: true)
          .where('timestamp', isGreaterThanOrEqualTo: timestamp)
          .where('timestamp', isLessThan: timestampPlusOneDay)
          .orderBy('timestamp', descending: true);
    } else {
      query = firestore
          .collection('orders')
          .where('storeId', isEqualTo: storeId)
          .where('canceled', isEqualTo: true)
          .orderBy('timestamp', descending: true);
    }
    firestoreDB.QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) {
      return Order.fromDoc(doc);
    }).toList();
  }
}
