import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                                      CircleAvatar(
                                        child: FaIcon(
                                          orders[index].inStore
                                              ? FontAwesomeIcons.store
                                              : FontAwesomeIcons.truck,
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
                                      Text(Methods.formatDate(
                                          orders[index].time, 'en')),
                                      Text(Methods.formatTime(
                                          orders[index].time, 'en')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            orders[index].inStore
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                        'العنوان: ${orders[index].address}'),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('الاسم: ${orders[index].userName}'),
                            ),
                            SizedBox(
                              height: 120,
                              width: double.maxFinite,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: orders[index].items.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Badge(
                                          badgeContent: Text(orders[index]
                                              .items[i]
                                              .quantity
                                              .toString()),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: CachedNetworkImage(
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover,
                                                imageUrl: orders[index]
                                                    .items[i]
                                                    .imgUrl),
                                          ),
                                        ),
                                        Text(orders[index].items[i].name),
                                        Text(
                                          Methods.formatPrice(
                                              Methods.roundPriceWithDiscountIQD(
                                                  price: orders[index]
                                                      .items[i]
                                                      .price,
                                                  discount: orders[index]
                                                      .items[i]
                                                      .discount)),
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider(),
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
                                      Container(
                                        height: 2,
                                        width: 100,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Text(
                                          'المجموع:  ${Methods.formatPrice(orders[index].totalPrice + orders[index].deliveryPrice)} د.ع'),
                                    ],
                                  ),
                                  orders[index].inStore
                                      ? Container()
                                      : RoundIconButton(
                                          icon: FontAwesomeIcons.mapLocation,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                final LatLng userMarker =
                                                    LatLng(
                                                        orders[index]
                                                            .location
                                                            .latitude,
                                                        orders[index]
                                                            .location
                                                            .longitude);

                                                return AlertDialog(
                                                  insetPadding: EdgeInsets.zero,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: SizedBox(
                                                    height: 500,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: GoogleMap(
                                                      zoomControlsEnabled:
                                                          false,
                                                      initialCameraPosition:
                                                          CameraPosition(
                                                        target: userMarker,
                                                        zoom: 18,
                                                      ),
                                                      markers: {
                                                        Marker(
                                                          markerId:
                                                              const MarkerId(
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
                            )
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
