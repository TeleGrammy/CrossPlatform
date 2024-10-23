import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegrammy/cores/widgets/tapgesture_text_span.dart';
import 'package:telegrammy/cores/widgets/logo.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/features/auth/presentation/view_models/cubit/signup_cubit.dart';
import 'package:telegrammy/features/auth/presentation/views/signup_view/signup_button.dart';
import 'package:telegrammy/features/auth/presentation/views/signup_view/signup_form.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  String? captchaToken;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneNumController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Logo(),
            const SizedBox(
              height: 10,
            ),

            SignUpForm(
              formKey: _formKey,
              usernameController: usernameController,
              emailController: emailController,
              phoneNumController: phoneNumController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
            ),

            const SizedBox(height: 20),

            // I am not a robot verification
            SizedBox(
              height: 100,
              child: WebViewPlus(
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  controller.loadUrl("assets/webpages/index.html");
                },
                javascriptChannels: {
                  JavascriptChannel(
                      name: 'Captcha',
                      onMessageReceived: (JavascriptMessage message) {
                        setState(() {
                          captchaToken = message.message; //captcha token
                        });
                      })
                },
              ),
            ),

            //errors message box
            BlocBuilder<SignUpCubit, SignUpState>(
              builder: (context, state) {
                if (state is SignUpFailure) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: errorColor, fontSize: 16),
                    ),
                  );
                }
                return const SizedBox.shrink(); // No error, return empty widget
              },
            ),

            SignUpButton(
              formkey: _formKey,
              captchaToken: captchaToken,
              username: usernameController.text,
              email: emailController.text,
              phoneNumber: phoneNumController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
            ),

            //horizontal divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                height: 1,
                color: secondaryColor,
              ),
            ),

            TapGestureTextSpan(
              baseText: 'Already have an account? ',
              actionText: 'Login',
              onTap: () {
                //navigate to the login page
              },
            ),
          ],
        ),
      ),
    );
  }
}