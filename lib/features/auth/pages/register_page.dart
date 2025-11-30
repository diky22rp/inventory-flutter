import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/core/widgets/custom_button.dart';
import 'package:inventory_flutter/core/widgets/custom_textfield.dart';
import 'package:inventory_flutter/features/auth/controller/auth_controller.dart';
import 'package:inventory_flutter/features/main_layout/main_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();
  bool isLoading = false;
  String? errorText;

  Future<void> _doRegister() async {
    if (passC.text != confirmC.text) {
      setState(() {
        errorText = "Password and confirmation do not match.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      final user = await AuthController().register(
        emailC.text.trim(),
        passC.text.trim(),
      );
      if (!mounted) return;
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorText = e.message;
      });
    } catch (e) {
      setState(() {
        errorText = 'Register failed, please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 12),
              if (errorText != null)
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(text: "Register", onPressed: _doRegister),
            ],
          ),
        ),
      ),
    );
  }
}
