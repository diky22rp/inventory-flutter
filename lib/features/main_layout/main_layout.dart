import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/features/home/pages/home_page.dart';
import 'package:inventory_flutter/features/inventory/pages/inventory_page.dart';
import 'package:inventory_flutter/features/main_layout/main_layout_controller.dart';
import 'package:inventory_flutter/features/profile/pages/profile_page.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainLayoutController());

    final pages = [HomePage(), InventoryPage(), ProfilePage()];

    return Obx(() {
      return Scaffold(
        body: pages[controller.index.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.index.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: "Inventory",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      );
    });
  }
}
