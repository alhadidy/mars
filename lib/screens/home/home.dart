import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mars/models/link.dart';
import 'package:mars/models/user.dart';
import 'package:mars/screens/home/widgets/basket_button.dart';
import 'package:mars/screens/home/widgets/categories_sliver.dart';
import 'package:mars/screens/home/widgets/items_sliver.dart';
import 'package:mars/screens/home/widgets/promo_sliver.dart';
import 'package:mars/screens/home/widgets/stores_sliver.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
  }

  handleLinks() {
    Link link = ref.watch(linkProvider);

    if (link.page != null) {
      if (link.page == '/invite') {
        ref.read(linkProvider.notifier).resetLink();
      } else {
        Navigator.pushNamed(context, link.page ?? '', arguments: link.arg);
        ref.read(linkProvider.notifier).resetLink();
      }
    } else {
      Methods.showSnackHome(title: link.title, tip: link.tip, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = ref.watch(userProvider);
    final Role role = ref.watch(rolesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mars Coffee House'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
                child: CachedNetworkImage(
              height: 10,
              width: 10,
              fit: BoxFit.cover,
              imageUrl: user!.photoUrl,
              errorWidget: ((context, url, error) {
                return ClipOval(
                    child: Container(
                  color: Colors.amberAccent,
                ));
              }),
            )),
          ),
        ),
        actions: [
          const BasketButton(),
          role.role != Roles.user
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin');
                  },
                  icon: const FaIcon(FontAwesomeIcons.gear))
              : Container()
        ],
      ),
      body: const CustomScrollView(
        slivers: [
          PromotionSliver(),
          CategoriesSliver(),
          StoresSliver(),
          ItemsSliver(),
        ],
      ),
    );
  }
}
