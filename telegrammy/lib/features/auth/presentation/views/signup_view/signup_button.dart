import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/widgets/rounded_button.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/auth/presentation/view_models/signup_cubit/signup_cubit.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.phoneNumController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.captchaToken,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneNumController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? captchaToken;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state is SignUpSuccess) {
          context.goNamed(
            RouteNames.emailVerification,
          );
        }
        if (state is SignUpLoading) {
          print('loading');
        }
      },
      child: RoundedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            context.read<SignUpCubit>().signUpUser({
              'username': usernameController.text,
              'email': emailController.text,
              'phone': phoneNumController.text,
              'password': passwordController.text,
              'passwordConfirm': confirmPasswordController.text,
              'captcha': captchaToken,
            });
          }
        },
        buttonTitle: 'Sign Up',
        buttonKey: Key('signUpButton'),
      ),
    );
  }
}
