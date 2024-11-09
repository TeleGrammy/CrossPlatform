import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
// import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:uni_links/uni_links.dart';

class Customsigninbutton extends StatefulWidget {
  final IconData icon;
  final Future<void> Function() signinWithSocialAccount;
  const Customsigninbutton(
      {super.key, required this.icon, required this.signinWithSocialAccount});

  @override
  State<Customsigninbutton> createState() => _CustomsigninbuttonState();
}

class _CustomsigninbuttonState extends State<Customsigninbutton> {
  StreamSubscription? _sub;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleIncomingLinks();
  }

  // Handle incoming links
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('Received deep link: $uri');
      }
    }, onError: (err) {
      debugPrint('Error: $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSucess) {
          // context.goNamed(RouteNames.home); // Navigate to home on success
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
          onPressed: () async {
            // context.read<LoginCubit>().signinWithGoogleCubit(); // Trigger Google sign-in
            widget.signinWithSocialAccount();
          },
          icon: Icon(
            widget.icon,
            size: 25.0, // Icon size
          ),
        ),
      ),
    );
  }
}
