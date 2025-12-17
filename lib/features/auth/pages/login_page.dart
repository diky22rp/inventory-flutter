import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/core/widgets/custom_button.dart';
import 'package:inventory_flutter/core/widgets/custom_textfield.dart';
import 'package:inventory_flutter/features/auth/controller/auth_controller.dart';
import 'package:inventory_flutter/features/auth/pages/register_page.dart';
import 'package:inventory_flutter/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailC = TextEditingController();
  final passC = TextEditingController();
  final authController = Get.find<AuthController>();

  void _doLogin() {
    final email = emailC.text.trim();
    final pass = passC.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      Get.snackbar('Error', 'Email and password cannot be empty');
      return;
    }

    authController.login(email, pass).then((_) {
      if (authController.currentUser != null) {
        Get.offAllNamed(AppRoutes.main);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Login to continue managing your inventory",
                style: TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),
              const SizedBox(height: 32),
              CustomTextField(controller: emailC, label: "Email"),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passC,
                label: "Password",
                obscure: true,
              ),
              const SizedBox(height: 24),
              Obx(() {
                return authController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: "Login", onPressed: _doLogin);
              }),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Get.to(() => const RegisterPage()),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
