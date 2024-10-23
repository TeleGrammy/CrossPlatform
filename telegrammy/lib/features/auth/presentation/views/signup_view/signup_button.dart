import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/features/auth/presentation/view_models/cubit/signup_cubit.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.captchaToken,
    required this.formkey,
  });

  final GlobalKey<FormState> formkey;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String? captchaToken;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state is SignUpSuccess) {
          context.goNamed(
            RouteNames.emailVerification,
            queryParameters: {'email': email},
          );
        }
      },
      child: RoundedButton(
        onPressed: () {
          if (formkey.currentState!.validate() &&
              captchaToken != null &&
              captchaToken!.isNotEmpty) {
            // Call the signup function and pass only the required text
            context.read<SignUpCubit>().signUpUser({
              'name': username,
              'email': email,
              'phone': phoneNumber,
              'password': password,
              'confirmPassword': confirmPassword,
              'captcha': captchaToken,
            });
          }
        },
        buttonTitle: 'Sign Up',
      ),
    );
  }
}
