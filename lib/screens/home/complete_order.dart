import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/models/order_item.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/models/store.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_data.dart';
import 'package:mars/services/firestore/orders.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class CompleteOrder extends ConsumerStatefulWidget {
  const CompleteOrder({Key? key}) : super(key: key);

  @override
  ConsumerState<CompleteOrder> createState() => _CompleteOrderState();
}

class _CompleteOrderState extends ConsumerState<CompleteOrder> {
  Store? storeValue;
  String locationText = 'اضغط هنا من اجل تحديد موقع التوصيل';
  LatLng? location;
  bool dataCompleted = false;

  bool walletPay = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    UserModel? user = ref.read(userProvider);
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone;
    }

    UserData userData = ref.read(userDataProvider);

    addressController.text = userData.info?.address ?? '';

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase db = ref.watch(dbProvider);
    UserModel? user = ref.watch(userProvider);
    UserData userData = ref.watch(userDataProvider);
    SSetting? settings = ref.watch(shopSettingsProvider);

    if (user == null || settings == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'اكمال الطلب',
            style: GoogleFonts.tajawal(),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('حدثت مشكلة اثناء تأكيد الطلب'),
        ),
      );
    }

    if (location != null &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      dataCompleted = true;
    } else {
      dataCompleted = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'اكمال الطلب',
          style: GoogleFonts.tajawal(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('الاسم'),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      autofocus: true,
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        label: const Text('رقم الهاتف'),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('العنوان'),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      controller: addressController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(locationText),
                    leading: location == null
                        ? const FaIcon(FontAwesomeIcons.handPointer)
                        : const FaIcon(FontAwesomeIcons.checkDouble),
                    onTap: () {
                      Methods.showLoaderDialog(context);
                      Methods.determinePosition().then((value) {
                        Navigator.pop(context);
                        setState(() {
                          location = value;
                          locationText = 'تم تحديد موقع التوصيل';
                        });
                      }).catchError((err) {
                        Navigator.pop(context);
                        setState(() {
                          locationText = err;
                        });
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 75),
                    child: userData.cash != 0
                        ? StreamBuilder(
                            stream: db.localOrdersDao.watchOrderTotalFuture(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Container();
                              }

                              if (snapshot.data > userData.cash) {
                                return Container();
                              }
                              return ListTile(
                                title: const Text('الدفع عن طريق المحفظة'),
                                subtitle:  Row(
                                  children: const [
                                    FaIcon(
                                      FontAwesomeIcons.solidStar,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '+25 نقطة',
                                      ),
                                    ),
                                  ],
                                ),
                                leading: Checkbox(
                                  value: walletPay,
                                  onChanged: (value) {
                                    setState(() {
                                      walletPay = value ?? false;
                                    });
                                  },
                                ),
                                trailing: Text(
                                    '${Methods.formatPrice(userData.cash)} د.ع'),
                                onTap: () {
                                  setState(() {
                                    walletPay = !walletPay;
                                  });
                                },
                              );
                            },
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      onPressed: dataCompleted
                          ? () async {
                              int total =
                                  await db.localOrdersDao.getOrderTotalFuture();
                              List<LocalOrder> order =
                                  await db.localOrdersDao.getTheOrder();

                              Methods.showLoaderDialog(context);
                              await locator.get<Orders>().addOrder(
                                  walletPay: walletPay,
                                  userId: user.uid,
                                  userName: nameController.text,
                                  location: location == null
                                      ? const GeoPoint(0, 0)
                                      : GeoPoint(location!.latitude,
                                          location!.longitude),
                                  storeId:
                                      storeValue == null ? '' : storeValue!.fid,
                                  storeName: storeValue == null
                                      ? ''
                                      : storeValue!.name,
                                  storeLocation: storeValue == null
                                      ? const GeoPoint(0, 0)
                                      : storeValue!.location,
                                  address: addressController.text,
                                  city: 'كركوك',
                                  phone: phoneController.text,
                                  items: order.map((orderItem) {
                                    List addons = [];
                                    if (orderItem.details != null) {
                                      Map details =
                                          json.decode(orderItem.details!);
                                      if (details.containsKey('addons')) {
                                        addons = details['addons'];
                                      }
                                    }

                                    return OrderItem(
                                        fid: orderItem.fid,
                                        name: orderItem.name,
                                        imgUrl: orderItem.imgurl,
                                        price: orderItem.price,
                                        discount: orderItem.discount,
                                        addons: addons,
                                        quantity: orderItem.quantity);
                                  }).toList(),
                                  confirmed: false,
                                  delivered: false,
                                  canceled: false,
                                  delivering: false,
                                  deliverBy: '',
                                  deliveryPrice: settings.deliveryPrice,
                                  totalPrice: total);

                              await db.localOrdersDao.clearTheOrder();
                              Navigator.popUntil(context, ((route) {
                                return route.isFirst;
                              }));
                            }
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'اطلب',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
