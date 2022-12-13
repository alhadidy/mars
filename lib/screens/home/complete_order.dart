import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/models/order_item.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/models/store.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/firestore/orders.dart';
import 'package:mars/services/firestore/stores.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class CompleteOrder extends ConsumerStatefulWidget {
  const CompleteOrder({Key? key}) : super(key: key);

  @override
  ConsumerState<CompleteOrder> createState() => _CompleteOrderState();
}

class _CompleteOrderState extends ConsumerState<CompleteOrder> {
  bool inStore = false;
  Store? storeValue;
  String locationText = 'اضغط هنا من اجل تحديد موقع التوصيل';
  LatLng? location;
  bool dataCompleted = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  late Future getStores;

  @override
  void initState() {
    getStores = locator.get<Stores>().getStores();
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
    SSetting? settings = ref.watch(shopSettingsProvider);

    if (user == null || settings == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('اكمال الطلب'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('حدثت مشكلة اثناء تأكيد الطلب'),
        ),
      );
    }
    if (inStore) {
      if (storeValue != null &&
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty) {
        dataCompleted = true;
      } else {
        dataCompleted = false;
      }
    } else {
      if (location != null &&
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          addressController.text.isNotEmpty) {
        dataCompleted = true;
      } else {
        dataCompleted = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('اكمال الطلب'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: RadioListTile(
                            title: const Text('توصيل'),
                            value: false,
                            groupValue: inStore,
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  inStore = true;
                                } else {
                                  inStore = false;
                                }
                              });
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: RadioListTile(
                            title: const Text('داخل المحل'),
                            value: true,
                            groupValue: inStore,
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  inStore = true;
                                } else {
                                  inStore = false;
                                }
                              });
                            }),
                      ),
                    ],
                  ),
                  inStore
                      ? FutureBuilder(
                          future: getStores,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            if (snapshot.data == null) {
                              return Container();
                            }
                            List<Store> stores = snapshot.data;
                            return Column(
                              children: stores.map((store) {
                                return RadioListTile(
                                    groupValue: storeValue,
                                    title: Text(store.name),
                                    subtitle: Text(store.address),
                                    value: store,
                                    onChanged: (value) {
                                      setState(() {
                                        storeValue = value;
                                      });
                                    });
                              }).toList(),
                            );
                          },
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(label: Text('الاسم')),
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration:
                          const InputDecoration(label: Text('رقم الهاتف')),
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  inStore
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            decoration:
                                const InputDecoration(label: Text('العنوان')),
                            controller: addressController,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                  inStore
                      ? Container()
                      : ListTile(
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
                      onPressed: dataCompleted
                          ? () async {
                              int total =
                                  await db.localOrdersDao.getOrderTotalFuture();
                              List<LocalOrder> order =
                                  await db.localOrdersDao.getTheOrder();
                              Methods.showLoaderDialog(context);
                              await locator.get<Orders>().addOrder(
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
                                    return OrderItem(
                                        fid: orderItem.fid,
                                        name: orderItem.name,
                                        imgUrl: orderItem.imgurl,
                                        price: orderItem.price,
                                        discount: orderItem.discount,
                                        quantity: orderItem.quantity);
                                  }).toList(),
                                  confirmed: false,
                                  delivered: false,
                                  canceled: false,
                                  delivering: false,
                                  inStore: inStore,
                                  deliverBy: '',
                                  deliveryPrice:
                                      inStore ? 0 : settings.deliveryPrice,
                                  totalPrice: total);

                              await db.localOrdersDao.clearTheOrder();
                              Navigator.popUntil(context, ((route) {
                                return route.isFirst;
                              }));
                            }
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('اطلب'),
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
