import 'package:flutter/material.dart';
import 'package:mars/screens/admin/admin.dart';
import 'package:mars/screens/admin/admin_addons.dart';
import 'package:mars/screens/admin/admin_addons_editor.dart';
import 'package:mars/screens/admin/admin_categories.dart';
import 'package:mars/screens/admin/admin_editors.dart';
import 'package:mars/screens/admin/admin_items.dart';
import 'package:mars/screens/admin/admin_orders.dart';
import 'package:mars/screens/admin/admin_payments.dart';
import 'package:mars/screens/admin/admin_points.dart';
import 'package:mars/screens/admin/admin_promotion.dart';
import 'package:mars/screens/admin/admin_settings.dart';
import 'package:mars/screens/admin/admin_sizes.dart';
import 'package:mars/screens/admin/admin_stores.dart';
import 'package:mars/screens/admin/admin_support.dart';
import 'package:mars/screens/admin/category_editor.dart';
import 'package:mars/screens/admin/generated_cards.dart';
import 'package:mars/screens/admin/item_editor.dart';
import 'package:mars/screens/admin/promotion_editor.dart';
import 'package:mars/screens/admin/reward_points.dart';
import 'package:mars/screens/home/basket.dart';
import 'package:mars/screens/home/calenadar_page.dart';
import 'package:mars/screens/home/category_page.dart';
import 'package:mars/screens/home/complete_order.dart';
import 'package:mars/screens/home/item_page.dart';
import 'package:mars/screens/home/my_orders.dart';
import 'package:mars/screens/home/profile.dart';
import 'package:mars/screens/home/promotion_page.dart';
import 'package:mars/screens/home/stores_page.dart';
import 'package:mars/screens/home/support_page.dart';
import 'package:mars/screens/home/wallet.dart';

class RoutesHelper {
  static Route<dynamic> goToRoute(RouteSettings settings) {
    Map<String, dynamic> args = {};
    if (settings.arguments != null) {
      args = settings.arguments as Map<String, dynamic>;
    }

    switch (settings.name) {
      case '/admin':
        return MaterialPageRoute(builder: (_) {
          return const Admin();
        });

      case '/adminItems':
        return MaterialPageRoute(builder: (_) {
          return const AdminItems();
        });
      case '/adminAddons':
        return MaterialPageRoute(builder: (_) {
          return const AdminAddons();
        });
      case '/adminAddonsEditor':
        return MaterialPageRoute(builder: (_) {
          return AdminAddonsEditor(
            addon: Map<String, dynamic>.from(args)['addon'],
          );
        });
      case '/adminSizes':
        return MaterialPageRoute(builder: (_) {
          return const AdminSizes();
        });
      case '/itemEditor':
        return MaterialPageRoute(builder: (_) {
          return ItemEditor(
            item: Map<String, dynamic>.from(args)['item'],
          );
        });
      case '/itemPage':
        return MaterialPageRoute(builder: (_) {
          return ItemPage(
            item: Map<String, dynamic>.from(args)['item'],
          );
        });
      case '/adminEditors':
        return MaterialPageRoute(builder: (_) {
          return const AdminEditors();
        });
      case '/adminStores':
        return MaterialPageRoute(builder: (_) {
          return const AdminStores();
        });
      case '/adminSupport':
        return MaterialPageRoute(builder: (_) {
          return const AdminSupport();
        });

      case '/adminCategories':
        return MaterialPageRoute(builder: (_) {
          return const AdminCategories();
        });
      case '/categoryEditor':
        return MaterialPageRoute(builder: (_) {
          return CategoryEditor(
            category: Map<String, dynamic>.from(args)['category'],
          );
        });
      case '/categoryPage':
        return MaterialPageRoute(builder: (_) {
          return CategoryPage(
            category: Map<String, dynamic>.from(args)['category'],
          );
        });
      case '/adminPromotion':
        return MaterialPageRoute(builder: (_) {
          return const AdminPromotion();
        });
      case '/promotionEditor':
        return MaterialPageRoute(builder: (_) {
          return PromotionEditor(
            promo: Map<String, dynamic>.from(args)['promo'],
          );
        });
      case '/promotionPage':
        return MaterialPageRoute(builder: (_) {
          return PromoPage(
            promo: Map<String, dynamic>.from(args)['promo'],
          );
        });
      case '/adminOrders':
        return MaterialPageRoute(builder: (_) {
          return const AdminOrders();
        });
      case '/profile':
        return MaterialPageRoute(builder: (_) {
          return const Profile();
        });
      case '/wallet':
        return MaterialPageRoute(builder: (_) {
          return const Wallet();
        });
      case '/basket':
        return MaterialPageRoute(builder: (_) {
          return const Basket();
        });
      case '/completeOrder':
        return MaterialPageRoute(builder: (_) {
          return const CompleteOrder();
        });
      case '/adminPoints':
        return MaterialPageRoute(builder: (_) {
          return const AdminPoints();
        });
      case '/adminPayments':
        return MaterialPageRoute(builder: (_) {
          return const AdminPayments();
        });
      case '/adminSettings':
        return MaterialPageRoute(builder: (_) {
          return const AdminSettings();
        });
      case '/generatedCards':
        return MaterialPageRoute(builder: (_) {
          return const GeneratedCards();
        });
      case '/rewardPoints':
        return MaterialPageRoute(builder: (_) {
          return const RewardPoints();
        });
      case '/stores':
        return MaterialPageRoute(builder: (_) {
          return const StoresPage();
        });
      case '/myOrders':
        return MaterialPageRoute(builder: (_) {
          return const MyOrders();
        });
      case '/support':
        return MaterialPageRoute(builder: (_) {
          return const SupportPage();
        });
      case '/calendarPage':
        return MaterialPageRoute(builder: (_) {
          return const CalenadarPage();
        });

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('404')),
          );
        });
    }
  }
}
