import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/route_names.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  bool _isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSucess) {
          context.goNamed(RouteNames.sentResetPasswordSuccessfully);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          key: const ValueKey('appBar'),
          leading: IconButton(
            key: const ValueKey('backButton'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.goNamed(RouteNames.login),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/forgetPass.jpg',
                  key: const ValueKey('forgotPasswordImage'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Forgot Password?',
                  key: const ValueKey('forgotPasswordTitle'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Don't worry, it happens to the best of us.",
                  key: const ValueKey('forgotPasswordSubtitle'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  key: const ValueKey('emailField'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: const ValueKey('continueButton'),
                  onPressed: () {
                    String email = _emailController.text.trim();
                    if (_isEmailValid(email)) {
                      context.read<LoginCubit>().forgetPassword(email);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid email address.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Continue'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
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
