import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('طلباتي'),
      ),
      body: user == null
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

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('لا توجد طلبات حالية'),
                  );
                }

                List<Order> orders = snapshot.data;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Card(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(Methods.formatOrderNum(
                                          orders[index].orderNum)),
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
                                )
                              ],
                            ),
                          ),
                          const Divider(),
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
                                        badgeColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        badgeContent: Text(
                                          orders[index]
                                              .items[i]
                                              .quantity
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'قيمة الطلب: ${Methods.formatPrice(orders[index].totalPrice)} د.ع'),
                                Text(
                                    'كلفة التوصيل: ${Methods.formatPrice(orders[index].deliveryPrice)} د.ع'),
                                Container(
                                  height: 2,
                                  width: 100,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                Text(
                                    'المجموع:  ${Methods.formatPrice(orders[index].totalPrice + orders[index].deliveryPrice)} د.ع'),
                              ],
                            ),
                          )
                        ],
                      )),
                    );
                  },
                );
              },
            ),
    );
  }
}
