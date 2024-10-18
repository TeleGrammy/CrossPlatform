import 'package:flutter/material.dart';
import 'package:telegrammy/common/widgets/custom_text_field.dart';
import 'package:telegrammy/common/widgets/tapgesture_text_span.dart';
import 'package:telegrammy/common/widgets/logo.dart';
import 'package:telegrammy/common/widgets/rounded_button.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Logo(),
          const SizedBox(
            height: 10,
          ),

          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obsecureText: false,
                  prefixIcon: Icons.person,
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obsecureText: false,
                  prefixIcon: Icons.mail,
                ),
                CustomTextField(
                  controller: phoneNumController,
                  hintText: 'Phone Number',
                  obsecureText: false,
                  prefixIcon: Icons.phone,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                  prefixIcon: Icons.lock,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          //I am not a robot verification

          RoundedButton(
            onPressed: () {},
            buttonTitle: 'Sign Up',
          ),

          //horizontal divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 1,
              color: secondaryColor,
            ),
          ),

          TapGestureTextSpan(
            baseText: 'Already ave an account? ',
            actionText: 'Login',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
