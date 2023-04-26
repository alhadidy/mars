import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mars/screens/admin/widgets.dart/orders_type_tags.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mars/services/firestore/orders.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';

import '../../models/order.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  late Stream watchOrders;
  String ordersType = 'Pending';

  @override
  void initState() {
    watchOrders = locator.get<Orders>().watchStoreWaitingOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Orders'),
      ),
      body: Column(
        children: [
          OrderTypeTags(
            selectedType: ordersType,
            onTypeSelected: ((type) {
              setState(() {
                ordersType = type;
                switch (type) {
                  case 'Confirmed':
                    watchOrders =
                        locator.get<Orders>().watchStoreConfirmedOrders();
                    break;
                  case 'Delivering':
                    watchOrders =
                        locator.get<Orders>().watchStoreDeliveringOrders();
                    break;
                  case 'Delivered':
                    watchOrders =
                        locator.get<Orders>().watchStoreDeliveredOrders();
                    break;
                  case 'Canceled':
                    watchOrders =
                        locator.get<Orders>().watchStoreCanceledOrders();
                    break;
                  default:
                    watchOrders =
                        locator.get<Orders>().watchStoreWaitingOrders();
                }
              });
            }),
          ),
          Expanded(
            child: StreamBuilder(
              stream: watchOrders,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data.length == 0) {
                  return const Center(
                    child: Text('لا توجد طلبات حاليا'),
                  );
                }

                List<Order> orders = snapshot.data;
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 8,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        child: FaIcon(
                                          FontAwesomeIcons.truck,
                                          size: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(Methods.formatOrderNum(
                                            orders[index].orderNum.toString())),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        Methods.formatDate(
                                            orders[index].time, 'en'),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(Methods.formatTime(
                                          orders[index].time, 'en')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('العنوان: ${orders[index].address}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('الاسم: ${orders[index].userName}'),
                            ),
                            const Divider(),
                            SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                children: orders[index].items.map((item) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.name,
                                              style: GoogleFonts.tajawal(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${Methods.formatPrice(item.price)} د.ع',
                                              style: GoogleFonts.tajawal(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        leading: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: item.imgUrl,
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                  'assets/imgs/logo_dark.png');
                                            },
                                          ),
                                        ),
                                        subtitle: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              item.addons.isEmpty
                                                  ? Container()
                                                  : const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 16, right: 16),
                                                      child: Text('الإضافات:'),
                                                    ),
                                              Column(
                                                children:
                                                    item.addons.map((addon) {
                                                  return ListTile(
                                                    dense: true,
                                                    title: Text(addon['name']),
                                                    trailing: Text(
                                                        '${Methods.formatPrice(addon['price'])} د.ع'),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider()
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'قيمة الطلب: ${Methods.formatPrice(orders[index].totalPrice)} د.ع'),
                                      Text(
                                          'كلفة التوصيل: ${Methods.formatPrice(orders[index].deliveryPrice)} د.ع'),
                                    ],
                                  ),
                                  orders[index].status ==
                                              OrderStatus.delivered ||
                                          orders[index].status ==
                                              OrderStatus.canceled
                                      ? Container()
                                      : RoundIconButton(
                                          size: 36,
                                          icon: FontAwesomeIcons.boxesStacked,
                                          tooltip: 'Change Order State',
                                          onTap: (() {
                                            showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        orders[index].status !=
                                                                    OrderStatus
                                                                        .confirmed &&
                                                                orders[index]
                                                                        .status !=
                                                                    OrderStatus
                                                                        .delivering
                                                            ? ListTile(
                                                                onTap: (() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  locator
                                                                      .get<
                                                                          Orders>()
                                                                      .confirmOrder(
                                                                          orders[index]
                                                                              .fid);
                                                                }),
                                                                title: const Text(
                                                                    'Order Confirmed'),
                                                              )
                                                            : Container(),
                                                        orders[index].status !=
                                                                OrderStatus
                                                                    .delivering
                                                            ? ListTile(
                                                                onTap: (() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  locator
                                                                      .get<
                                                                          Orders>()
                                                                      .setOrderDelivering(
                                                                          orders[index]
                                                                              .fid);
                                                                }),
                                                                title: const Text(
                                                                    'Order Delivering'),
                                                              )
                                                            : Container(),
                                                        ListTile(
                                                          onTap: (() {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            locator
                                                                .get<Orders>()
                                                                .setOrderDelivered(
                                                                    orders[index]
                                                                        .fid);
                                                          }),
                                                          title: const Text(
                                                              'Order Delivered'),
                                                        ),
                                                        ListTile(
                                                          onTap: (() {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            locator
                                                                .get<Orders>()
                                                                .canceleOrder(
                                                                    orders[index]
                                                                        .fid);
                                                          }),
                                                          title: const Text(
                                                              'Order Canceled'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }));
                                          }),
                                        ),
                                  RoundIconButton(
                                    size: 36,
                                    icon: FontAwesomeIcons.mapLocation,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          final LatLng userMarker = LatLng(
                                              orders[index].location.latitude,
                                              orders[index].location.longitude);

                                          return AlertDialog(
                                            insetPadding: EdgeInsets.zero,
                                            contentPadding: EdgeInsets.zero,
                                            content: SizedBox(
                                              height: 500,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: GoogleMap(
                                                zoomControlsEnabled: false,
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: userMarker,
                                                  zoom: 18,
                                                ),
                                                markers: {
                                                  Marker(
                                                    markerId: const MarkerId(
                                                        'marker'),
                                                    position: userMarker,
                                                  ),
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  RoundIconButton(
                                      size: 36,
                                      icon: FontAwesomeIcons.phone,
                                      onTap: () async {
                                        final Uri launchUri = Uri(
                                          scheme: 'tel',
                                          path: orders[index].phone,
                                        );
                                        await launchUrl(launchUri);
                                      }),
                                ],
                              ),
                            ),
                            orders[index].walletPay
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.amber[600],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: const [
                                              FaIcon(
                                                FontAwesomeIcons.wallet,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: Text(
                                                    'الدفع عن طريق المحفظة',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              )
                                            ],
                                          ),
                                          Text(
                                            'المجموع:  ${Methods.formatPrice(orders[index].totalPrice + orders[index].deliveryPrice)} د.ع',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: const [
                                              FaIcon(
                                                FontAwesomeIcons.moneyBills,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: Text(
                                                  'الدفع نقداً',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            'المجموع:  ${Methods.formatPrice(orders[index].totalPrice + orders[index].deliveryPrice)} د.ع',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
