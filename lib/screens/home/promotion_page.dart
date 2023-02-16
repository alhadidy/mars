import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/locator.dart';

class PromoPage extends ConsumerStatefulWidget {
  final Promo promo;
  const PromoPage({super.key, required this.promo});
  @override
  PromoPageState createState() => PromoPageState();
}

class PromoPageState extends ConsumerState<PromoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider);
    // final role = ref.watch(rolesProvider).role;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.promo.name,
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
          actions: [
            // role == Roles.admin
            //     ? IconButton(
            //         tooltip: 'تعديل',
            //         icon: const FaIcon(
            //           FontAwesomeIcons.pencilRuler,
            //           size: 20,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           Navigator.of(context).pushNamed('/promotionDetails',
            //               arguments: widget.promo);
            //         },
            //       )
            //     : Container(),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CachedNetworkImage(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    imageUrl: widget.promo.imgUrl,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 18, left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 58,
                          child: Text(
                            widget.promo.title,
                            textDirection: TextDirection.rtl,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          child: FaIcon(
                            FontAwesomeIcons.fire,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 12),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.promo.subtitle,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontSize: 14,
                              height: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.promo.body,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const Divider(),
                  widget.promo.subbody.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    widget.promo.subbody,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        height: 1,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: FaIcon(
                                  FontAwesomeIcons.infoCircle,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                  const Divider(),
                  widget.promo.actionType != 'none'
                      ? const SizedBox(
                          height: 75,
                        )
                      : Container(),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: actionBuilder(widget.promo.actionType)),
          ],
        ));
  }

  Widget actionBuilder(ActionType actionType) {
    switch (actionType) {
      case ActionType.itemPage:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  Item item =
                      await locator.get<Items>().getItem(widget.promo.itemId);
                  Navigator.of(context).pushNamed('/itemPage', arguments: item);
                },
                child: Text('المزيد من التفاصيل',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                        color: Colors.white,
                        height: 2,
                        fontWeight: FontWeight.bold)
                    // style: TextStyle(color: Colors.white),
                    ),
              )),
        );

      default:
        return Container();
    }
  }
}
