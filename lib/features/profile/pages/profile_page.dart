import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/features/auth/controller/auth_controller.dart';
import 'package:inventory_flutter/routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final email = authController.firebaseUser.value?.email ?? "-";

          return Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: AppColors.textDark),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                ),
                onPressed: () async {
                  await authController.logout();
                  Get.offAllNamed(AppRoutes.login);
                },
                child: const Text("Logout"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
