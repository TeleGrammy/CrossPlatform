import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/widgets/custom_text_field.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({
    super.key,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    context.goNamed(RouteNames.home);

    // final response = await getit
    //     .get<Dio>()
    //     .post('path to backend', data: {'email': email, 'password': password});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: emailController,
            hintText: 'Email address',
            obsecureText: false,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              // Basic email validation
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            prefixIcon: Icons.email,
          ),
          CustomTextField(
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
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Forgot password?',
              style: textStyle13,
            ),
            alignment: Alignment.bottomRight,
          ),
          RoundedButton(onPressed: login, buttonTitle: 'Log in')
        ],
      ),
    );
  }
}
