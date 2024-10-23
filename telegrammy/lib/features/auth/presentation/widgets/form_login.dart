import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/cores/services/service_locator.dart';
import 'package:telegrammy/cores/styles/styles.dart';

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
          TextFormField(
            decoration: InputDecoration(
              label: Text(
                'Email address',
                style: TextStyle(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, // Color when focused
                  width: 1, // Width when focused
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
            onSaved: (newValue) {
              email = newValue;
            },
          ),
          SizedBox(
            height: 22,
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text(
                'Password',
                style: TextStyle(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey, // Color when focused
                  width: 1, // Width when focused
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onSaved: (newValue) {
              password = newValue;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            child: Text('Forgot password?'),
            alignment: Alignment.bottomRight,
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: login,
            style: TextButton.styleFrom(
              backgroundColor: backGroundColor, // Background color
            ),
            child: Container(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text(
                  'Log in',
                  style: textStyle16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
