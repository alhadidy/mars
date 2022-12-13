import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/size.dart';
import 'package:mars/screens/home/widgets/basket_button.dart';
import 'package:mars/screens/home/widgets/quantity_buttons.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class ItemPage extends ConsumerStatefulWidget {
  final Item item;
  const ItemPage({Key? key, required this.item}) : super(key: key);

  @override
  ConsumerState<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends ConsumerState<ItemPage> {
  Size? size;

  @override
  void initState() {
    if (widget.item.sizes.length == 1) {
      size = widget.item.sizes[0];
    }
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
            const Text('الحجم'),
            Wrap(
                alignment: WrapAlignment.center,
                children: widget.item.sizes.map((s) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          size = s;
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 75,
                        decoration: BoxDecoration(
                            color: size == s
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.7)
                                : Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: FaIcon(FontAwesomeIcons.mugSaucer),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(s.name),
                            ),
                          ],
                        )),
                      ),
                    ),
                  );
                }).toList()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                size == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              '${Methods.roundPriceWithDiscountIQD(price: size!.price, discount: size!.discount).toString()} د.ع',
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  height: 2,
                                  color: Colors.white),
                            ),
                            size!.discount > 0
                                ? Text(
                                    '${size!.price.toString()} د.ع',
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        height: 1,
                                        color: Colors.white),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                size == null
                    ? Container()
                    : StreamBuilder(
                        stream: db.localOrdersDao.searchInOrder(
                            '${widget.item.name} - ${size!.name}'),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: QuantityButtons(snapshot.data),
                            ));
                          } else {
                            return Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                  onPressed: size == null
                                      ? null
                                      : () {
                                          db.localOrdersDao.insertInTheOrder(
                                              LocalOrder(
                                                  id: null,
                                                  fid: widget.item.fid,
                                                  name:
                                                      '${widget.item.name} - ${size!.name}',
                                                  imgurl: widget.item.imgUrl,
                                                  quantity: 1,
                                                  price: size!.price,
                                                  discount: size!.discount));
                                        },
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text('اضافة الى السلة'),
                                  )),
                            ));
                          }
                        },
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
