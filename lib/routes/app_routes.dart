import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_flutter/features/auth/pages/login_page.dart';
import 'package:inventory_flutter/features/auth/pages/register_page.dart';
import 'package:inventory_flutter/features/home/pages/home_page.dart';
import 'package:inventory_flutter/features/inventory/pages/add_inventory_page.dart';
import 'package:inventory_flutter/features/inventory/pages/detail_inventory_page.dart';
import 'package:inventory_flutter/features/inventory/pages/inventory_page.dart';
import 'package:inventory_flutter/features/main_layout/main_layout.dart';
import 'package:inventory_flutter/features/profile/pages/profile_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';

  static const inventory = '/inventory';
  static const addInventory = '/add-inventory';
  static const detailInventory = '/detail-inventory';

  static const home = '/home';
  static const profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case main:
        return MaterialPageRoute(builder: (_) => const MainLayout());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryPage());
      case addInventory:
        return MaterialPageRoute(builder: (_) => const AddInventoryPage());
      case detailInventory:
        final doc = settings.arguments as DocumentSnapshot;
        return MaterialPageRoute(builder: (_) => DetailInventoryPage(doc: doc));
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }
}
