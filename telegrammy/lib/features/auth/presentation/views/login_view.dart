import 'package:flutter/material.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/cores/widgets/logo.dart';
import 'package:telegrammy/features/auth/presentation/widgets/form_login.dart';
import 'package:telegrammy/features/auth/presentation/widgets/row_divider.dart';
import 'package:telegrammy/features/auth/presentation/widgets/signin_using_social_media_accounts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
