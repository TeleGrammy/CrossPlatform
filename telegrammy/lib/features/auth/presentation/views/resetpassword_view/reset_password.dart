import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/routes/app_routes.dart';
import 'package:telegrammy/cores/routes/routes_name.dart';
import 'package:telegrammy/features/auth/presentation/view_models/login_cubit/login_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  bool _isEmailValid(String email) {
    // Simple email regex for validation
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.goNamed(RouteNames.login),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              // SvgPicture.asset(
              //   'assets/forgot_password_illustration.svg', // Replace with your SVG path
              //   height: 150,
              // ),
              SizedBox(height: 20),
              // Title
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                "Don't worry, it happens to the best of us.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              // Email Input Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              // Continue Button
              ElevatedButton(
                onPressed: () {
                  // Validate email before proceeding
                  String email = _emailController.text.trim();
                  if (_isEmailValid(email)) {
                    context.read<LoginCubit>().forgetPassword(email);
                  } else {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid email address.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
