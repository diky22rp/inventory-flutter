import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_flutter/features/auth/pages/login_page.dart';
import 'package:inventory_flutter/features/auth/pages/register_page.dart';
import 'package:inventory_flutter/features/main_layout/main_layout.dart';
import 'package:inventory_flutter/features/home/pages/home_page.dart';
import 'package:inventory_flutter/features/profile/pages/profile_page.dart';
import 'package:inventory_flutter/features/inventory/pages/inventory_page.dart';
import 'package:inventory_flutter/features/inventory/pages/add_inventory_page.dart';
import 'package:inventory_flutter/features/inventory/pages/detail_inventory_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';

  static const inventory = '/inventory';
  static const addInventory = '/add-inventory';
  static const detailInventory = '/detail-inventory';

  static const home = '/home';
  static const profile = '/profile';

  static final routes = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: register, page: () => RegisterPage()),
    GetPage(name: main, page: () => MainLayout()),
    GetPage(name: inventory, page: () => InventoryPage()),
    GetPage(name: addInventory, page: () => AddInventoryPage()),
    GetPage(
      name: detailInventory,
      page: () {
        // argument diambil dari Get.arguments
        final doc = Get.arguments as DocumentSnapshot;
        return DetailInventoryPage(doc: doc);
      },
    ),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: profile, page: () => ProfilePage()),
  ];
}
