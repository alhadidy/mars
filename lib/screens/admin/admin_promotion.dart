import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/promo.dart';
import 'package:mars/services/firestore/promos.dart';
import 'package:mars/services/locator.dart';

class AdminPromotion extends StatefulWidget {
  const AdminPromotion({Key? key}) : super(key: key);

  @override
  State<AdminPromotion> createState() => _AdminPromotionState();
}

class _AdminPromotionState extends State<AdminPromotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/promotionEditor',
                    arguments: {'promo': null});
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: StreamBuilder(
        stream: locator.get<Promos>().getPromos(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          List<Promo> promos = snapshot.data;
          return ListView.builder(
            itemCount: promos.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/promotionEditor',
                      arguments: {'promo': promos[index]});
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SizedBox(
                    height: 300,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CachedNetworkImage(
                                height: 225,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                                imageUrl: promos[index].imgUrl),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                promos[index].active
                                    ? const FaIcon(
                                        FontAwesomeIcons.solidEye,
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.solidEyeSlash,
                                      ),
                                Text(
                                  promos[index].name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
