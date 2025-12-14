import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/core/widgets/custom_button.dart';
import 'package:inventory_flutter/core/widgets/custom_textfield.dart';
import 'package:inventory_flutter/features/auth/cubit/auth_cubit.dart';
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
  String? errorText;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  void _doRegister() {
    if (passC.text != confirmC.text) {
      setState(() {
        errorText = "Password and confirmation do not match.";
      });
      return;
    }

    context.read<AuthCubit>().register(emailC.text.trim(), passC.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
            (_) => false,
          );
        } else if (state is AuthFailure) {
          setState(() {
            errorText = state.message;
          });
        }
      },
      child: Scaffold(
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
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomButton(
                      text: "Register",
                      onPressed: _doRegister,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
