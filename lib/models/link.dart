import 'package:flutter_riverpod/flutter_riverpod.dart';

class Link {
  final String? page;
  final dynamic arg;
  final String title;
  final String tip;
  Link({this.page, this.arg, this.title = '', this.tip = ''});
}

class LinkManager extends StateNotifier<Link> {
  LinkManager() : super(Link());

  void newLink(
      {required String page,
      dynamic arg,
      String title = '',
      String tip = ''}) async {
    state = Link(page: page, arg: arg, title: title, tip: tip);
  }

  void resetLink(
      {String page = '',
      dynamic arg,
      String title = '',
      String tip = ''}) async {
    state = Link();
  }
}
