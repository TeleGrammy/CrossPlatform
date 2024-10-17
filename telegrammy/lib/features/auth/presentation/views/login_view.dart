import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';
import 'package:telegrammy/cores/styles/styles.dart';
import 'package:telegrammy/features/auth/presentation/widgets/customSigninButton.dart';

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
            Image.asset(
              'assets/images/logo.png',
              width: 121,
              height: 133,
            ),
            Align(
              child: Text("Log in", style: textStyle30),
              alignment: Alignment.topLeft,
            ),
            SizedBox(
              height: 30,
            ),
            Form(
                child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    label: Text(
                      'Email address',
                      style: TextStyle(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // Color when focused
                        width: 1, // Width when focused
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text(
                      'Password',
                      style: TextStyle(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // Color when focused
                        width: 1, // Width when focused
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text('Forgot password?'),
                  alignment: Alignment.bottomRight,
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: backGroundColor, // Background color
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Log in',
                        style: textStyle16,
                      ),
                    ),
                  ),
                )
              ],
            )),
            const SizedBox(
              height: 47,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey, // Line color
                    height: 1, // Line height
                    thickness: 1, // Line thickness
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Or Login with'),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey, // Line color
                    height: 1, // Line height
                    thickness: 1, // Line thickness
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Customsigninbutton(
                  icon: FontAwesomeIcons.facebook,
                ),
                Customsigninbutton(icon: FontAwesomeIcons.google),
                Customsigninbutton(icon: FontAwesomeIcons.github),
              ],
            ),
            const Spacer(),
            Text('Don’t have an account? Sign up')
          ],
        ),
      ),
    );
  }
}
