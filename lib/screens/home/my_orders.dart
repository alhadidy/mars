import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/order.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/firestore/orders.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class MyOrders extends ConsumerStatefulWidget {
  const MyOrders({super.key});

  @override
  ConsumerState<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends ConsumerState<MyOrders> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);

    return user == null
        ? Container()
        : StreamBuilder(
            stream: locator.get<Orders>().getOrdersByUser(user.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }

              if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد طلبات سابقة',
                    style: GoogleFonts.tajawal(),
                  ),
                );
              }

              List<Order> orders = snapshot.data;
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Card(
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
                                      RoundIconButton(
                                          size: 36,
                                          icon: orders[index].status ==
                                                  OrderStatus.pendding
                                              ? FontAwesomeIcons.hourglassHalf
                                              : orders[index].status ==
                                                      OrderStatus.confirmed
                                                  ? FontAwesomeIcons.check
                                                  : orders[index].status ==
                                                          OrderStatus.delivering
                                                      ? FontAwesomeIcons.truck
                                                      : orders[index].status ==
                                                              OrderStatus
                                                                  .delivered
                                                          ? FontAwesomeIcons
                                                              .checkDouble
                                                          : orders[index]
                                                                      .status ==
                                                                  OrderStatus
                                                                      .canceled
                                                              ? FontAwesomeIcons
                                                                  .xmark
                                                              : FontAwesomeIcons
                                                                  .hourglass,
                                          onTap: () {}),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Text(Methods.formatOrderNum(
                                            orders[index].orderNum)),
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
                                      Text(
                                        Methods.formatTime(
                                            orders[index].time, 'en'),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        leading: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: item.imgUrl,
                                              errorWidget:
                                                  (context, url, error) {
                                                return Image.asset(
                                                    'assets/imgs/logo_dark.png');
                                              },
                                            ),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, top: 8),
                                  child: Text(
                                      'قيمة الطلب: ${Methods.formatPrice(orders[index].totalPrice)} د.ع'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8, bottom: 8),
                                  child: Text(
                                      'كلفة التوصيل: ${Methods.formatPrice(orders[index].deliveryPrice)} د.ع'),
                                ),
                                orders[index].walletPay
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.amber[700],
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                    padding: EdgeInsets.only(
                                                        right: 8),
                                                    child: Text(
                                                        'الدفع عن طريق المحفظة',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
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
                                                    padding: EdgeInsets.only(
                                                        right: 8),
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
                                      )
                              ],
                            )
                          ],
                        )),
                  );
                },
              );
            },
          );
  }
}
