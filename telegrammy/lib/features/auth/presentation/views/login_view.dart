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
          context.goNamed(RouteNames.home); // Navigate to home on success
        } else if (state is LoginError) {
          // Show error message on failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 50),
          child: Column(
            children: [
              logo(),
              SizedBox(
                height: 30,
              ),
              FormLogin(),
              const SizedBox(
                height: 47,
              ),
              CustomRowDivider(),
              const SizedBox(
                height: 22,
              ),
              SignInUsingSocialMediaAccounts(),
              const Spacer(),
              Text('Don’t have an account? Sign up')
            ],
          ),
        ),
      ),
    );
  }
}
