import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mars/models/item.dart';
import 'package:mars/services/firestore/items.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/providers.dart';

class LinkService {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  AndroidParameters androidParameters = const AndroidParameters(
    packageName: "com.alhadidy.bigmap",
  );

  IOSParameters iosParameters = const IOSParameters(
    bundleId: "com.alhadidy.mars",
    appStoreId: '898898',
  );
  String uriPrefix = 'https://mars.page.link/';
  String deepLink = 'https://mars-coffee.web.app/';
  static const String imgUrl =
      "https://firebasestorage.googleapis.com/v0/b/mars-coffee.appspot.com/o/public%2Flogo.jpg?alt=media&token=f1596111-7f2f-4141-a633-03f77f8cb693";

  Future<String> createDynamicLink(
      {required String title,
      required String desc,
      required String page,
      required String pageId,
      String imgUrl = imgUrl}) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse(deepLink + page + '?' + pageId),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title, imageUrl: Uri.parse(imgUrl), description: desc),
      androidParameters: androidParameters,
      iosParameters: iosParameters,
    );
    var dynamicUrl = await dynamicLinks.buildShortLink(parameters);

    return dynamicUrl.shortUrl.toString();
  }

  static initDynamicLinks(WidgetRef ref) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    print(data);
    // https://mars.page.link/Kz3a
    if (data != null) {
      final Uri deepLink = data.link;

      switch (deepLink.path) {
        case '/item':
          LinkService().itemLink(ref, deepLink);
          break;
        case '/invite':
          LinkService().inviteLink(ref, deepLink);
          break;
      }
    }

    dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink.link;
      print(deepLink.path);

      switch (deepLink.path) {
        case '/item':
          LinkService().itemLink(ref, deepLink);
          break;
        case '/invite':
          LinkService().inviteLink(ref, deepLink);
          break;
      }
    }).onError((error) {
      debugPrint('onLinkError');
      debugPrint(error);
    });
  }

  Future itemLink(WidgetRef ref, Uri deepLink) async {
    Item? item = await locator.get<Items>().getItem(deepLink.query);

    ref
        .read(linkProvider.notifier)
        .newLink(page: '/itemPage', arg: {'item': item});
  }

  Future inviteLink(WidgetRef ref, Uri deepLink) async {
    ref
        .read(linkProvider.notifier)
        .newLink(page: '/invite', arg: deepLink.query);
  }
}
