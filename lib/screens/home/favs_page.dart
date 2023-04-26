import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mars/models/fav.dart';
import 'package:mars/models/item.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/firestore/users.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/providers.dart';

class FavsPage extends ConsumerStatefulWidget {
  const FavsPage({Key? key}) : super(key: key);

  @override
  _FavsPageState createState() => _FavsPageState();
}

class _FavsPageState extends ConsumerState<FavsPage> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = ref.watch(userProvider);
    if (user == null) {
      return Container();
    }
    return StreamBuilder<List<Fav>>(
        stream: locator.get<Users>().watchUserFavs(user.uid),
        builder: (BuildContext context, AsyncSnapshot<List<Fav>> snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Fav>? favs = snapshot.data;

          if (favs == null || favs.isEmpty) {
            return Center(
              child: Text(
                'لا توجد منتجات مفضلة',
                style: GoogleFonts.tajawal(),
              ),
            );
          }

          return ListView.builder(
            itemCount: favs.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  Item item =
                      await locator.get<Items>().getItem(favs[index].fid);
                  Navigator.pushNamed(context, '/itemPage',
                      arguments: {'item': item});
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Hero(
                          tag: favs[index].fid,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: favs[index].imgUrl + '.gif',
                              errorWidget: (context, url, error) {
                                return CircleAvatar(
                                  child:
                                      Image.asset('assets/imgs/logo_dark.png'),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          favs[index].name,
                          style: GoogleFonts.tajawal(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          favs[index].category,
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          locator
                              .get<Users>()
                              .removeFav(user.uid, favs[index].fid);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  ],
                ),
              );
            },
          );
        });
  }
}
