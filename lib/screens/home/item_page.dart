import 'dart:convert';

import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/models/addon.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/cup_size.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/basket_button.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/firebase_links.dart';
import 'package:mars/services/firestore/users.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:share_plus/share_plus.dart';

class ItemPage extends ConsumerStatefulWidget {
  final Item item;
  const ItemPage({Key? key, required this.item}) : super(key: key);

  @override
  ConsumerState<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends ConsumerState<ItemPage> {
  CupSize? selectedSize;
  List<Addon> selectedAddons = [];
  @override
  void initState() {
    if (widget.item.sizes.isNotEmpty) {
      selectedSize = widget.item.sizes[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = ref.watch(dbProvider);
    final UserModel? user = ref.watch(userProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const FaIcon(FontAwesomeIcons.chevronLeft,
                color: Colors.black)),
        actions: [
          IconButton(
              onPressed: () async {
                Methods.showLoaderDialog(context);
                String url = await LinkService().createDynamicLink(
                    title: 'Mars Coffee House',
                    desc:
                        'اطلب ${widget.item.name} من كوفي مارس عن طريق الرابط التالي',
                    imgUrl: widget.item.imgUrl,
                    page: 'item',
                    pageId: widget.item.fid);
                Navigator.pop(context);

                try {
                  Share.share(url);
                } catch (e) {
                  print(e);
                }
              },
              icon: const FaIcon(
                FontAwesomeIcons.shareNodes,
                color: Colors.black54,
              )),
          StreamBuilder<dynamic>(
            stream:
                locator.get<Users>().watchUserFav(user.uid, widget.item.fid),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return IconButton(
                  onPressed: () {
                    snapshot.data == null
                        ? locator.get<Users>().addFav(user.uid, widget.item)
                        : locator
                            .get<Users>()
                            .removeFav(user.uid, widget.item.fid);
                  },
                  icon: FaIcon(
                    snapshot.data != null
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Theme.of(context).colorScheme.secondary,
                  ));
            },
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: widget.item.fid,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.cover,
                        imageUrl: widget.item.imgUrl,
                        errorWidget: ((context, url, error) {
                          return Container(
                            color: Theme.of(context).colorScheme.primary,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                          );
                        }),
                        placeholder: (context, url) {
                          return Container(
                            color: Theme.of(context).colorScheme.primary,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.width / 2,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            widget.item.name,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.item.category,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.tajawal(fontSize: 18, height: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'الأحجام المتوفرة',
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.tajawal(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      height: 4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  widget.item.sizes.isEmpty
                      ? Container(
                          height: 100,
                          margin: EdgeInsets.all(16),
                          color: Colors.grey[100],
                          child: const Center(
                            child: Text('هذا المنتج غير متوفر حاليا'),
                          ),
                        )
                      : Container(),
                  Wrap(
                      alignment: WrapAlignment.center,
                      children: widget.item.sizes.map((s) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            highlightColor: Colors.amber.withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            onTap: (() async {
                              setState(() {
                                selectedSize = s;
                              });
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: selectedSize?.name == s.name
                                            ? Colors.amber.withOpacity(0.3)
                                            : null,
                                        border: Border.all(
                                            width: 2,
                                            color: selectedSize?.name == s.name
                                                ? Colors.amber
                                                : Colors.transparent),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/imgs/cup.png',
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    s.name,
                                    style: GoogleFonts.tajawal(
                                        height: 2, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()),
                  widget.item.addons.isEmpty
                      ? Container()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              'إصنع مشروبك الخاص',
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )),
                  widget.item.addons.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Container(
                            height: 4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                          ),
                        ),
                  Column(
                    children: widget.item.addons.map((addon) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: CheckboxListTile(
                          value: selectedAddons.contains(addon),
                          onChanged: (value) {
                            setState(() {
                              if (!selectedAddons.contains(addon)) {
                                selectedAddons.add(addon);
                              } else {
                                selectedAddons.remove(addon);
                              }
                            });
                          },
                          title: Text(
                            addon.name,
                            style: GoogleFonts.tajawal(
                                fontWeight: FontWeight.bold),
                          ),
                          secondary: Text(
                            '${Methods.formatPrice(addon.price)} د.ع',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  widget.item.desc.isEmpty
                      ? Container()
                      : Container(
                          color: Theme.of(context).colorScheme.primary,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  widget.item.desc,
                                  textDirection: TextDirection.rtl,
                                  style: GoogleFonts.tajawal(
                                      color: Colors.white, height: 2),
                                ),
                              ),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Positioned(
                bottom: 8,
                right: 0,
                left: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.indigo[700],
                  radius: 28,
                  child: const BasketButton(),
                )),
            Positioned(
                bottom: 8,
                right: 8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[700],
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'إضافة الى السلة',
                      style: GoogleFonts.tajawal(
                          height: 2.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: selectedSize == null
                      ? null
                      : () async {
                          int price = selectedSize!.price;
                          Map details = {};
                          details['addons'] = selectedAddons.map((e) {
                            price += e.price;
                            return {'name': e.name, 'price': e.price};
                          }).toList();

                          LocalOrder? order = await db.localOrdersDao
                              .searchInOrderFuture(widget.item.name +
                                  ' - ' +
                                  selectedSize!.name);
                          // if (order == null) {
                          db.localOrdersDao.insertInTheOrder(LocalOrder(
                              details: json.encode(details),
                              fid: widget.item.fid,
                              name:
                                  widget.item.name + ' - ' + selectedSize!.name,
                              imgurl: widget.item.imgUrl,
                              quantity: 1,
                              price: price,
                              discount: selectedSize!.discount));
                          // }
                          // else {
                          //   db.localOrdersDao.increaseQuantity(order);
                          // }
                        },
                )),
          ],
        ),
      ),
    );
  }
}
