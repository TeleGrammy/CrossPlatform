import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/cores/widgets/logo.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/widgets/form_login.dart';
import 'package:telegrammy/features/auth/presentation/widgets/row_divider.dart';
import 'package:telegrammy/features/auth/presentation/widgets/signin_using_social_media_accounts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSucess) {
          context.goNamed(RouteNames.home);
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Adjust layout when keyboard appears
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              top: 30,
              bottom: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logo(key: const ValueKey('logo')),
                const SizedBox(height: 30),
                FormLogin(key: const ValueKey('form_login')),
                const SizedBox(height: 47),
                CustomRowDivider(key: const ValueKey('row_divider')),
                const SizedBox(height: 22),
                SignInUsingSocialMediaAccounts(
                  key: const ValueKey('signin_social_media'),
                ),
                const SizedBox(height: 40), // Additional space for scrolling
                Center(
                  child: RichText(
                    key: const ValueKey('signup_text'),
                    text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
