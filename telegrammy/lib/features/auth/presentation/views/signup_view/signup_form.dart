import 'package:flutter/material.dart';
import 'package:telegrammy/cores/widgets/custom_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.phoneNumController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: usernameController,
            hintText: 'Username',
            obsecureText: false,
            prefixIcon: Icons.person,
            validator: (value) =>
                value!.isEmpty ? 'Username is required' : null,
          ),
          CustomTextField(
            controller: emailController,
            hintText: 'Email',
            obsecureText: false,
            prefixIcon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              final emailRegex =
                  RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
              return !emailRegex.hasMatch(value) ? 'Enter a valid email' : null;
            },
          ),
          CustomTextField(
            controller: phoneNumController,
            hintText: 'Phone Number',
            obsecureText: false,
            prefixIcon: Icons.phone,
            validator: (value) =>
                value!.isEmpty ? 'Phone number is required' : null,
          ),
          CustomTextField(
            controller: passwordController,
            hintText: 'Password',
            obsecureText: true,
            prefixIcon: Icons.lock,
            validator: (value) => value!.length < 6
                ? 'Password must be at least 6 characters'
                : null,
          ),
          CustomTextField(
            controller: confirmPasswordController,
            hintText: 'Confirm Password',
            obsecureText: true,
            prefixIcon: Icons.lock_outline,
            validator: (value) => value != passwordController.text
                ? 'Passwords do not match'
                : null,
          ),
        ],
      ),
    );
  }
}
