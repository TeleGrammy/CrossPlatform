import 'package:flutter/material.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final String hintText;
  final bool obsecureText;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.prefixIcon,
      required this.hintText,
      required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            hintStyle: const TextStyle(
              color: hintTextColor,
            )).copyWith(
          prefixIcon: Icon(
            prefixIcon,
            color: primaryColor,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
