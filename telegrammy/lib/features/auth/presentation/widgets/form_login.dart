import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/cores/services/auth_api_service.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/widgets/custom_text_field.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/features/auth/data/repos/auth_repo_implemention.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final userData = {
      'UUID': emailController.text,
      'password': passwordController.text,
    };
    context.read<LoginCubit>().signInUser(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            inputFieldKey: const Key('UUIDField'),
            controller: emailController,
            hintText: 'Email address',
            obsecureText: false,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            prefixIcon: Icons.email,
          ),
          CustomTextField(
            inputFieldKey: const Key('passwordField'),
            controller: passwordController,
            hintText: 'Password',
            obsecureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            prefixIcon: Icons.lock,
          ),
          Container(
            key: const Key('forgotPasswordLink'),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                context.goNamed(RouteNames.resetPassword);
              },
              child: const Text(
                'Forgot password?',
                style: textStyle13,
              ),
            ),
          ),
          RoundedButton(
            key: const Key('loginButton'),
            onPressed: login,
            buttonTitle: 'Log in',
            buttonKey: Key('loginButton'),
          ),
        ],
      ),
    );
  }
}
