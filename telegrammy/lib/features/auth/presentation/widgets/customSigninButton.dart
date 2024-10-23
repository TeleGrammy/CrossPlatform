import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';

class Customsigninbutton extends StatelessWidget {
  final IconData icon;
  final Future<void> Function() signinWithSocialAccount;
  const Customsigninbutton({super.key, required this.icon,required this.signinWithSocialAccount});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSucess) {
          context.goNamed(RouteNames.home); // Navigate to home on success
        } else if (state is LoginError) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.errorMessage), // Assuming state has errorMessage
          //   ),
          // );
        }
      },
      child: Container(
        width: 108,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        child: IconButton(
          onPressed: () {
            // context.read<LoginCubit>().signinWithGoogleCubit(); // Trigger Google sign-in
            signinWithSocialAccount();
          },
          icon: Icon(
            icon,
            size: 25.0, // Icon size
          ),
        ),
      ),
    );
  }
}
