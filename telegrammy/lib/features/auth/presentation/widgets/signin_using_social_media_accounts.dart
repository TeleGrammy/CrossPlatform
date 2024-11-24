import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/widgets/customSigninButton.dart';

class SignInUsingSocialMediaAccounts extends StatelessWidget {
  const SignInUsingSocialMediaAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Customsigninbutton(
          key: const ValueKey('googleSignInButton'),
          icon: FontAwesomeIcons.google,
          signinWithSocialAccount:
              context.read<LoginCubit>().signinWithGoogleCubit,
        ),
        Customsigninbutton(
          key: const ValueKey('githubSignInButton'),
          icon: FontAwesomeIcons.github,
          signinWithSocialAccount:
              context.read<LoginCubit>().signinWithGithubCubit,
        ),
      ],
    );
  }
}
