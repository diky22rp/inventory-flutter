import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/core/widgets/custom_button.dart';
import 'package:inventory_flutter/core/widgets/custom_textfield.dart';
import 'package:inventory_flutter/features/auth/cubit/auth_cubit.dart';
import 'package:inventory_flutter/features/auth/pages/register_page.dart';
// import 'package:inventory_flutter/features/auth/provider/auth_notifier.dart';
import 'package:inventory_flutter/features/main_layout/main_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool isLoading = false;
  String? errorText;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  void _doLogin() async {
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      setState(() => errorText = 'Email and password cannot be empty.');
      return;
    }

    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      await context.read<AuthCubit>().login(
        emailC.text.trim(),
        passC.text.trim(),
      );
    } catch (e) {
      setState(() {
        errorText = e.toString();
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
          );
        } else if (state is AuthFailure) {
          print(state);
          setState(() {
            errorText = state.message;
          });
        }
      },
      child: Scaffold(
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
                const SizedBox(height: 12),
                if (errorText != null)
                  Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 24),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(text: "Login", onPressed: _doLogin),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
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
      ),
    );
  }
}
