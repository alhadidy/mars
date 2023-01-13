import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/models/item.dart';
import 'package:mars/screens/home/widgets/basket_button.dart';
import 'package:mars/screens/home/widgets/round_icon_button.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class ItemPage extends ConsumerStatefulWidget {
  final Item item;
  const ItemPage({Key? key, required this.item}) : super(key: key);

  @override
  ConsumerState<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends ConsumerState<ItemPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = ref.watch(dbProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.item.name),
        actions: const [BasketButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              imageUrl: widget.item.imgUrl,
              errorWidget: ((context, url, error) {
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                );
              }),
              placeholder: (context, url) {
                return Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                );
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.item.name,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const Divider(
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.item.desc,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Text('الرجاء اختيار الحجم'),
            Wrap(
                alignment: WrapAlignment.center,
                children: widget.item.sizes.map((s) {
                  return StreamBuilder(
                    stream: db.localOrdersDao
                        .searchInOrder('${widget.item.name} - ${s.name}'),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      LocalOrder? order = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Badge(
                              badgeColor:
                                  Theme.of(context).colorScheme.secondary,
                              animationDuration:
                                  const Duration(milliseconds: 100),
                              animationType: BadgeAnimationType.scale,
                              showBadge: order != null,
                              badgeContent: order == null
                                  ? Container()
                                  : Text(order.quantity.toString()),
                              child: GestureDetector(
                                onTap: (() async {
                                  if (order != null && order.quantity > 0) {
                                    await db.localOrdersDao
                                        .increaseQuantity(order);
                                  } else {
                                    await db.localOrdersDao.insertInTheOrder(
                                        LocalOrder(
                                            id: null,
                                            fid: widget.item.fid,
                                            name:
                                                '${widget.item.name} - ${s.name}',
                                            imgurl: widget.item.imgUrl,
                                            quantity: 1,
                                            price: s.price,
                                            discount: s.discount));
                                  }
                                }),
                                child: Container(
                                  width: 100,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child:
                                            FaIcon(FontAwesomeIcons.mugSaucer),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(s.name),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          '${Methods.formatPrice(s.price)} د.ع',
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            order == null
                                ? Container(
                                    width: 0,
                                  )
                                : SizedBox(
                                    width: 20,
                                    height: 116,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: RoundIconButton(
                                          color: Colors.red,
                                          icon: FontAwesomeIcons.minus,
                                          onTap: () {
                                            db.localOrdersDao
                                                .decreaseQuantity(order);
                                          }),
                                    ),
                                  )
                          ],
                        ),
                      );
                    },
                  );
                }).toList()),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
