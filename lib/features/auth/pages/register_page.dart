import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/core/widgets/custom_button.dart';
import 'package:inventory_flutter/core/widgets/custom_textfield.dart';
import 'package:inventory_flutter/features/auth/controller/auth_controller.dart';
import 'package:inventory_flutter/routes/app_routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailC = TextEditingController();
    final passC = TextEditingController();
    final confirmC = TextEditingController();
    final authController = Get.find<AuthController>();

    void _doRegister() {
      if (passC.text != confirmC.text) {
        Get.snackbar('Error', 'Password and confirmation do not match');
        return;
      }
      authController.register(emailC.text.trim(), passC.text.trim()).then((_) {
        if (authController.currentUser != null) {
          Get.offAllNamed(AppRoutes.main);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Register")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(controller: emailC, label: "Email"),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passC,
                label: "Password",
                obscure: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: confirmC,
                label: "Confirm Password",
                obscure: true,
              ),
              const SizedBox(height: 24),
              Obx(() {
                return authController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: "Register", onPressed: _doRegister);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
