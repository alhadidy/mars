import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/quantity_buttons.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:badges/badges.dart' as badge;

class Basket extends ConsumerStatefulWidget {
  const Basket({super.key});

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends ConsumerState<Basket>
    with SingleTickerProviderStateMixin {
  PanelController controller = PanelController();
  ValueNotifier<bool> showTrashButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase db = ref.watch(dbProvider);
    SSetting? settings = ref.watch(shopSettingsProvider);
    UserModel? user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'سلة المشتريات',
            style: GoogleFonts.tajawal(),
            textAlign: TextAlign.center,
          ),
          actions: [
            ValueListenableBuilder(
              valueListenable: showTrashButton,
              builder: (BuildContext context, dynamic value, child) {
                return value
                    ? IconButton(
                        onPressed: () {
                          db.localOrdersDao.clearTheOrder();
                        },
                        icon: const FaIcon(FontAwesomeIcons.solidTrashCan))
                    : Container();
              },
            )
          ],
        ),
        body: StreamBuilder<List<LocalOrder>>(
          stream: db.localOrdersDao.watchTheOrder(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.length == 0) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showTrashButton.value = false;
              });

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                      ),
                      child: Image.asset(
                        'assets/imgs/cups.png',
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text('سلة المشتريات فارغة حالياً',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }

            List<LocalOrder> order = snapshot.data;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showTrashButton.value = true;
            });

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.black54,
                      );
                    },
                    itemCount: order.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == order.length) {
                        return SizedBox(
                          height: 200,
                          child: StreamBuilder(
                            stream: db.localOrdersDao.getOrderTotal(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              int total = snapshot.data;
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${Methods.formatPrice(total)} د.ع ',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Expanded(
                                                  child: DottedLine(
                                                lineThickness: 2,
                                                dashRadius: 5,
                                                dashLength: 2,
                                              )),
                                              const Text(
                                                ' قيمة الطلب',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${Methods.formatPrice(settings == null || settings.deliveryPrice == 0 ? 0 : settings.deliveryPrice)} د.ع ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Expanded(
                                                    child: DottedLine(
                                                  lineThickness: 2,
                                                  dashRadius: 5,
                                                  dashLength: 2,
                                                )),
                                                const Text(
                                                  ' اجور التوصيل',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${Methods.formatPrice(settings == null || settings.deliveryPrice == 0 ? total : total + settings.deliveryPrice)} د.ع ',
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Expanded(
                                                  child: DottedLine(
                                                lineThickness: 2,
                                                dashRadius: 5,
                                                dashLength: 2,
                                              )),
                                              const Text(
                                                ' المجموع',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      String? details = order[index].details;
                      Map detailsMap = {};
                      List<dynamic> addons = [];
                      if (details != null) {
                        detailsMap = json.decode(details);
                        if (detailsMap.containsKey('addons')) {
                          addons = detailsMap['addons'];
                        }
                      }

                      return Padding(
                        padding: index + 1 == order.length
                            ? const EdgeInsets.only(bottom: 16)
                            : const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    order[index].name,
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                    '${Methods.formatPrice((Methods.roundPriceWithDiscountIQD(price: order[index].price, discount: order[index].discount) * order[index].quantity))} د.ع')
                              ],
                            ),
                          ),
                          leading: badge.Badge(
                            badgeContent: Text(
                              (index + 1).toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            animationType: badge.BadgeAnimationType.scale,
                            position: badge.BadgePosition.topStart(),
                            badgeColor: Theme.of(context).colorScheme.secondary,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: order[index].imgurl,
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                      'assets/imgs/logo_dark.png');
                                },
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addons.isEmpty
                                  ? Container()
                                  : const Text(
                                      ':الإضافات',
                                      textDirection: TextDirection.ltr,
                                    ),
                              Column(
                                children: addons
                                    .map((e) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(e['name']),
                                            Text(
                                              '${Methods.formatPrice(e['price'])} د.ع',
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                              QuantityButtons(order[index])
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: user.isAnon
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'تسجيل الدخول',
                                style: GoogleFonts.tajawal(height: 2),
                              ),
                            ))
                        : StreamBuilder(
                            stream: db.localOrdersDao.getOrderTotal(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              int total = snapshot.data;
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/completeOrder');
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'تأكيد الطلب ${Methods.formatPrice(settings == null || settings.deliveryPrice == 0 ? total : total + settings.deliveryPrice)} د.ع ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ));
                            }),
                  )
                ],
              ),
            );
          },
        ));
  }
}
