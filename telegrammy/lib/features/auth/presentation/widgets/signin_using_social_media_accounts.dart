import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:telegrammy/features/auth/presentation/widgets/customSigninButton.dart';

class SignInUsingSocialMediaAccounts extends StatelessWidget {
  const SignInUsingSocialMediaAccounts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Customsigninbutton(
          icon: FontAwesomeIcons.facebook,
          signinWithSocialAccount:
              context.read<LoginCubit>().signinWithFacebookCubit,
        ),
        Customsigninbutton(
          icon: FontAwesomeIcons.google,
          signinWithSocialAccount:
              context.read<LoginCubit>().signinWithGoogleCubit,
        ),
        Customsigninbutton(
            icon: FontAwesomeIcons.github,
            signinWithSocialAccount:
                context.read<LoginCubit>().signinWithGithubCubit),
      ],
    );
  }
}