import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonTitle;

  const RoundedButton(
      {super.key, required this.onPressed, required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      padding: const EdgeInsets.all(20),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: secondaryColor,
          foregroundColor: roundedButtonFontColor,
        ),
        child: Text(
          buttonTitle,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
