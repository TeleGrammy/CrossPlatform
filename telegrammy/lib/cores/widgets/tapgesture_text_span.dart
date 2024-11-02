
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class TapGestureTextSpan extends StatelessWidget {
  final String actionText; //clickable highlighted Text
  final String? baseText; //normal text
  final GestureTapCallback onTap;

  const TapGestureTextSpan(
      {super.key,
      required this.actionText,
      this.baseText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: baseText,
          style: const TextStyle(
            color: Colors.black, // Color for the normal text
            fontSize: 20,
          ),
          children: [
            TextSpan(
              text: actionText, // The part that will be clickable
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
